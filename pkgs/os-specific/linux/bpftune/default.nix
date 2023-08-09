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
  version = "unstable-2023-08-02";

  src = fetchFromGitHub {
    owner = "oracle-samples";
    repo = "bpftune";
    rev = "f7e051a011d581a3c667b7f7b769862407d85f04";
    hash = "sha256-1tfr2vB/XRnpGJVwo2NQkXomz+J6AzvpS1P3rcAyAyI=";
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
