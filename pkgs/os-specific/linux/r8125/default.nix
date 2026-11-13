{
  stdenv,
  lib,
  fetchFromGitLab,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "r8125";
  version = "9.016.01";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "r8125";
    tag = "upstream/${finalAttrs.version}";
    hash = "sha256-Sg+f27nujBFtk0UxhVlc3c07MZVGVkEFAP5BH/NE0C4=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # Allow changing BASEDIR with -C
  postPatch = ''
    substituteInPlace src/Makefile --replace-fail "BASEDIR :=" "BASEDIR ?="
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "BASEDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "INSTALL_MOD_DIR=kernel/drivers/net/ethernet/realtek"
    "INSTALL_MOD_STRIP=1"
    "DEPMOD=true"
  ];

  buildFlags = [ "modules" ];

  installTargets = [ "modules_install" ];

  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)/src"
  ];

  meta = {
    homepage = "https://salsa.debian.org/debian/r8125";
    description = "Realtek r8125 2.5G Ethernet driver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.peelz ];
  };
})
