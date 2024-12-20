{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kmod,
}:

let
  kernelDirectory = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation {
  pname = "zenergy";
  version = "0-unstable-2024-10-10";

  src = fetchFromGitHub {
    owner = "BoukeHaarsma23";
    repo = "zenergy";
    rev = "7c4e83d5e2f887f4c31edaf92e5f94e9448e9764";
    hash = "sha256-5fYelEr4IYnuXrly15IcyicFrF0tYjs7OBqIhUYQXZ0=";
  };

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  hardeningDisable = [
    "format"
    "pic"
  ];

  makeFlags = kernel.makeFlags ++ [ "KDIR=${kernelDirectory}" ];

  installTargets = [ "modules_install" ];

  preBuild = ''
    substituteInPlace Makefile --replace-fail "PWD modules_install" "PWD INSTALL_MOD_PATH=$out modules_install"
  '';

  meta = with lib; {
    description = "Based on AMD_ENERGY driver, but with some jiffies added so non-root users can read it safely.";
    homepage = "https://github.com/BoukeHaarsma23/zenergy";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ wizardlink ];
    platforms = platforms.linux;
  };
}
