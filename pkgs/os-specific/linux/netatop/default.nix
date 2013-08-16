{ stdenv, fetchurl, kernelDev, zlib }:

stdenv.mkDerivation {
  name = "netatop-${kernelDev.version}-0.3";

  src = fetchurl {
    url = http://www.atoptool.nl/download/netatop-0.3.tar.gz;
    sha256 = "0rk873nb1hgfnz040plmv6rm9mcm813n0clfjs53fsqbn8y1lhvv";
  };

  buildInputs = [ zlib ];

  preConfigure = ''
    patchShebangs mkversion
    sed -i -e 's,^KERNDIR.*,KERNDIR=${kernelDev}/lib/modules/${kernelDev.modDirVersion}/build,' \
        */Makefile
    sed -i -e 's,/lib/modules.*extra,'$out'/lib/modules/${kernelDev.modDirVersion}/extra,' \
        -e s,/usr,$out, \
        -e /init.d/d \
        -e /depmod/d \
        Makefile
  '';

  preInstall = ''
    ensureDir $out/bin $out/sbin $out/share/man/man{4,8}
    ensureDir $out/lib/modules/${kernelDev.modDirVersion}/extra
  '';
      
  meta = {
    description = "Network monitoring module for atop";
    homepage = http://www.atoptool.nl/downloadnetatop.php;
    license = "GPL2";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
