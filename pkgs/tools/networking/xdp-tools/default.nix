{ lib
, stdenv
, fetchFromGitHub
, libbpf
, elfutils
, zlib
, libpcap
, bpftools
, llvmPackages
, pkg-config
, m4
, emacs-nox
, wireshark-cli
, nukeReferences
}:
stdenv.mkDerivation rec {
  pname = "xdp-tools";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "xdp-project";
    repo = "xdp-tools";
    rev = "v${version}";
    hash = "sha256-5rc3RbAgWVd7Tt16NoHymFME5a9tBCmup+1ZmnMGPhs=";
  };

  outputs = [ "out" "lib" ];

  buildInputs = [
    libbpf
    elfutils
    libpcap
    zlib
  ];

  depsBuildBuild = [
    emacs-nox # to generate man pages from .org
  ];
  nativeBuildInputs = [
    bpftools
    llvmPackages.clang
    llvmPackages.llvm
    pkg-config
    m4
    nukeReferences
  ];
  nativeCheckInputs = [
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
    maintainers = with maintainers; [ tirex vcunat vifino ];
    platforms = platforms.linux;
  };
}
