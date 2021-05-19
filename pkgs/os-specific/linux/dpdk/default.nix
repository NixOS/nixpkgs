{ stdenv, lib
, kernel
, fetchurl
, pkg-config, meson, ninja
, libbsd, numactl, libbpf, zlib, libelf, jansson, openssl, libpcap
, doxygen, python3
, shared ? false }:

let
  mod = kernel != null;

in stdenv.mkDerivation rec {
  name = "dpdk-${version}" + lib.optionalString mod "-${kernel.version}";
  version = "21.02";

  src = fetchurl {
    url = "https://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
    sha256 = "sha256-CZJKKoJVGqKZeKNoYYT4oQX1L1ZAsb4of1QLLJHpSJs=";
  };

  nativeBuildInputs = [
    doxygen
    meson
    ninja
    pkg-config

    # python3.withPackages isn't sufficient, because python3 during a
    # meson build points to the one used by meson
    python3.pkgs.pyelftools
    python3.pkgs.sphinx
  ];

  buildInputs = [
    jansson
    libbpf
    libbsd
    libelf
    libpcap
    numactl
    openssl.dev
    zlib
  ] ++ lib.optionals mod kernel.moduleBuildDependencies;

  postPatch = ''
    patchShebangs config/arm buildtools
  '';

  mesonFlags = [
    "-Denable_docs=true"
    "-Denable_kmods=${lib.boolToString mod}"
  ]
  ++ lib.optional (!shared) "-Ddefault_library=static"
  ++ lib.optional stdenv.isx86_64 "-Dmachine=nehalem"
  ++ lib.optional mod "-Dkernel_dir=${placeholder "kmod"}/lib/modules/${kernel.modDirVersion}";

  # dpdk meson script does not support separate kernel source and installion
  # dirs (except via destdir), so we temporarily link the former into the latter.
  preConfigure = lib.optionalString mod ''
    mkdir -p $kmod/lib/modules/${kernel.modDirVersion}
    ln -sf ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      $kmod/lib/modules/${kernel.modDirVersion}
  '';

  postBuild = lib.optionalString mod ''
    rm -f $kmod/lib/modules/${kernel.modDirVersion}/build
  '';

  outputs = [ "out" ] ++ lib.optional mod "kmod";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = "http://dpdk.org/";
    license = with licenses; [ lgpl21 gpl2 bsd2 ];
    platforms =  platforms.linux;
    maintainers = with maintainers; [ magenbluten orivej ];
  };
}
