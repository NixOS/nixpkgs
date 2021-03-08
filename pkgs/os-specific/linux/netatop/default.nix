{ lib, stdenv, fetchurl, kernel, zlib }:

let
  version = "3.1";
in

stdenv.mkDerivation {
  name = "netatop-${kernel.version}-${version}";

  src = fetchurl {
    url = "http://www.atoptool.nl/download/netatop-${version}.tar.gz";
    sha256 = "0qjw8glfdmngfvbn1w63q128vxdz2jlabw13y140ga9i5ibl6vvk";
  };

  buildInputs = [ zlib ];

  hardeningDisable = [ "pic" ];

  preConfigure = ''
    patchShebangs mkversion
    sed -i -e 's,^KERNDIR.*,KERNDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build,' \
        */Makefile
    sed -i -e 's,/lib/modules.*extra,'$out'/lib/modules/${kernel.modDirVersion}/extra,' \
        -e s,/usr,$out, \
        -e /init.d/d \
        -e /depmod/d \
        -e /netatop.service/d \
        Makefile
  '';

  preInstall = ''
    mkdir -p $out/bin $out/sbin $out/share/man/man{4,8}
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
  '';

  meta = {
    description = "Network monitoring module for atop";
    homepage = "https://www.atoptool.nl/downloadnetatop.php";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [viric];
  };
}
