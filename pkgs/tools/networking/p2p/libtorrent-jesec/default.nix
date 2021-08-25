{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, gtest, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "libtorrent-jesec";
  version = "0.13.8-r2";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "libtorrent";
    rev = "v${version}";
    sha256 = "sha256-eIXVTbVOCRHcxSsLPvIm9F60t2upk5ORpDSOOYqTCJ4=";
  };

  patches = [
    (fetchpatch {
      name = "test-fallback";
      url = "https://github.com/jesec/libtorrent/commit/a38205ce06aadc9908478ec3a9c8aefd9be06344.patch";
      sha256 = "sha256-2TyQ9zYWZw6bzAfVZzTOQSkfIZnDU8ykgpRAFXscEH0=";
    })
  ];

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
