{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, alsaLib
, libpcap
}:

rustPlatform.buildRustPackage rec {
  pname = "nethoscope";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "vvilhonen";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dsv1f0ncwji8x7q1ix62955qji4jijgjx6xg3hxvl0vvvwqxcdz";
  };

  cargoSha256 = "sha256:0bxnqd1sx74rfdcr4yz59siblidjizgvwx62zcp5q627xp2l444s";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    alsaLib
    libpcap
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    libpcap
    alsaLib
  ];

  meta = with lib; {
    description = "Listen to your network traffic";
    longDescription = ''
      Employ your built-in wetware pattern recognition and
      signal processing facilities to understand your network traffic.
    '';
    homepage = "https://github.com/vvilhonen/nethoscope";
    license = licenses.isc;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.unix;
  };
}
