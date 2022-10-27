{ lib, stdenv, fetchFromGitHub, autoconf, automake, zlib }:
stdenv.mkDerivation rec {
  version = "0.5.1";
  pname = "wiiload";

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ zlib ];

  src = fetchFromGitHub {
    owner = "devkitPro";
    repo  = "wiiload";
    rev = "v${version}";
    sha256 = "0dffy603zggkqv7g1a2jninmi64vy519gpgkdfhjnijhdm9gs5m3";
  };

  preConfigure = "./autogen.sh";

  meta = with lib; {
    description = "Load homebrew apps over network/usbgecko to your Wii";
    homepage = "https://wiibrew.org/wiki/Wiiload";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tomsmeets ];
  };
}
