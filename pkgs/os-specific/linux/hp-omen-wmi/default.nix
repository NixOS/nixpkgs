{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation rec {
  pname = "hp-omen-wmi";
  version = "rebase-6.15";

  src = fetchFromGitHub {
    owner = "ranisalt";
    repo = "hp-omen-linux-module";
    tag = "${version}";
    hash = "sha256-IOXHzcCB0n1InMjeIu3XYEJ4bhbHS3NIlS8/+4XIwkQ=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source/src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
  ];

  enableParallelBuilding = true;

  buildFlags = [ "modules" ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];

  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Linux kernel module for HP Omen Keyboards";
    homepage = "https://github.com/ranisalt/hp-omen-linux-module";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ern775 ];
    platforms = platforms.linux;
  };
}
