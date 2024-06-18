{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libcrypt";
  version = "9.2";
  sha256 = "0siqan1wdqmmhchh2n8w6a8x1abbff8n4yb6jrqxap3hqn8ay54g";
  SHLIBINSTALLDIR = "$(out)/lib";
  meta.platforms = lib.platforms.netbsd;
}
