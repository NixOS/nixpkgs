{
  lib,
  stdenv,
  fetchFromGitHub,
  clang,
  bpftools,
  docutils,
  libbpf,
  libcap,
  libnl,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "bpftune";
  version = "0-unstable-2024-05-17";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "bpftune";
    rev = "83115c56cf9620fe5669f4a3be67ab779d8f4536";
    hash = "sha256-er2i7CEUXF3BpWTG//s8C0xfIk5gSVOHB8nE1r7PX78=";
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
    mainProgram = "bpftune";
    homepage = "https://github.com/oracle-samples/bpftune";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nickcao ];
  };
}
