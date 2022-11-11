{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, libbpf
, elfutils
, zlib
, libpcap
, llvmPackages
, pkg-config
, m4
, emacs-nox
, wireshark-cli
, nukeReferences
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

  outputs = [ "out" "lib" ];

  patches = [
    (fetchpatch {
      # Compat with libbpf 1.0: https://github.com/xdp-project/xdp-tools/pull/221
      url = "https://github.com/xdp-project/xdp-tools/commit/f8592d0609807f5b2b73d27eb3bd623da4bd1997.diff";
      sha256 = "+NpR0d5YE1TMFeyidBuXCDkcBTa2W0094nqYiEWKpY4=";
    })
  ];

  buildInputs = [
    libbpf
    elfutils
    libpcap
    zlib
  ];

  nativeBuildInputs = [
    llvmPackages.clang
    llvmPackages.llvm
    pkg-config
    m4
    emacs-nox # to generate man pages from .org
    nukeReferences
  ];
  checkInputs = [
    wireshark-cli # for tshark
  ];

  # When building BPF, the default CC wrapper is interfering a bit too much.
  BPF_CFLAGS = "-fno-stack-protector -Wno-error=unused-command-line-argument";

  PRODUCTION = 1;
  DYNAMIC_LIBXDP = 1;
  FORCE_SYSTEM_LIBBPF = 1;
  FORCE_EMACS = 1;

  makeFlags = [ "PREFIX=$(out)" "LIBDIR=$(lib)/lib" ];

  postInstall = ''
    # Note that even the static libxdp would refer to BPF_OBJECT_DIR ?=$(LIBDIR)/bpf
    rm "$lib"/lib/*.a
    # Drop unfortunate references to glibc.dev/include at least from $lib
    nuke-refs "$lib"/lib/bpf/*.o
  '';

  meta = with lib; {
    homepage = "https://github.com/xdp-project/xdp-tools";
    description = "Library and utilities for use with XDP";
    license = with licenses; [ gpl2 lgpl21 bsd2 ];
    maintainers = with maintainers; [ tirex vcunat ];
    platforms = platforms.linux;
  };
}
