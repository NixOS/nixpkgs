{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, gtest, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "libtorrent-jesec";
  version = "0.13.8-r3";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "libtorrent";
    rev = "v${version}";
    sha256 = "0j84717wyai4iavrz2g6kix6fl09sw1cgsqp4yclzgg46lmwww2b";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl zlib ];

  doCheck = true;
  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD
  '';
  checkInputs = [ gtest ];

  meta = with lib; {
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code (jesec's fork)";
    homepage = "https://github.com/jesec/libtorrent";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ winterqt ];
    platforms = platforms.linux;
  };
}
