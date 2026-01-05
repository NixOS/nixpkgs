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

  preBuild = ''
    substituteInPlace src/Makefile --replace-fail "BASEDIR :=" "BASEDIR ?="
    substituteInPlace src/Makefile --replace-fail "modules_install" "INSTALL_MOD_PATH=$out modules_install"
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "BASEDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  ];

  buildFlags = [ "modules" ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/realtek
    cp src/r8125.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/ethernet/realtek/
  '';

  meta = {
    homepage = "https://salsa.debian.org/debian/r8125";
    description = "Realtek r8125 2.5G Ethernet driver";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.peelz ];
  };
})
