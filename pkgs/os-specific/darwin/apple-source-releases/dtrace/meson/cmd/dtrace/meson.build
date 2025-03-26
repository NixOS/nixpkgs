dtrace = executable(
  'dtrace',
  files('dtrace.c'),
  c_args : [ '-Wno-format-security' ],
  dependencies : [
    libdtrace_dep,
    libproc_dep,
    libelf_dep,
    libctf_dep,
    darwin_shim_dep,
    corefoundation_dep,
    iokit_dep,
  ],
  install : true,
)
