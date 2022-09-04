{ lib
, stdenv
, fetchFromGitHub
, libbpf
, elfutils
, libelf
, zlib
, libpcap
, clang
, llvm
, gnumake
, gcc
, pkgconfig
, m4
, emacs-nox
, wireshark-cli
}:
stdenv.mkDerivation rec {
  pname = "xdp-tools";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "xdp-project";
    repo = "xdp-tools";
    rev = "v${version}";
    sha256 = "xKxR20Jz+pGKzazFoZe0i0pv7AuaxdL8Yt3IE4JAje8=";
  };

  buildInputs = [
    libbpf
    elfutils
    libelf
    libpcap
    zlib
  ];

  nativeBuildInputs = [
    clang
    llvm
    gnumake
    gcc
    pkgconfig
    m4
    emacs-nox
    wireshark-cli
  ];

  BPF_CFLAGS = "-fno-stack-protector -Wno-error=unused-command-line-argument";
  PRODUCTION = 1;
  DYNAMIC_LIBXDP = 1;
  FORCE_SYSTEM_LIBBPF = 1;
  FORCE_EMACS = 1;

  installPhase = ''
    export PREFIX=$out

    make install
  '';

  meta = with lib; {
    homepage = "https://github.com/xdp-project/xdp-tools";
    description = "Library and utilities for use with XDP";
    license = with licenses; [ gpl2 lgpl21 bsd2 ];
    maintainers = with maintainers; [ tirex ];
    platforms = platforms.linux;
  };
}
