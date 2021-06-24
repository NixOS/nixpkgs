{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libcpuid";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "anrieff";
    repo = "libcpuid";
    rev = "v${version}";
    sha256 = "sha256-m10LdtwBk1Lx31AJ4HixEYaCkT7EHpF9+tOV1rSA6VU=";
  };

  patches = [
    # Work around https://github.com/anrieff/libcpuid/pull/102.
    ./stdint.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "http://libcpuid.sourceforge.net/";
    description = "A small C library for x86 CPU detection and feature extraction";
    license = licenses.bsd2;
    maintainers = with maintainers; [ orivej artuuge ];
    platforms = platforms.x86;
  };
}
