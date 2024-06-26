// RUN: mlir-opt -split-input-file -transform-interpreter %s | FileCheck %s

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(%root : !transform.any_op {transform.readonly}) {
    %func_op = transform.structured.match ops{["func.func"]} in %root : (!transform.any_op) -> !transform.op<"func.func">
    transform.apply_patterns to %func_op {
      transform.apply_patterns.tensor.fold_tensor_subset_ops_into_vector_transfers
    } : !transform.op<"func.func">
    transform.yield
  }
}

// CHECK: #[[$map:.*]] = affine_map<()[s0] -> (s0 + 4)>
// CHECK: #[[$map1:.*]] = affine_map<()[s0] -> (s0 + 3)>
// CHECK: #[[$map2:.*]] = affine_map<(d0, d1, d2) -> (d0, d2)>

// CHECK-LABEL: func @transfer_read_of_extract_slice(
//  CHECK-SAME:     %[[t:.*]]: tensor<?x?xf32>, %[[s1:.*]]: index, %[[s2:.*]]: index
//   CHECK-DAG:   %[[c8:.*]] = arith.constant 8 : index
//       CHECK:   %[[add:.*]] = affine.apply #[[$map]]()[%[[s1]]]
//       CHECK:   %[[r:.*]] = vector.transfer_read %[[t]][%[[c8]], %[[add]]], %{{.*}} {in_bounds = [true, true]} : tensor<?x?xf32>, vector<5x6xf32>
//       CHECK:   return %[[r]]
func.func @transfer_read_of_extract_slice(%t : tensor<?x?xf32>, %s1 : index, %s2 : index) -> vector<5x6xf32> {
  %c3 = arith.constant 3 : index
  %c4 = arith.constant 4 : index
  %cst = arith.constant 0.0 : f32
  %0 = tensor.extract_slice %t[5, %s1] [10, %s2] [1, 1] : tensor<?x?xf32> to tensor<10x?xf32>
  %1 = vector.transfer_read %0[%c3, %c4], %cst {in_bounds = [true, true]} : tensor<10x?xf32>, vector<5x6xf32>
  return %1 : vector<5x6xf32>
}

// CHECK-LABEL: func @transfer_read_of_extract_slice_1d(
//  CHECK-SAME:     %[[t:.*]]: tensor<?x?xf32>, %[[s1:.*]]: index, %[[s2:.*]]: index
//   CHECK-DAG:   %[[c8:.*]] = arith.constant 8 : index
//       CHECK:   %[[add:.*]] = affine.apply #[[$map]]()[%[[s1]]]
//       CHECK:   %[[r:.*]] = vector.transfer_read %[[t]][%[[c8]], %[[add]]], %{{.*}} {in_bounds = [true]} : tensor<?x?xf32>, vector<6xf32>
//       CHECK:   return %[[r]]
func.func @transfer_read_of_extract_slice_1d(%t : tensor<?x?xf32>, %s1 : index, %s2 : index) -> vector<6xf32> {
  %c3 = arith.constant 3 : index
  %c4 = arith.constant 4 : index
  %cst = arith.constant 0.0 : f32
  %0 = tensor.extract_slice %t[5, %s1] [10, %s2] [1, 1] : tensor<?x?xf32> to tensor<10x?xf32>
  %1 = vector.transfer_read %0[%c3, %c4], %cst {in_bounds = [true]} : tensor<10x?xf32>, vector<6xf32>
  return %1 : vector<6xf32>
}

// CHECK-LABEL: func @transfer_read_of_extract_slice_rank_reducing(
//  CHECK-SAME:     %[[t:.*]]: tensor<?x?x?xf32>, %[[s1:.*]]: index, %[[s2:.*]]: index
//   CHECK-DAG:   %[[c5:.*]] = arith.constant 5 : index
//   CHECK-DAG:   %[[c10:.*]] = arith.constant 10 : index
//       CHECK:   %[[add:.*]] = affine.apply #[[$map1]]()[%[[s1]]]
//       CHECK:   %[[r:.*]] = vector.transfer_read %[[t]][%[[c5]], %[[add]], %[[c10]]], %{{.*}} {in_bounds = [true, true]} : tensor<?x?x?xf32>, vector<5x6xf32>
//       CHECK:   return %[[r]]
func.func @transfer_read_of_extract_slice_rank_reducing(%t : tensor<?x?x?xf32>, %s1 : index, %s2 : index) -> vector<5x6xf32> {
  %c3 = arith.constant 3 : index
  %c4 = arith.constant 4 : index
  %cst = arith.constant 0.0 : f32
  %0 = tensor.extract_slice %t[5, %s1, 6] [1, %s2, 12] [1, 1, 1] : tensor<?x?x?xf32> to tensor<?x12xf32>
  %1 = vector.transfer_read %0[%c3, %c4], %cst {in_bounds = [true, true]} : tensor<?x12xf32>, vector<5x6xf32>
  return %1 : vector<5x6xf32>
}

