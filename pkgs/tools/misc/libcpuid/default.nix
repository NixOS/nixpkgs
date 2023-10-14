{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libcpuid";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "anrieff";
    repo = "libcpuid";
    rev = "v${version}";
    sha256 = "sha256-lhoHqdS5tke462guORg+PURjVmjAgviT5KJHp6PyvUA=";
  };

  patches = [
    # Fixes cross-compilation to NetBSD
    # https://github.com/anrieff/libcpuid/pull/190
    (fetchpatch {
      name = "pass-pthread-to-linker.patch";
      url = "https://github.com/anrieff/libcpuid/commit/c28436e7239f28dab0e2a3bcdbce95f41e1363b1.patch";
      sha256 = "sha256-J2mB010JcE4si0rERjcrL9kJgbWHKaQCIZPDkmRvcq4=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://libcpuid.sourceforge.net/";
    description = "A small C library for x86 CPU detection and feature extraction";
    changelog = "https://raw.githubusercontent.com/anrieff/libcpuid/master/ChangeLog";
    license = licenses.bsd2;
    maintainers = with maintainers; [ orivej artuuge ];
    platforms = platforms.x86;
  };
}
