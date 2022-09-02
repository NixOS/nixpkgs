{ stdenv, lib
, kernel
, fetchurl
, pkg-config, meson, ninja, makeWrapper
, libbsd, numactl, libbpf, zlib, libelf, jansson, openssl, libpcap, rdma-core
, doxygen, python3, pciutils
, withExamples ? []
, shared ? false }:

let
  mod = kernel != null;
  dpdkVersion = "22.03";
in stdenv.mkDerivation rec {
  pname = "dpdk";
  version = "${dpdkVersion}" + lib.optionalString mod "-${kernel.version}";

  src = fetchurl {
    url = "https://fast.dpdk.org/rel/dpdk-${dpdkVersion}.tar.xz";
    sha256 = "sha256-st5fCLzVcz+Q1NfmwDJRWQja2PyNJnrGolNELZuDp8U=";
  };

  nativeBuildInputs = [
    makeWrapper
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
    libelf
    libpcap
    numactl
    openssl.dev
    zlib
    python3
  ] ++ lib.optionals mod kernel.moduleBuildDependencies;

  propagatedBuildInputs = [
    # Propagated to support current DPDK users in nixpkgs which statically link
    # with the framework (e.g. odp-dpdk).
    rdma-core
    # Requested by pkg-config.
    libbsd
  ];

  postPatch = ''
    patchShebangs config/arm buildtools
  '' + lib.optionalString mod ''
    # kernel_install_dir is hardcoded to `/lib/modules`; patch that.
    sed -i "s,kernel_install_dir *= *['\"].*,kernel_install_dir = '$kmod/lib/modules/${kernel.modDirVersion}'," kernel/linux/meson.build
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
  ++ lib.optional mod "-Dkernel_dir=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ++ lib.optional (withExamples != []) "-Dexamples=${builtins.concatStringsSep "," withExamples}";

  postInstall = ''
    # Remove Sphinx cache files. Not only are they not useful, but they also
    # contain store paths causing spurious dependencies.
    rm -rf $out/share/doc/dpdk/html/.doctrees

    wrapProgram $out/bin/dpdk-devbind.py \
      --prefix PATH : "${lib.makeBinPath [ pciutils ]}"
  '' + lib.optionalString (withExamples != []) ''
    mkdir -p $examples/bin
    find examples -type f -executable -exec install {} $examples/bin \;
  '';

  outputs =
    [ "out" "doc" ]
    ++ lib.optional mod "kmod"
    ++ lib.optional (withExamples != []) "examples";

  meta = with lib; {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = "http://dpdk.org/";
    license = with licenses; [ lgpl21 gpl2 bsd2 ];
    platforms =  platforms.linux;
    maintainers = with maintainers; [ magenbluten orivej mic92 zhaofengli ];
    broken = mod && kernel.kernelAtLeast "5.18";
  };
}
