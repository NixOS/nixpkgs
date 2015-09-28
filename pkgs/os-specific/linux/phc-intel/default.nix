{ stdenv, fetchurl, kernel, which }:

assert stdenv.isLinux;
# Don't bother with older versions, though some would probably work:
assert stdenv.lib.versionAtLeast kernel.version "4.2";
# Disable on grsecurity kernels, which break module building:
assert !kernel.features ? grsecurity;

let
  release = "0.4.0";
  revbump = "rev18"; # don't forget to change forum download id...
  version = "${release}-${revbump}";
in stdenv.mkDerivation {
  name = "linux-phc-intel-${version}-${kernel.version}";

  src = fetchurl {
    sha256 = "1480y75yid4nw7dhzm97yb10dykinzjz34abvavsrqpq7qclhv27";
    url = "http://www.linux-phc.org/forum/download/file.php?id=167";
    name = "phc-intel-pack-${revbump}.tar.bz2";
  };

  buildInputs = [ which ];

  makeFlags = with kernel; [
    "DESTDIR=$(out)"
    "KERNELSRC=${dev}/lib/modules/${modDirVersion}/build"
  ];

  configurePhase = ''
    make $makeFlags brave
  '';

  enableParallelBuilding = false;

  installPhase = ''
    install -m 755   -d $out/lib/modules/${kernel.version}/extra/
    install -m 644 *.ko $out/lib/modules/${kernel.version}/extra/
  '';

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
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
