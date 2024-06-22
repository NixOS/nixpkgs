{
  lib,
  mkDerivation,
  libc,
}:

mkDerivation {
  path = "lib/i18n_module";
  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ libc.path ];
}
