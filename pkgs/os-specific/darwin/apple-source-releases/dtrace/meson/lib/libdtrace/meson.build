libdtrace_lexer = lex.process('common/dt_lex.l')
libdtrace_parser = yacc.process('common/dt_grammar.y')

libdtrace_sources = files(
  'apple/dt_ld.cpp',
  'apple/dt_subr_apple.c',
  'apple/dt_provider_apple.c',
  'apple/dt_pid_apple.c',
  'apple/dt_proc_apple.c',
  'apple/dt_module_apple.c',
  'i386/dt_isadep.c',
  'i386/dis_tables.c',
  'common/dt_consume.c',
  'common/dt_parser.c',
  'common/dt_dof.c',
  'common/dt_program.c',
  'common/dt_work.c',
  'common/dt_errtags.c',
  'common/dt_subr.c',
  'common/dt_proc.c',
  'common/dt_sugar.c',
  'common/dt_decl.c',
  'common/dt_pid.c',
  'common/dt_names.c',
  'common/dt_ident.c',
  'common/dt_print.c',
  'common/dt_open.c',
  'common/dt_pcb.c',
  'common/dt_pq.c',
  'common/dt_list.c',
  'common/dt_regset.c',
  'common/dt_module.c',
  'common/dt_as.c',
  'common/dt_map.c',
  'common/dt_dis.c',
  'common/dt_string.c',
  'common/dt_options.c',
  'common/dt_cg.c',
  'common/dt_error.c',
  'common/dt_provider.c',
  'common/dt_printf.c',
  'common/dt_strtab.c',
  'common/dt_cc.c',
  'common/dt_inttab.c',
  'common/dt_handle.c',
  'common/dt_aggregate.c',
  'common/dt_buf.c',
  'common/dt_xlator.c',
  'common/dt_pragma.c',
  'arm/dt_isadep.c',
)

libdtrace_incdir = include_directories('./common')

libdtrace = library(
  'dtrace',
  libdtrace_sources,
  libdtrace_lexer,
  libdtrace_parser,
  dependencies : [ libctf_dep, libelf_dep, libproc_dep, darwin_shim_dep ],
  include_directories : [ libdtrace_incdir ],
  darwin_versions : '1',
  install : true,
)

libdtrace_dep = declare_dependency(
  link_with : libdtrace,
  include_directories : [ libdtrace_incdir ],
)
