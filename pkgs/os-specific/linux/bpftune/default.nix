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
  version = "unstable-2023-07-14";

  src = fetchFromGitHub {
    owner = "oracle-samples";
    repo = "bpftune";
    rev = "66620152bf8c37ab592e9273fe87e567126801c2";
    hash = "sha256-U0O+F1DBF1xiaUKklwpZORBwF1T9wHM0SPQKUNaxKZk=";
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
    "BPF_INCLUDE=${lib.getDev libbpf}/include"
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
