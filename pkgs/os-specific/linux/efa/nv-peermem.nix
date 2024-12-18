{
  lib,
  stdenv,
  cmake,
  coreutils,
  fetchFromGitHub,
  gitUpdater,
  kernel,
  nvidia-open,
  broken,
}:
let
  rev-prefix = "efa_nv_peermem_linux_";
  version = "1.1.1";
  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "${rev-prefix}${version}";
    hash = "sha256-Lfww9dyMu/1gjW+9Pf8rvdE1+tXQaAjBci3AUdTKcqU=";
  };

  sourceRoot = "${src}/kernel/linux/efa_nv_peermem/";
in
stdenv.mkDerivation {
  inherit version;
  src = sourceRoot;
  name = "efa-nv-peermem-${version}-${kernel.version}";

  patches = [ ./nv-peermem-cmakefixups.patch ];

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ cmake ];
  makeFlags = kernel.makeFlags;
  cmakeFlags = [
    "-DKERNEL_VER=${kernel.modDirVersion}"
    "-DKERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "-DNVIDIA_DIR=${nvidia-open.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    echo $(pwd)
    $STRIP -S src/efa_nv_peermem.ko
    dest=$out/lib/modules/${kernel.modDirVersion}/misc
    mkdir -p $dest
    cp src/efa_nv_peermem.ko $dest/
    xz $dest/efa_nv_peermem.ko
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    inherit rev-prefix;
  };

  meta = with lib; {
    description = "Amazon Elastic Fabric Adapter (EFA) NVIDIA GPUDirect driver for Linux";
    homepage = "https://github.com/amzn/amzn-drivers";
    license = licenses.gpl2Only;
    inherit broken;
    maintainers = with maintainers; [
      sielicki
    ];
    platforms = platforms.linux;
  };
}
