{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "lttng-modules-${kernel.version}";
  version = "2.13.22";

  src = fetchFromGitHub {
    owner = "lttng";
    repo = "lttng-modules";
    rev = "v${version}";
    hash = "sha256-0fHjJBG/nTjXX8MVArvKDvn2ho9GLEodqAv/DcHLWis=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    description = "Linux kernel modules for LTTng tracing";
    homepage = "https://lttng.org/";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Linux kernel modules for LTTng tracing";
    homepage = "https://lttng.org/";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      lgpl21Only
      gpl2Only
      mit
    ];
<<<<<<< HEAD
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.bjornfor ];
=======
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken =
      (lib.versions.majorMinor kernel.modDirVersion) == "5.10"
      || (lib.versions.majorMinor kernel.modDirVersion) == "5.4";
  };
}
