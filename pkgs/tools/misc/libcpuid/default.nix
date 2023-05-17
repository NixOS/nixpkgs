{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libcpuid";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "anrieff";
    repo = "libcpuid";
    rev = "v${version}";
    sha256 = "sha256-lhoHqdS5tke462guORg+PURjVmjAgviT5KJHp6PyvUA=";
  };

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
