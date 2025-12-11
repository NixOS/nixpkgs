{ mkDerivation, ... }:
mkDerivation {
  path = "usr.sbin/pwd_mkdb";

  extraPaths = [ "lib/libc/gen" ];

  meta.mainProgram = "pwd_mkdb";
}
