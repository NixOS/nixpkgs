{ stdenv, fetchurl, kernel, which }:

assert stdenv.isLinux;
# Don't bother with older versions, though some might even work:
assert stdenv.lib.versionAtLeast kernel.version "4.10";

let
  release = "0.4.0";
  revbump = "rev24"; # don't forget to change forum download id...
in stdenv.mkDerivation rec {
  name = "linux-phc-intel-${version}-${kernel.version}";
  version = "${release}-${revbump}";

  src = fetchurl {
    sha256 = "02b4j8ap1fy09z36pmpplbw4vpwqdi16jyzw5kl0a60ydgxkmrpz";
    url = "http://www.linux-phc.org/forum/download/file.php?id=178";
    name = "phc-intel-pack-${revbump}.tar.bz2";
  };

  nativeBuildInputs = [ which ] ++ kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  makeFlags = with kernel; [
    "DESTDIR=$(out)"
    "KERNELSRC=${dev}/lib/modules/${modDirVersion}/build"
  ];

  configurePhase = ''
    make $makeFlags brave
  '';

  enableParallelBuilding = false;

  installPhase = ''
    install -m 755   -d $out/lib/modules/${kernel.modDirVersion}/extra/
    install -m 644 *.ko $out/lib/modules/${kernel.modDirVersion}/extra/
  '';

  meta = with stdenv.lib; {
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
