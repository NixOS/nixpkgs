{
  fetchFromGitHub,
  elfutils,
  pkg-config,
  stdenv,
  zlib,
  lib,

  # for passthru.tests
  knot-dns,
  nixosTests,
  systemd,
  tracee,
}:

stdenv.mkDerivation rec {
  pname = "libbpf";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "libbpf";
    repo = "libbpf";
    rev = "v${version}";
    hash = "sha256-igjjwirg3O5mC3DzGCAO9OgrH2drnE/gV6NH7ZLNnFE=";
  };

  patches = [
    # Fix redefinition when using linux/netlink.h from libbpf with musl
    # https://github.com/libbpf/libbpf/pull/919
    ./sync-uapi-move-constants-from-linux-kernel-h-to-linux-const-h.patch
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    elfutils
    zlib
  ];

  enableParallelBuilding = true;
  makeFlags = [
    "PREFIX=$(out)"
    "--directory=src"
  ];

  passthru.tests = {
    inherit knot-dns tracee;
    bpf = nixosTests.bpf;
    systemd = systemd.override { withLibBPF = true; };
  };

  postInstall = ''
    # install linux's libbpf-compatible linux/btf.h
    install -Dm444 include/uapi/linux/*.h -t $out/include/linux
  '';

  # FIXME: Multi-output requires some fixes to the way the pkg-config file is
  # constructed (it gets put in $out instead of $dev for some reason, with
  # improper paths embedded). Don't enable it for now.

  # outputs = [ "out" "dev" ];

  __structuredAttrs = true;

  meta = {
    description = "Library for loading eBPF programs and reading and manipulating eBPF objects from user-space";
    homepage = "https://github.com/libbpf/libbpf";
    license = with lib.licenses; [
      lgpl21 # or
      bsd2
    ];
    maintainers = with lib.maintainers; [
      thoughtpolice
      vcunat
      saschagrunert
      martinetd
    ];
    platforms = lib.platforms.linux;
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "libbpf_project" version;
  };
}
