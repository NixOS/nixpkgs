{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, openssl
, zlib
}:

stdenv.mkDerivation rec {
  pname = "jesec-libtorrent";
  version = "0.13.8-r3";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "libtorrent";
    rev = "v${version}";
    hash = "sha256-S3DOKzXkvU+ZJxfrxwLXCVBnepzmiZ+3iiQqz084BEk=";
  };

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    openssl
    zlib
  ];

  doCheck = true;
  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD
  '';
  checkInputs = [
    gtest
  ];

  meta = with lib; {
    homepage = "https://github.com/jesec/libtorrent";
    description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code (jesec's fork)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ winterqt AndersonTorres ];
    platforms = platforms.linux;
  };
}
