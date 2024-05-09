#include "Pika/PikaDbg.h"
#include "ConcatOutputSection.h"
#include "Config.h"
#include "InputFiles.h"
#include "InputSection.h"
#include "OutputSegment.h"
#include "Symbols.h"

#include "lld/Common/ErrorHandler.h"

using namespace lld::macho;

void lld::macho::onConstruct_InputSection(InputSection *pThis) {
  static uint32_t sectionIndex = 0;
  pThis->_inx = ++sectionIndex;
  pThis->_dbg = std::to_string(pThis->_inx);
  pThis->_dbg += ".";
  pThis->_dbg += pThis->section.name;
}

void lld::macho::onAfterGatherInputSections() {
  for (auto *isec : inputSections) {
    std::string maxSymName = "";
    for (auto *sym : isec->symbols) {
      if (sym->getName().starts_with("ltmp"))
        continue;
      if (sym->getName().starts_with("_ltmp"))
        continue;
      if (sym->getName().size() > maxSymName.size()) {
        maxSymName = sym->getName();
      }
    }
    if (maxSymName.size() > 0) {
      isec->_dbg += "." + maxSymName;
    }
  }
}
