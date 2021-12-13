{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

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
    # Fixes cross-compilation to NetBSD, remove me for libcpuid > 0.5.1
    (fetchpatch {
      name = "use-popcount-from-libc.patch";
      url = "https://github.com/anrieff/libcpuid/commit/1acaf9980b55ae180cc08db218b9face28202519.patch";
      sha256 = "0lvsv9baq0sria1f1ncn1b2783js29lfs5fv8milp54pg1wd5b7q";
    })
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