// CHECK-LABEL: func @transfer_read_of_extract_slice_non_leading_rank_reduction(
//  CHECK-SAME:     %[[t:.*]]: tensor<?x?x?xf32>, %[[s1:.*]]: index, %[[s2:.*]]: index
//   CHECK-DAG:   %[[c8:.*]] = arith.constant 8 : index
//   CHECK-DAG:   %[[c10:.*]] = arith.constant 10 : index
//       CHECK:   %[[r:.*]] = vector.transfer_read %[[t]][%[[c8]], %[[s1]], %[[c10]]], %{{.*}} {in_bounds = [true, true], permutation_map = #[[$map2]]} : tensor<?x?x?xf32>, vector<5x6xf32>
//       CHECK:   return %[[r]]
func.func @transfer_read_of_extract_slice_non_leading_rank_reduction(%t : tensor<?x?x?xf32>, %s1 : index, %s2 : index) -> vector<5x6xf32> {
  %c3 = arith.constant 3 : index
  %c4 = arith.constant 4 : index
  %cst = arith.constant 0.0 : f32
  %0 = tensor.extract_slice %t[5, %s1, 6] [%s2, 1, 12] [1, 1, 1] : tensor<?x?x?xf32> to tensor<?x12xf32>
  %1 = vector.transfer_read %0[%c3, %c4], %cst {in_bounds = [true, true]} : tensor<?x12xf32>, vector<5x6xf32>
  return %1 : vector<5x6xf32>
}

// CHECK-LABEL: func @masked_transfer_read_of_extract_slice
//  CHECK-SAME:     %[[t:.*]]: tensor<?x?xf32>, %[[s1:.*]]: index, %[[s2:.*]]: index
//   CHECK-DAG: %[[m:.*]] = vector.create_mask{{.*}} : vector<5x6xi1>
//   CHECK-DAG: %[[a:.*]] = affine.apply {{.*}}[[s1]]
//       CHECK: vector.mask %[[m]] { vector.transfer_read %[[t]]{{.*}}: tensor<?x?xf32>, vector<5x6xf32> } : vector<5x6xi1> -> vector<5x6xf32>
func.func @masked_transfer_read_of_extract_slice(%t : tensor<?x?xf32>, %s1 : index, %s2 : index) -> vector<5x6xf32> {
  %c3 = arith.constant 3 : index
  %c4 = arith.constant 4 : index
  %cst = arith.constant 0.0 : f32
  %0 = tensor.extract_slice %t[5, %s1] [10, %s2] [1, 1] : tensor<?x?xf32> to tensor<10x?xf32>
  %mask = vector.create_mask %c3, %c4 : vector<5x6xi1>
  %1 = vector.mask %mask {vector.transfer_read %0[%c3, %c4], %cst {in_bounds = [true, true]} : tensor<10x?xf32>, vector<5x6xf32>} : vector<5x6xi1> -> vector<5x6xf32>
  return %1 : vector<5x6xf32>
}

// CHECK-LABEL: func @insert_slice_of_transfer_write(
//  CHECK-SAME:     %[[t1:.*]]: tensor<?x12xf32>, %[[v:.*]]: vector<5x6xf32>, %[[s:.*]]: index
//       CHECK:   %[[c3:.*]] = arith.constant 3 : index
//       CHECK:   %[[r:.*]] = vector.transfer_write %[[v]], %[[t1]][%[[c3]], %[[s]]] {in_bounds = [true, true]} : vector<5x6xf32>, tensor<?x12xf32>
//       CHECK:   return %[[r]]
func.func @insert_slice_of_transfer_write(%t1 : tensor<?x12xf32>, %v : vector<5x6xf32>, %s : index, %t2 : tensor<5x6xf32>) -> tensor<?x12xf32> {
  %c0 = arith.constant 0 : index
  %0 = vector.transfer_write %v, %t2[%c0, %c0] {in_bounds = [true, true]} : vector<5x6xf32>, tensor<5x6xf32>
  %1 = tensor.insert_slice %0 into %t1[3, %s] [5, 6] [1, 1] : tensor<5x6xf32> into tensor<?x12xf32>
  return %1 : tensor<?x12xf32>
}

