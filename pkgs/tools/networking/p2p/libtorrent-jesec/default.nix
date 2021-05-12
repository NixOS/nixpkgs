{ lib, stdenv, fetchFromGitHub, cmake, gtest, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "libtorrent-jesec";
  version = "0.13.8-r1";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "libtorrent";
    rev = "v${version}";
    sha256 = "sha256-Eh5pMkSe9uO0dPRWDg2BbbRxxuvX9FM2/OReq/61ojc=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl zlib ];

  # https://github.com/jesec/libtorrent/issues/1
  doCheck = false;
  checkInputs = [ gtest ];

  meta = with lib; {
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code (jesec's fork)";
    homepage = "https://github.com/jesec/libtorrent";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ winterqt ];
    platforms = platforms.linux;
  };
}
