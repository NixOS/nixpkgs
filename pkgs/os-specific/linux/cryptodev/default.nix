{ fetchurl, stdenv, kernel, onlyHeaders ? false }:

stdenv.mkDerivation rec {
  pname = "cryptodev-linux-1.9";
  name = "${pname}-${kernel.version}";

  src = fetchurl {
    urls = [
      "http://nwl.cc/pub/cryptodev-linux/${pname}.tar.gz"
      "http://download.gna.org/cryptodev-linux/${pname}.tar.gz"
    ];
    sha256 = "0l3r8s71vkd0s2h01r7fhqnc3j8cqw4msibrdxvps9hfnd4hnk4z";
  };

  hardeningDisable = [ "pic" ];

  KERNEL_DIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  INSTALL_MOD_PATH = "\${out}";
  prefix = "\${out}";

  meta = {
    description = "Device that allows access to Linux kernel cryptographic drivers";
    homepage = http://home.gna.org/cryptodev-linux/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
