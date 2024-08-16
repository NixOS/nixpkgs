{ mkDerivation, ... }:
mkDerivation {
  path = "usr.sbin/pwd_mkdb";

  extraPaths = [ "lib/libc/gen" ];
}
