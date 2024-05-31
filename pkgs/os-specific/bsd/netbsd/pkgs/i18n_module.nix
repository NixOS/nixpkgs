{
  lib,
  mkDerivation,
  libc,
}:

mkDerivation {
  path = "lib/i18n_module";
  version = "9.2";
  sha256 = "0w6y5v3binm7gf2kn7y9jja8k18rhnyl55cvvfnfipjqdxvxd9jd";
  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ libc.src ];
}
