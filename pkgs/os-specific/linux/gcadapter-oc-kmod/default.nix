{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

let
  kerneldir = "lib/modules/${kernel.modDirVersion}";
in
stdenv.mkDerivation {
  pname = "gcadapter-oc-kmod";
  version = "unstable-2021-12-11";

  src = fetchFromGitHub {
    owner = "HannesMann";
    repo = "gcadapter-oc-kmod";
    rev = "d4ddf15deb74c51dbdfc814d481ef127c371f444";
    sha256 = "sha256-bHA1611rcO8/d48b1CHsiurEt3/n+5WErtHXAU7Eh1o=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_SOURCE_DIR=${kernel.dev}/${kerneldir}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  installPhase = ''
    install -D {,$out/${kerneldir}/extra/}gcadapter_oc.ko
  '';

  meta = {
    description = "Kernel module for overclocking the Nintendo Wii U/Mayflash GameCube adapter";
    homepage = "https://github.com/HannesMann/gcadapter-oc-kmod";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ r-burns ];
    platforms = lib.platforms.linux;
  };
}
