{ lib
, stdenv
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hid-nintendo";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "nicman23";
    repo = "dkms-hid-nintendo";
    rev = finalAttrs.version;
    hash = "sha256-2a+95zwyhJsF/KSo/Pm/JZ7ktDG02UZjsixSnVUXRrA=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source/src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = {
    homepage = "https://github.com/nicman23/dkms-hid-nintendo";
    description = "A Nintendo HID kernel module";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    broken = lib.versionOlder kernel.version "4.14";
  };
})