// CHECK-LABEL: func @unit_insert_slice_of_unit_transfer_write(
//  CHECK-SAME:     %[[t1:.*]]: tensor<1x1x12xf32>, %[[v:.*]]: vector<1x6xf32>, %[[s:.*]]: index
//       CHECK:   %[[c0:.*]] = arith.constant 0 : index
//       CHECK:   %[[r:.*]] = vector.transfer_write %[[v]], %[[t1]][%[[c0]], %[[c0]], %[[s]]] {in_bounds = [true, true]} : vector<1x6xf32>, tensor<1x1x12xf32>
//       CHECK:   return %[[r]]
func.func @unit_insert_slice_of_unit_transfer_write(%t1 : tensor<1x1x12xf32>, %v : vector<1x6xf32>, %s : index, %t2 : tensor<1x6xf32>) -> tensor<1x1x12xf32> {
  %c0 = arith.constant 0 : index
  %0 = vector.transfer_write %v, %t2[%c0, %c0] {in_bounds = [true, true]} : vector<1x6xf32>, tensor<1x6xf32>
  %1 = tensor.insert_slice %0 into %t1[0, 0, %s] [1, 1, 6] [1, 1, 1] : tensor<1x6xf32> into tensor<1x1x12xf32>
  return %1 : tensor<1x1x12xf32>
}

// CHECK-LABEL: func @insert_slice_of_transfer_write_non_leading_rank_reduction(
//  CHECK-SAME:     %[[t1:.*]]: tensor<?x?x12xf32>, %[[v:.*]]: vector<5x6xf32>, %[[s:.*]]: index
//   CHECK-DAG:   %[[c3:.*]] = arith.constant 3 : index
//   CHECK-DAG:   %[[c4:.*]] = arith.constant 4 : index
//       CHECK:   %[[r:.*]] = vector.transfer_write %[[v]], %[[t1]][%[[c4]], %[[c3]], %[[s]]] {in_bounds = [true, true], permutation_map = #[[$map2]]} : vector<5x6xf32>, tensor<?x?x12xf32>
func.func @insert_slice_of_transfer_write_non_leading_rank_reduction(%t1 : tensor<?x?x12xf32>, %v : vector<5x6xf32>, %s : index, %t2 : tensor<5x6xf32>) -> tensor<?x?x12xf32> {
  %c0 = arith.constant 0 : index
  %0 = vector.transfer_write %v, %t2[%c0, %c0] {in_bounds = [true, true]} : vector<5x6xf32>, tensor<5x6xf32>
  %1 = tensor.insert_slice %0 into %t1[4, 3, %s] [5, 1, 6] [1, 1, 1] : tensor<5x6xf32> into tensor<?x?x12xf32>
  return %1 : tensor<?x?x12xf32>
}

// CHECK-LABEL: func @insert_slice_of_transfer_write_rank_extending(
//  CHECK-SAME:     %[[t1:.*]]: tensor<?x?x12xf32>, %[[v:.*]]: vector<5x6xf32>, %[[s:.*]]: index
//   CHECK-DAG:   %[[c3:.*]] = arith.constant 3 : index
//   CHECK-DAG:   %[[c4:.*]] = arith.constant 4 : index
//       CHECK:   %[[r:.*]] = vector.transfer_write %[[v]], %[[t1]][%[[c4]], %[[c3]], %[[s]]] {in_bounds = [true, true]} : vector<5x6xf32>, tensor<?x?x12xf32>
//       CHECK:   return %[[r]]
func.func @insert_slice_of_transfer_write_rank_extending(%t1 : tensor<?x?x12xf32>, %v : vector<5x6xf32>, %s : index, %t2 : tensor<5x6xf32>) -> tensor<?x?x12xf32> {
  %c0 = arith.constant 0 : index
  %0 = vector.transfer_write %v, %t2[%c0, %c0] {in_bounds = [true, true]} : vector<5x6xf32>, tensor<5x6xf32>
  %1 = tensor.insert_slice %0 into %t1[4, 3, %s] [1, 5, 6] [1, 1, 1] : tensor<5x6xf32> into tensor<?x?x12xf32>
  return %1 : tensor<?x?x12xf32>
}
