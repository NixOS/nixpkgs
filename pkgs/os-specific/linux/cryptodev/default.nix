{ fetchFromGitHub, lib, stdenv, kernel ? false }:

stdenv.mkDerivation rec {
  pname = "cryptodev-linux-1.11";
  name = "${pname}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "cryptodev-linux";
    repo = "cryptodev-linux";
    rev = pname;
    sha256 = "1ky850qiyacq8p3lng7n3w6h3x2clqrz4lkv2cv3psy92mg9pvc9";
  };

  hardeningDisable = [ "pic" ];

  KERNEL_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = "\${out}";
  prefix = "\${out}";

  meta = {
    description = "Device that allows access to Linux kernel cryptographic drivers";
    homepage = "http://cryptodev-linux.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
