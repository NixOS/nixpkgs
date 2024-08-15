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
  version = "0-unstable-2024-06-07";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "bpftune";
    rev = "04bab5dd306b55b3e4e13e261af2480b7ccff9fc";
    hash = "sha256-kVjvupZ6HxJocwXWOrxUNqEGl0welJRlZwvOmMKqeBA=";
  };

  postPatch = ''
    # otherwise shrink rpath would drop $out/lib from rpath
    substituteInPlace src/Makefile \
      --replace-fail /lib64   /lib \
      --replace-fail /sbin    /bin \
      --replace-fail ldconfig true
    substituteInPlace src/bpftune.service \
      --replace-fail /usr/sbin/bpftune "$out/bin/bpftune"
    substituteInPlace include/bpftune/libbpftune.h \
      --replace-fail /usr/lib64/bpftune/       "$out/lib/bpftune/" \
      --replace-fail /usr/local/lib64/bpftune/ "$out/lib/bpftune/"
    substituteInPlace src/libbpftune.c \
      --replace-fail /lib/modules /run/booted-system/kernel-modules/lib/modules
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
    "BPF_INCLUDE=${lib.getDev libbpf}/include"
  ];

  hardeningDisable = [
    "stackprotector"
    "zerocallusedregs"
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
