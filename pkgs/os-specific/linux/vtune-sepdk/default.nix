{
  bash,
  coreutils,
  gnugrep,
  gnused,
  intel-oneapi-vtune,
  kernel,
  kmod,
  lib,
  makeWrapper,
  p7zip,
  procps,
  python3,
  shadow,
  stdenv,
  su,
  which,
}:

let
  binPath = lib.makeBinPath [
    bash
    coreutils
    gnugrep
    gnused
    kmod
    procps
    python3
    shadow
    su
    which
  ];
  libexecDir = "\${out}/libexec/vtune-sepdk";
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86";
in
stdenv.mkDerivation {
  pname = "vtune-sepdk";
  version = "${intel-oneapi-vtune.version}-${kernel.version}";

  inherit (intel-oneapi-vtune) src;

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [
    makeWrapper
    p7zip
  ] ++ kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNEL_SRC_DIR=${kernel.dev}/lib/modules/${kernel.version}/build"
    "KERNEL_VERSION=${kernel.version}" # Output of `uname -r`
    "MACH=x86_64" # Output of `uname -m`
    "SMP=1"
    "VERBOSE=1"
    "INSTALL=${libexecDir}"
  ];

  unpackPhase = ''
    runHook preUnpack
    7za x $src _installdir/vtune/${intel-oneapi-vtune.version}/sepdk
    cd _installdir/vtune/${intel-oneapi-vtune.version}/sepdk/src
    runHook postUnpack
  '';

  prePatch = ''
    # Allow using --load-in-tree-driver option
    substituteInPlace insmod-sep pax/insmod-pax socperf/src/insmod-socperf \
      --replace-fail IS_INTREE_DRIVER_OS=0 IS_INTREE_DRIVER_OS=1
  '';

  preBuild = ''
    makeFlags="$makeFlags KBUILD_EXTRA_SYMBOLS=$PWD/socperf/src/Module.symvers"
  '';

  preInstall = "mkdir -p ${libexecDir}";

  postInstall = ''
    # Install wrappers to bin
    for i in insmod-sep pax/insmod-pax socperf/src/insmod-socperf \
             rmmod-sep  pax/rmmod-pax  socperf/src/rmmod-socperf; do
      sed -i "s/^PATH=/# &/" ${libexecDir}/$i
      makeWrapper ${libexecDir}/$i $out/bin/''${i##*/} --set PATH "${binPath}"
    done

    # Install kernel modules
    mkdir -p ${modDestDir}/{socperf,sepdk/sep,sepdk/pax}
    ln -s ${libexecDir}/sep5-*.ko ${modDestDir}/sepdk/sep/sep5.ko
    ln -s ${libexecDir}/pax/pax-*.ko ${modDestDir}/sepdk/pax/pax.ko
    ln -s ${libexecDir}/socperf/src/socperf3-*.ko ${modDestDir}/socperf/socperf3.ko
  '';

  meta = {
    description = "Kernel module for Intel VTune Profiler";
    homepage = "https://www.intel.com/content/www/us/en/docs/vtune-profiler/user-guide/2024-0/sep-driver.html";
    license = with lib.licenses; [
      bsd3
      gpl2Only
      unfree
    ];
    maintainers = with lib.maintainers; [ xzfc ];
    platforms = [ "x86_64-linux" ];
  };
}
