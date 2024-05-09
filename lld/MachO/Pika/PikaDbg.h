namespace lld::macho {
class InputSection;

void onConstruct_InputSection(InputSection *pThis);
void onAfterGatherInputSections();
} // namespace lld::macho
