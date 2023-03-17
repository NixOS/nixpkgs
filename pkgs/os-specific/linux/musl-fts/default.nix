{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "musl-fts";
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "void-linux";
    repo = "musl-fts";
    rev = "v${version}";
    sha256 = "Azw5qrz6OKDcpYydE6jXzVxSM5A8oYWAztrHr+O/DOE=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/void-linux/musl-fts";
    description = "An implementation of fts(3) for musl-libc";
    platforms = platforms.linux;
    license = licenses.bsd3;
    maintainers = [ maintainers.pjjw ];
  };
}
