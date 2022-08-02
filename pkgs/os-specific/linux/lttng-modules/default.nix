{ lib, stdenv, fetchgit, fetchpatch, kernel }:

stdenv.mkDerivation rec {
  pname = "lttng-modules-${kernel.version}";
  version = "2.13.4";

  src = fetchgit {
    url = "https://git.lttng.org/lttng-modules.git";
    rev = "v${version}";
    hash = "sha256-J2Tr1vOiCAilmnf3attF3bz8Irn9IQ2QbapdXJ4MUSg=";
  };

  patches = [
    # fix: mm/page_alloc: fix tracepoint mm_page_alloc_zone_locked() (v5.19)
    (fetchpatch {
      url = "https://git.lttng.org/?p=lttng-modules.git;a=patch;h=6229bbaa423832f6b7c7a658ad11e1d4242752ff";
      hash = "sha256-pqbKxBzjfN20wfsqSeBLXNQ+/U+3qk9RfTiT32OwSIc=";
    })

    # fix: fs: Remove flags parameter from aops->write_begin (v5.19)
    (fetchpatch {
      url = "https://git.lttng.org/?p=lttng-modules.git;a=patch;h=5e2f832d59d51589ab69479c7db43c7581fb9346";
      hash = "sha256-auoCbvFEVR76sOCLjIe+q/Q+vunQlR3G3gVcjqAGGPk=";
    })

    # fix: workqueue: Fix type of cpu in trace event (v5.19)
    (fetchpatch {
      url = "https://git.lttng.org/?p=lttng-modules.git;a=patch;h=c6da9604b1666780ea4725b3b3d1bfa1548f9c89";
      hash = "sha256-qoTwy+P32qg1L+JctqM1+70OkeTbnbL3QJ9LwaBq/bw=";
    })

    # fix: net: skb: introduce kfree_skb_reason() (v5.15.58..v5.16)
    (fetchpatch {
      url = "https://git.lttng.org/?p=lttng-modules.git;a=patch;h=96c477dabaaf6cd1734bebe0972fef877e5a463b";
      hash = "sha256-b7BhrYZ5SZqeRVGEu0Eo9GfbcZdDPrgEnOl2XU3z+ds=";
    })
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  makeFlags = kernel.makeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = "https://lttng.org/";
    license = with licenses; [ lgpl21Only gpl2Only mit ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
