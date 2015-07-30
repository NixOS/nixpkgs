{ stdenv, fetchurl, kernel, which }:

assert stdenv.isLinux;
# Don't bother with older versions, though some would probably work:
assert stdenv.lib.versionAtLeast kernel.version "4.0";
# Disable on grsecurity kernels, which break module building:
assert !kernel.features ? grsecurity;

let version = "0.4.0-rev17"; in
stdenv.mkDerivation {
  name = "linux-phc-intel-${version}-${kernel.version}";

  src = fetchurl {
    sha256 = "1fdfpghnsa5s98lisd2sn0vplrq0n54l0pkyyzkyb77z4fa6bs4p";
    url = "http://www.linux-phc.org/forum/download/file.php?id=166";
    name = "phc-intel-pack-rev17.tar.bz2";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "Undervolting kernel driver for Intel processors";
    longDescription = ''
      PHC is a Linux kernel patch to undervolt processors. This can divide the
      power consumption of the CPU by two or more, increasing battery life
      while noticably reducing fan noise. This driver works only on supported
      Intel architectures.
    '';
    homepage = http://www.linux-phc.org/;
    downloadPage = "http://www.linux-phc.org/forum/viewtopic.php?f=7&t=267";
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ which ];

  makeFlags = "KERNELSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build DESTDIR=$(out)";

  configurePhase = ''
    echo make $makeFlags brave
  '';

  enableParallelBuilding = false;

  installPhase = ''
    install -m 755   -d $out/lib/modules/${kernel.version}/extra/
    install -m 644 *.ko $out/lib/modules/${kernel.version}/extra/
  '';
}
