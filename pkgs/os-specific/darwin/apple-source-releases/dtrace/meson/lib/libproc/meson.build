libproc_sources = files(
  'libproc.c',
)
libproc_incdir = include_directories('.')

libproc = library(
  'dtrace_proc',
  libproc_sources,
  dependencies : [ libelf_dep, darwin_shim_dep ],
  include_directories : [ libproc_incdir ],
  darwin_versions : '1',
  install : true,
)

libproc_dep = declare_dependency(
  link_with : libproc,
  include_directories : [ libproc_incdir ],
)
