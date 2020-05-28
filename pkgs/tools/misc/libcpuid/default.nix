{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libcpuid";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "anrieff";
    repo = "libcpuid";
    rev = "v${version}";
    sha256 = "13v5x8gyka2v4kx52khwalb6ai328z7kk9jlipbbbys63p6nyddr";
  };

  patches = [
    # Work around https://github.com/anrieff/libcpuid/pull/102.
    ./stdint.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = "http://libcpuid.sourceforge.net/";
    description = "A small C library for x86 CPU detection and feature extraction";
    license = licenses.bsd2;
    maintainers = with maintainers; [ orivej artuuge ];
    platforms = platforms.x86;
  };
}
