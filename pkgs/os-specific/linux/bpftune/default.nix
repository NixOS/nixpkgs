{ lib
, stdenv
, fetchFromGitHub
, clang
, bpftools
, docutils
, libbpf
, libcap
, libnl
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "bpftune";
  version = "unstable-2023-09-11";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "bpftune";
    rev = "22926812a555eac910eac0699100bac0f8776f1b";
    hash = "sha256-BflJc5lYWYFIo9LzKfb34F4V1qOI8ywVjnzOLz605DI=";
  };

  postPatch = ''
    # otherwise shrink rpath would drop $out/lib from rpath
    substituteInPlace src/Makefile \
      --replace /lib64   /lib \
      --replace /sbin    /bin \
      --replace ldconfig true
    substituteInPlace src/bpftune.service \
      --replace /usr/sbin/bpftune "$out/bin/bpftune"
    substituteInPlace include/bpftune/libbpftune.h \
      --replace /usr/lib64/bpftune/       "$out/lib/bpftune/" \
      --replace /usr/local/lib64/bpftune/ "$out/lib/bpftune/"
    substituteInPlace src/libbpftune.c \
      --replace /lib/modules /run/booted-system/kernel-modules/lib/modules

    substituteInPlace src/Makefile sample_tuner/Makefile \
      --replace 'BPF_INCLUDE := /usr/include' 'BPF_INCLUDE := ${lib.getDev libbpf}/include' \
  '';

  nativeBuildInputs = [
    clang
    bpftools
    docutils # rst2man
  ];

  buildInputs = [
    libbpf
    libcap
    libnl
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "confprefix=${placeholder "out"}/etc"
    "BPFTUNE_VERSION=${version}"
    "NL_INCLUDE=${lib.getDev libnl}/include/libnl3"
  ];

  hardeningDisable = [
    "stackprotector"
  ];

  passthru.tests = {
    inherit (nixosTests) bpftune;
  };

  enableParallelBuilding = true;

  meta = with lib; {
    description = "BPF-based auto-tuning of Linux system parameters";
    homepage = "https://github.com/oracle-samples/bpftune";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nickcao ];
  };
}
