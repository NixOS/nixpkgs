{ stdenv, lib
, kernel
, fetchurl
, pkg-config, meson, ninja
, libbsd, numactl, libbpf, zlib, libelf, jansson, openssl, libpcap, rdma-core
, doxygen, python3
, withExamples ? []
, shared ? false }:

let
  mod = kernel != null;
  dpdkVersion = "21.11";
in stdenv.mkDerivation rec {
  pname = "dpdk";
  version = "${dpdkVersion}" + lib.optionalString mod "-${kernel.version}";

  src = fetchurl {
    url = "https://fast.dpdk.org/rel/dpdk-${dpdkVersion}.tar.xz";
    sha256 = "sha256-Mkbj7WjuKzaaXYviwGzxCKZp4Vf01Bxby7sha/Wr06E=";
  };

  nativeBuildInputs = [
    doxygen
    meson
    ninja
    pkg-config
    python3
    python3.pkgs.sphinx
    python3.pkgs.pyelftools
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

  # Propagated to support current DPDK users in nixpkgs which statically link
  # with the framework (e.g. odp-dpdk).
  propagatedBuildInputs = [
    rdma-core
  ];

  postPatch = ''
    patchShebangs config/arm buildtools
  '';

  mesonFlags = [
    "-Dtests=false"
    "-Denable_docs=true"
    "-Denable_kmods=${lib.boolToString mod}"
  ]
  # kni kernel driver is currently not compatble with 5.11
  ++ lib.optional (mod && kernel.kernelOlder "5.11") "-Ddisable_drivers=kni"
  ++ lib.optional (!shared) "-Ddefault_library=static"
  ++ lib.optional stdenv.isx86_64 "-Dmachine=nehalem"
  ++ lib.optional stdenv.isAarch64 "-Dmachine=generic"
  ++ lib.optional mod "-Dkernel_dir=${placeholder "kmod"}/lib/modules/${kernel.modDirVersion}"
  ++ lib.optional (withExamples != []) "-Dexamples=${builtins.concatStringsSep "," withExamples}";

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

  postInstall = ''
    # Remove Sphinx cache files. Not only are they not useful, but they also
    # contain store paths causing spurious dependencies.
    rm -rf $out/share/doc/dpdk/html/.doctrees
  '' + lib.optionalString (withExamples != []) ''
    find examples -type f -executable -exec install {} $out/bin \;
  '';

  outputs = [ "out" ] ++ lib.optional mod "kmod";

  meta = with lib; {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = "http://dpdk.org/";
    license = with licenses; [ lgpl21 gpl2 bsd2 ];
    platforms =  platforms.linux;
    maintainers = with maintainers; [ magenbluten orivej mic92 zhaofengli ];
  };
}
