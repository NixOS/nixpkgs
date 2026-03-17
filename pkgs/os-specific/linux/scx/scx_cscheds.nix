{
  fetchFromGitHub,
  llvmPackages,
  libbpf,
  pkg-config,
  bpftools,
  elfutils,
  zlib,
  zstd,
  scx,
  libseccomp,
}:

llvmPackages.stdenv.mkDerivation {
  pname = "scx_cscheds";
  version = "0-unstable-2026-01-13";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx-c-examples";
    rev = "82c692afe32ed4e79fd047a93d3ff316bf399287";
    hash = "sha256-buXwId/4TwDfo/5mApMAEWHri92bW9x3jLEE5rawS3w=";
  };

  postPatch = ''
    substituteInPlace ./scheds/c/Makefile \
      --replace-fail '/usr/local' '${placeholder "out"}'
  '';

  nativeBuildInputs = [
    pkg-config
    zstd
    bpftools
    libbpf
  ];

  buildInputs = [
    elfutils
    zlib
    libseccomp
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  hardeningDisable = [
    "zerocallusedregs"
  ];

  doCheck = true;

  passthru = {
    inherit (scx.rustscheds.passthru) tests;
  };

  meta = scx.rustscheds.meta // {
    description = "Sched-ext C example schedulers";
    longDescription = ''
      This includes C based example schedulers such as scx_central, scx_flatcg,
      scx_nest, scx_pair, scx_qmap, scx_simple, scx_userland. These are examples,
      and generally not recommended for end users.

      ::: {.note}
      Sched-ext schedulers are only available on kernels version 6.12 or later.
      It is recommended to use the latest kernel for the best compatibility.
      :::
    '';
    homepage = "https://github.com/sched-ext/scx/tree/main/scheds/c";
  };
}
