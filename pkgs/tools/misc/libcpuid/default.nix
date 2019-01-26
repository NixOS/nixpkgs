{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libcpuid-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "anrieff";
    repo = "libcpuid";
    rev = "v${version}";
    sha256 = "136kv6m666f7s18mim0vdbzqvs4s0wvixa12brj9p3kmfbx48bw7";
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
