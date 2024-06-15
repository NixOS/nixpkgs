{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

let
  kernelDirectory = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
in
stdenv.mkDerivation {
  pname = "zenergy";
  version = "0-unstable-2024-05-19";

  src = fetchFromGitHub {
    owner = "BoukeHaarsma23";
    repo = "zenergy";
    rev = "d65592b3c9d171ba70e6017e0827191214d81937";
    hash = "sha256-10hiUHJvLTG3WGrr4WXMo/mCoJGFqWk2l5PryjNhcHg=";
  };

  hardeningDisable = [ "format" "pic" ];

  makeFlags = kernel.makeFlags ++ [
    "KDIR=${kernelDirectory}"
  ];

  preBuild = ''
    substituteInPlace Makefile --replace-fail "PWD modules_install" "PWD INSTALL_MOD_PATH=$out modules_install"
  '';

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  installPhase = ''
    make modules_install KDIR=${kernelDirectory}
  '';

  meta = with lib; {
    description = "Based on AMD_ENERGY driver, but with some jiffies added so non-root users can read it safely.";
    homepage = "https://github.com/BoukeHaarsma23/zenergy";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ wizardlink ];
    platforms = platforms.linux;
  };
}
