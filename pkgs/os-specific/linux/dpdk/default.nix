{ stdenv, lib
, kernel
, fetchurl
, pkgconfig, meson, ninja
, libbsd, numactl, libbpf, zlib, libelf, jansson, openssl, libpcap
, doxygen, python3
, shared ? false }:

let
  kver = kernel.modDirVersion or null;
  mod = kernel != null;

in stdenv.mkDerivation rec {
  name = "dpdk-${version}" + lib.optionalString mod "-${kernel.version}";
  version = "19.08.2";

  src = fetchurl {
    url = "https://fast.dpdk.org/rel/dpdk-${version}.tar.xz";
    sha256 = "141bqqy4w6nzs9z70x7yv94a4gmxjfal46pxry9bwdh3zi1jwnyd";
  };

  nativeBuildInputs = [
    doxygen
    meson
    ninja
    pkgconfig
    python3
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
    patchShebangs config/arm
  '';

  mesonFlags = [
    "-Denable_docs=true"
    "-Denable_kmods=${if kernel != null then "true" else "false"}"
  ]
  ++ lib.optionals (shared == false) [
    "-Ddefault_library=static"
  ]
  ++ lib.optional stdenv.isx86_64 "-Dmachine=nehalem"
  ++ lib.optional (kernel != null) "-Dkernel_dir=${kernel.dev}/lib/modules/${kernel.modDirVersion}";

  outputs = [ "out" ] ++ lib.optional mod "kmod";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Set of libraries and drivers for fast packet processing";
    homepage = http://dpdk.org/;
    license = with licenses; [ lgpl21 gpl2 bsd2 ];
    platforms =  platforms.linux;
    maintainers = with maintainers; [ domenkozar magenbluten orivej ];
  };
}
