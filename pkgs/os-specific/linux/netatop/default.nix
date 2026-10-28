{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  kernel,
  kernelModuleMakeFlags,
  kmod,
  zlib,
}:

let
  version = "3.2.2";
in

stdenv.mkDerivation {
  pname = "netatop";
  inherit version;
  name = "netatop-${kernel.version}-${version}";

  src = fetchurl {
    url = "https://www.atoptool.nl/download/netatop-${version}.tar.gz";
    hash = "sha256-UIqJd809HN1nWHoTwl46QUZHtI+S0c44/BOLWRSuo/Y=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [
    kmod
    zlib
  ];

  hardeningDisable = [ "pic" ];

  patches = [
    # fix paths in netatop.service
    ./fix-paths.patch
    # fix install paths and install the .ko instead of trying to invoke dkms
    ./fix-makefile-install.patch
    # replace init_module as needed by Linux 6.15 and above (backwards compatible)
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/netatop_kernel_6.15.patch?h=netatop-dkms&id=e5da6fa4fee5499c3e437cdd34281dd2b200508f";
      hash = "sha256-JyNQNyDJQkM/hLpb/hp3Sw2tMA8XnYogduGDFqTQ3nQ=";
    })
  ];
  preConfigure = ''
    patchShebangs mkversion
    kmod=${kmod} substituteAllInPlace netatop.service
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KMODDIRVERSION=${kernel.modDirVersion}"
    # netatop builds both the module and daemon at once, and the daemon needs a wrapped cc to build
    # pkgs/os-specific/linux/kernel/common-flags.nix unwraps the cc for kernel build, but we need the wrapped one
    "CC=${stdenv.cc}/bin/cc"
  ];

  meta = {
    description = "Network monitoring module for atop";
    mainProgram = "netatopd";
    homepage = "https://www.atoptool.nl/downloadnetatop.php";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
