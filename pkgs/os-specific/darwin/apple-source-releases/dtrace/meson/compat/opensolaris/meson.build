darwin_shim = library(
  'dtrace_darwinshim',
  files('./darwin_shim.c'),
  darwin_versions : '1',
  install : true,
)

darwin_shim_dep = declare_dependency(
  link_with : darwin_shim,
  include_directories : include_directories('.', './sys'),
)
