{ stdenv, fetchFromGitHub
, libpcap
}:

stdenv.mkDerivation rec {
  pname = "ubridge";
  version = "0.9.16";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "ubridge";
    rev = "v${version}";
    sha256 = "1bind7ylgxs743vfdmpdrpp4iamy461bc3i7nxza91kj7hyyjz6h";
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
