{
  lib,
  buildBatExtrasPkg,
  shfmt,
  clang-tools,
  prettier,
  rustfmt,

  withShFmt ? true,
  withPrettier ? true,
  withClangTools ? true,
  withRustFmt ? true,
}:
buildBatExtrasPkg {
  name = "prettybat";
  dependencies =
    lib.optional withShFmt shfmt
    ++ lib.optional withPrettier prettier
    ++ lib.optional withClangTools clang-tools
    ++ lib.optional withRustFmt rustfmt;
  meta.description = "Pretty-print source code and highlight it with bat";
}
