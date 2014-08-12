{ fetchurl, stdenv, kernel, onlyHeaders ? false }:

stdenv.mkDerivation rec {
  pname = "cryptodev-linux-1.6";
  name = "${pname}-${kernel.version}";

  src = fetchurl {
    url = "http://download.gna.org/cryptodev-linux/${pname}.tar.gz";
    sha256 = "0bryzdb4xz3fp2q00a0mlqkj629md825lnlh4gjwmy51irf45wbm";
  };

  buildPhase = if !onlyHeaders then ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      SUBDIRS=`pwd` INSTALL_PATH=$out
  '' else ":";

  installPhase = stdenv.lib.optionalString (!onlyHeaders) ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      INSTALL_MOD_PATH=$out SUBDIRS=`pwd` modules_install
  '' + ''
    mkdir -p $out/include/crypto
    cp crypto/cryptodev.h $out/include/crypto
  '';

  meta = {
    description = "Device that allows access to Linux kernel cryptographic drivers";
    homepage = http://home.gna.org/cryptodev-linux/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
