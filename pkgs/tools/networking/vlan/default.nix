{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "vlan-1.9";

  src = fetchurl {
    url = mirror://gentoo/distfiles/vlan.1.9.tar.gz;
    sha256 = "1jjc5f26hj7bk8nkjxsa8znfxcf8pgry2ipnwmj2fr6ky0dhm3rv";
  };

  hardeningDisable = [ "format" ];

  preBuild =
    ''
      # Ouch, the tarball contains pre-compiled binaries.
      make clean
    '';

  installPhase =
    ''
      mkdir -p $out/sbin
      cp vconfig $out/sbin/

      mkdir -p $out/share/man/man8
      cp vconfig.8 $out/share/man/man8/
    '';

  meta = with stdenv.lib; {
    description = "User mode programs to enable VLANs on Ethernet devices";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
