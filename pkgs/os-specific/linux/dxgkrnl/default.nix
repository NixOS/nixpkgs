{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

let
  # WSL2 kernel source — contains the dxgkrnl driver under drivers/hv/dxgkrnl/
  # Sparse checkout to avoid cloning the full ~1GB kernel repo.
  wsl2KernelSrc = fetchFromGitHub {
    owner = "microsoft";
    repo = "WSL2-Linux-Kernel";
    rev = "a07f9ea8a99139913acbcc1c160b132cb2a49c81"; # linux-msft-wsl-6.6.y @ 6.6.123.2
    sparseCheckout = [
      "drivers/hv/dxgkrnl"
      "include/uapi/misc/d3dkmthk.h"
    ];
    nonConeMode = true;
    hash = "sha256-Km0MvRJ3RdoYlsL0XJSaRdBp/bRx/hE7Pbjr7uf+xxI=";
  };

  # Compatibility patches: adds GPU-PV VMBus channel GUIDs and fixes for
  # host kernels >= 6.6 (eventfd_signal, get_task_comm, timer API changes).
  patchSrc = fetchFromGitHub {
    owner = "staralt";
    repo = "dxgkrnl-dkms";
    rev = "a7ce5afa85954e5fa308a17c9aa54d565f9ef453"; # v1.0
    hash = "sha256-QUiU8BJMrEpT5z/xb1i189mV7ZI/7f4z/fnctSkl/yk=";
  };

  ksrc = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build/source";
in
stdenv.mkDerivation {
  pname = "dxgkrnl";
  version = "6.6.123.2-${kernel.version}";

  src = wsl2KernelSrc;

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  patches = [
    "${patchSrc}/linux-msft-wsl-5.15.y/0001-Add-a-gpu-pv-support.patch"
    "${patchSrc}/linux-msft-wsl-6.6.y/0002-Fix-eventfd_signal.patch"
    "${patchSrc}/linux-msft-wsl-6.6.y/0003-Update-get_task_comm-function.patch"
    "${patchSrc}/linux-msft-wsl-6.6.y/0004-Fix-timer-related-error.patch"
    "${patchSrc}/linux-msft-wsl-6.6.y/0005-Fix-pointer-casting-error-in-dxgsyncfile.c.patch"
  ];

  postPatch = ''
    # Flatten sources into a standalone build directory
    mkdir -p $TMPDIR/build/include/uapi/misc
    cp drivers/hv/dxgkrnl/*.c drivers/hv/dxgkrnl/*.h $TMPDIR/build/
    cp include/uapi/misc/d3dkmthk.h $TMPDIR/build/include/uapi/misc/
    cat > $TMPDIR/build/Makefile << 'MAKEFILE'
    obj-m := dxgkrnl.o
    dxgkrnl-y := dxgmodule.o hmgr.o misc.o dxgadapter.o ioctl.o dxgvmbus.o dxgprocess.o dxgsyncfile.o
    EXTRA_CFLAGS += -I$(PWD)/include -D_MAIN_KERNEL_
    EXTRA_CFLAGS += -I${ksrc}/include/linux
    EXTRA_CFLAGS += -include ${ksrc}/include/linux/vmalloc.h
    ccflags-y += $(EXTRA_CFLAGS)
    MAKEFILE
  '';

  makeFlags = kernelModuleMakeFlags;

  preBuild = ''
    cd $TMPDIR/build
  '';

  buildPhase = ''
    runHook preBuild
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$(pwd) \
      $makeFlags \
      modules
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D $TMPDIR/build/dxgkrnl.ko \
      $out/lib/modules/${kernel.modDirVersion}/extra/dxgkrnl.ko
    runHook postInstall
  '';

  meta = {
    description = "Microsoft dxgkrnl - Hyper-V GPU paravirtualization (GPU-PV) kernel module";
    homepage = "https://github.com/microsoft/WSL2-Linux-Kernel";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      lostmsu
    ];
    platforms = [ "x86_64-linux" ];
  };
}
