{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation rec {
  pname = "hid-t150";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "scarburato";
    repo = "t150_driver";
    rev = "${version}";
    hash = "sha256-cY9rRJ6flo6BqDhBZk6adK33GDfX0gP5agHLrJT+TJg=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  sourceRoot = "${src.name}/hid-t150";

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  installPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules_install $makeFlags
  '';

  meta = {
    description = "Linux kernel driver for Thrustmaster T150 and TMX Force Feedback wheel";
    homepage = "https://github.com/scarburato/t150_driver";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.dbalan ];
    platforms = lib.platforms.linux;
  };
}
