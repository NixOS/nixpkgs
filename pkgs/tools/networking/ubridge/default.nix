{ stdenv, fetchFromGitHub
, libpcap
}:

stdenv.mkDerivation rec {
  name = "ubridge-${version}";
  version = "0.9.14";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "ubridge";
    rev = "v${version}";
    sha256 = "1m3j9jfj8fm0532jhaagqgsyr241j6z9wn8lgrl7q3973rhiahfs";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "/usr/local/bin" "$out/bin" \
      --replace "setcap" "#setcap"
  '';

  buildInputs = [ libpcap ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Bridge for UDP tunnels, Ethernet, TAP, and VMnet interfaces";
    longDescription = ''
      uBridge is a simple application to create user-land bridges between
      various technologies. Currently bridging between UDP tunnels, Ethernet
      and TAP interfaces is supported. Packet capture is also supported.
    '';
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
