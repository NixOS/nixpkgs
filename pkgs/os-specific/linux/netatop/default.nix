{ stdenv, fetchurl, kernel, zlib }:

let
  version = "1.0";
in

stdenv.mkDerivation {
  name = "netatop-${kernel.version}-${version}";

  src = fetchurl {
    url = "http://www.atoptool.nl/download/netatop-${version}.tar.gz";
    sha256 = "1l7xs3hnfbk6h5gdrw1ikfa0fvfpb5vd447xhwfllvicblqyip8b";
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
        Makefile
  '';

  preInstall = ''
    mkdir -p $out/bin $out/sbin $out/share/man/man{4,8}
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
  '';

  meta = {
    description = "Network monitoring module for atop";
    homepage = http://www.atoptool.nl/downloadnetatop.php;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
