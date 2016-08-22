{ fetchurl, stdenv, kernel, onlyHeaders ? false }:

stdenv.mkDerivation rec {
  pname = "cryptodev-linux-1.8";
  name = "${pname}-${kernel.version}";

  src = fetchurl {
    url = "http://download.gna.org/cryptodev-linux/${pname}.tar.gz";
    sha256 = "0xhkhcdlds9aiz0hams93dv0zkgcn2abaiagdjlqdck7zglvvyk7";
  };

  hardeningDisable = [ "pic" ];

  KERNEL_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = "\${out}";
  PREFIX = "\${out}";

  meta = {
    description = "Device that allows access to Linux kernel cryptographic drivers";
    homepage = http://home.gna.org/cryptodev-linux/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
