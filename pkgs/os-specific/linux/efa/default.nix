{
  lib,
  stdenv,
  cmake,
  coreutils,
  fetchFromGitHub,
  gitUpdater,
  kernel,
}:
let
  rev-prefix = "efa_linux_";
  version = "2.13.0";
  src = fetchFromGitHub {
    owner = "amzn";
    repo = "amzn-drivers";
    rev = "${rev-prefix}${version}";
    hash = "sha256-Nt/MU25E0jZ7d7xhLE0fqY699hap64XFWnj3jB8cY44=";
  };

  sourceRoot = "${src}/kernel/linux/efa/";
in
stdenv.mkDerivation {
  inherit version;
  src = sourceRoot;
  name = "efa-${version}-${kernel.version}";

  patches = [
    ./cmake-fixups.patch
    ./cmake-fix-makefile.patch
  ];

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [
    cmake
    coreutils
  ];
  makeFlags = kernel.makeFlags;
  cmakeFlags = [
    "-DKERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "-DKERNEL_MAKEFILE=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build/Makefile"
    "-DKERNEL_VER=${kernel.modDirVersion}"
  ];
  postPatch = ''
    patchShebangs --build config/
  '';

  installPhase = ''
    runHook preInstall
    echo $(pwd)
    $STRIP -S src/efa.ko
    dest=$out/lib/modules/${kernel.modDirVersion}/misc
    mkdir -p $dest
    cp src/efa.ko $dest/
    xz $dest/efa.ko
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {
    inherit rev-prefix;
  };

  meta = with lib; {
    description = "Amazon Elastic Fabric Adapter (EFA) driver for Linux";
    homepage = "https://github.com/amzn/amzn-drivers";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      sielicki
    ];
    platforms = platforms.linux;
  };
}
