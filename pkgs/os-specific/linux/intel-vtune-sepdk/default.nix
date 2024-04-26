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
    which
  ];
  libexecDir = "\${out}/libexec/intel-vtune-sepdk";
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86";
  versionMajorMinor = lib.versions.majorMinor intel-oneapi-vtune.version;
in
stdenv.mkDerivation {
  pname = "intel-vtune-sepdk";
  version = "${intel-oneapi-vtune.version}-${kernel.version}";

  inherit (intel-oneapi-vtune) src;

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [
    makeWrapper
    p7zip
  ] ++ kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNEL_SRC_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KERNEL_VERSION=${kernel.modDirVersion}" # Output of `uname -r`
    "MACH=x86_64" # Output of `uname -m`
    "SMP=1"
    "VERBOSE=1"
    "INSTALL=${libexecDir}"
  ];

  unpackPhase = ''
    runHook preUnpack
    7za x $src _installdir/vtune/${versionMajorMinor}/sepdk
    cd _installdir/vtune/${versionMajorMinor}/sepdk/src
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
      sed -i '
        s/^PATH=/# &/;
        # Do not check for su to make it usable with clean PATH (e.g. as systemd service)
        s/\(\bCOMMANDS_TO_CHECK="[^"]*\)''${SU}\([^"]*"\)/\1\2/;
      ' ${libexecDir}/$i
      makeWrapper ${libexecDir}/$i $out/bin/''${i##*/} --prefix PATH : "${binPath}"
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
    license = [
      lib.licenses.bsd3
      lib.licenses.gpl2Only
      lib.licenses.unfree
    ];
    maintainers = [ lib.maintainers.xzfc ];
    platforms = [ "x86_64-linux" ];
  };
}
