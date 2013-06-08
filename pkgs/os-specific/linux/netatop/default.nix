{ stdenv, fetchurl, kernelDev, zlib }:

stdenv.mkDerivation {
  name = "netatop-${kernelDev.version}-0.2";

  src = fetchurl {
    url = http://www.atoptool.nl/download/netatop-0.2.tar.gz;
    sha256 = "0ya4qys2qpw080sbgixyx1kawdx1c3smnxwmqcchn0hg9hhndvc0";
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
    ensureDir $out/bin $out/share/man/man{4,8}
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
