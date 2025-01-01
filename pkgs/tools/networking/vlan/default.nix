{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vlan";
  version = "1.9";

  src = fetchurl {
    url = "https://www.candelatech.com/~greear/${pname}/${pname}.${version}.tar.gz";
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

  meta = with lib; {
    description = "User mode programs to enable VLANs on Ethernet devices";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    mainProgram = "vconfig";
  };
}
