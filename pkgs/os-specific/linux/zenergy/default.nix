{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  kmod,
}:

let
  kernelDirectory = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation {
  pname = "zenergy";
  version = "0-unstable-2025-08-31";

  src = fetchFromGitHub {
    owner = "BoukeHaarsma23";
    repo = "zenergy";
    rev = "58f2fda7184fbde95033f492f7c54990552ef86f";
    hash = "sha256-nSkq4JuZqhuH+JGH/vr9bw/suo/2rmdbKcvYPIil9qw=";
  };

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  hardeningDisable = [
    "format"
    "pic"
  ];

  makeFlags = kernelModuleMakeFlags ++ [ "KDIR=${kernelDirectory}" ];

  installTargets = [ "modules_install" ];

  preBuild = ''
    substituteInPlace Makefile --replace-fail "PWD modules_install" "PWD INSTALL_MOD_PATH=$out modules_install"
  '';

  meta = with lib; {
    description = "Based on AMD_ENERGY driver, but with some jiffies added so non-root users can read it safely";
    homepage = "https://github.com/BoukeHaarsma23/zenergy";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ wizardlink ];
    platforms = [ "x86_64-linux" ];
  };
}
