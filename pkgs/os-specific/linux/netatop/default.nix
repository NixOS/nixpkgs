{ stdenv, fetchurl, kernel, zlib }:

stdenv.mkDerivation {
  name = "netatop-${kernel.version}-0.3";

  src = fetchurl {
    url = http://www.atoptool.nl/download/netatop-0.3.tar.gz;
    sha256 = "0rk873nb1hgfnz040plmv6rm9mcm813n0clfjs53fsqbn8y1lhvv";
  };

  buildInputs = [ zlib ];

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
