{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "akvcam";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "webcamoid";
    repo = "akvcam";
    rev = version;
    sha256 = "sha256-HTST8M2o60mY8Yr4YewQ3wPYD+AWJYivyZFT7mUFpsw=";
  };
  sourceRoot = "${src.name}/src";

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -m644 -b -D akvcam.ko $out/lib/modules/${kernel.modDirVersion}/akvcam.ko
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Virtual camera driver for Linux";
    homepage = "https://github.com/webcamoid/akvcam";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
  };
}
