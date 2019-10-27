{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libcpuid";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "anrieff";
    repo = "libcpuid";
    rev = "v${version}";
    sha256 = "03sya0fs76g86syl299lrn0vqjjcf8i0xd7fzaf42qhizbx03b88";
  };

  patches = [
    # Work around https://github.com/anrieff/libcpuid/pull/102.
    ./stdint.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = http://libcpuid.sourceforge.net/;
    description = "A small C library for x86 CPU detection and feature extraction";
    license = licenses.bsd2;
    maintainers = with maintainers; [ orivej artuuge ];
    platforms = platforms.x86;
  };
}
