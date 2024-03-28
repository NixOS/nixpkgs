{ lib, stdenv, fetchFromGitHub, kernel, kmod }:

let
  kernelDirectory = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  version = "a3e124477ee8197015481156b90100d49fa3cd84";
in
stdenv.mkDerivation {
  inherit version;
  pname = "zenergy";

  src = fetchFromGitHub {
    owner = "BoukeHaarsma23";
    repo = "zenergy";
    rev = version;
    hash = "sha256-s1aoipSsLKO23kTd2uGxVUpqYSeitiz3UIoDIxg/Dj8=";
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

  outputs = [ "out" ];

  meta = with lib; {
    description = "Based on AMD_ENERGY driver, but with some jiffies added so non-root users can read it safely.";
    homepage = "https://github.com/BoukeHaarsma23/zenergy";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ wizardlink ];
    platforms = platforms.linux;
    outputsToInstall = [ "out" ];
  };
}
