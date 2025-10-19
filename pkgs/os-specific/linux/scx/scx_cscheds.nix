{
  llvmPackages,
  libbpf,
  pkg-config,
  bpftools,
  elfutils,
  zlib,
  zstd,
  scx-common,
  libseccomp,
}:

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "scx_cscheds";
  inherit (scx-common) version src;

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

  meta = scx-common.meta // {
    description = "Sched-ext C userspace schedulers";
    longDescription = ''
      This includes C based schedulers such as scx_central, scx_flatcg,
      scx_nest, scx_pair, scx_qmap, scx_simple, scx_userland.

      ::: {.note}
      Sched-ext schedulers are only available on kernels version 6.12 or later.
      It is recommended to use the latest kernel for the best compatibility.
      :::
    '';
  };
})
