{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "ithc";
  version = "0-unstable-2025-05-27";

  src = fetchFromGitHub {
    owner = "quo";
    repo = "ithc-linux";
    rev = "6d53c9c21797df5da975bd27db22bd89ee0cead3";
    hash = "sha256-uO+tsCn6LZlAXq1jvqwpFuLluzlWr/auJy9R6Uiv0PE=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "VERSION=${version}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  postPatch = ''
    sed -i ./Makefile -e '/depmod/d'
  '';

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = with lib; {
    description = "Linux driver for Intel Touch Host Controller";
    homepage = "https://github.com/quo/ithc-linux";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ aacebedo ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.9";
  };
}
