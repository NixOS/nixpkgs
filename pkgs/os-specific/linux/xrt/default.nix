{
  lib,
  stdenv,
  xrt,
  kernel,
}:

stdenv.mkDerivation {
  pname = "xrt";
  version = "${kernel.version}-${xrt.version}";

  src = xrt.dkms;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildPhase = ''
    runHook preBuild

    pushd xrt-2.*/driver/xocl
      make -j $NIX_BUILD_CORES
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pushd xrt-2.*/driver/xocl/mgmtpf
      make -C $KERNEL_SRC M=$(pwd) INSTALL_MOD_PATH=$out modules_install
      install -Dm644 99-xclmgmt.rules -t $out/lib/udev/rules.d
    popd

    pushd xrt-2.*/driver/xocl/userpf
      make -C $KERNEL_SRC M=$(pwd) INSTALL_MOD_PATH=$out modules_install
      install -Dm644 99-xocl.rules -t $out/lib/udev/rules.d
    popd

    runHook postInstall
  '';

  env.KERNEL_SRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  meta = {
    description = "Kernel module for Xilinx Runtime";
    longDescription = ''
      Note that you don't have to install this module if
      you are trying to get Ryzen AI (aka. XDNA2) working.
      You only need `amdxdna` kernel module which should be
      included in latest kernels
    '';
    homepage = "https://xilinx.github.io/XRT";
    inherit (xrt.meta) license maintainers platforms;
  };
}
