{ lib
, stdenv
, fetchFromGitHub
, clang
, bpftools
, docutils
, libbpf
, libcap
, libnl
}:

stdenv.mkDerivation rec {
  pname = "bpftune";
  version = "unstable-2023-05-30";

  src = fetchFromGitHub {
    owner = "oracle-samples";
    repo = "bpftune";
    rev = "bfec6668db29ec83afe2b030440f4d8f1476c1a6";
    hash = "sha256-is7y53c9pBSyywVW8hO0iHsVPQlsCb4LU/cJMGf9ua4=";
  };

  postPatch = ''
    # otherwise shrink rpath would drop $out/lib from rpath
    substituteInPlace src/Makefile \
      --replace /lib64 /lib \
      --replace /sbin  /bin
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
    "BPFTUNE_VERSION=${version}"
    "BPF_INCLUDE=${lib.getDev libbpf}/include"
    "NL_INCLUDE=${lib.getDev libnl}/include/libnl3"
  ];

  hardeningDisable = [
    "stackprotector"
  ];

  meta = with lib; {
    description = "BPF-based auto-tuning of Linux system parameters";
    homepage = "https://github.com/oracle-samples/bpftune";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nickcao ];
  };
}
