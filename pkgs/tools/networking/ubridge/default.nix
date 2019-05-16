{ stdenv, fetchFromGitHub
, libpcap
}:

stdenv.mkDerivation rec {
  name = "ubridge-${version}";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "ubridge";
    rev = "v${version}";
    sha256 = "0fl07zyall04map6v2l1bclqh8y3rrhsx61s2v0sr8b00j201jg4";
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
