libelf_sources = files(
  'begin.c',
  'clscook.c',
  'clscook_ELF64.c',
  'cntl.c',
  'cook.c',
  'data.c',
  'end.c',
  'error.c',
  'gelf.c',
  'getdata.c',
  'getehdr.c',
  'getident.c',
  'getscn.c',
  'getshdr.c',
  'getshstrndx.c',
  'input.c',
  'kind.c',
  'ndxscn.c',
  'nextscn.c',
  'strptr.c',
  'xlate.c',
  'xlate64.c',
)
libelf_incdir = include_directories('.')
libelf = library(
  'dtrace_elf',
  libelf_sources,
  dependencies : [ darwin_shim_dep ],
  include_directories : [ libelf_incdir ],
  darwin_versions : '1',
  install : true,
)
libelf_dep = declare_dependency(
  link_with : libelf,
  include_directories : [ libelf_incdir ],
)
