libctf_sources = files(
  'common/ctf_labels.c',
  'common/ctf_create.c',
  'common/ctf_util.c',
  'common/ctf_lib.c',
  'common/ctf_hash.c',
  'common/ctf_lookup.c',
  'common/ctf_subr.c',
  'common/ctf_decl.c',
  'common/ctf_error.c',
  'common/ctf_open.c',
  'common/ctf_types.c',
)

libctf_incdir = include_directories('./common')
libctf = library(
  'dtrace_ctf',
  libctf_sources,
  dependencies : [ libelf_dep, darwin_shim_dep ],
  include_directories : libctf_incdir,
  darwin_versions : '1',
  install : true,
)
libctf_dep = declare_dependency(
  link_with : libctf,
  include_directories : libctf_incdir,
)
