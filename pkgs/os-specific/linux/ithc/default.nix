{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "ithc";
  version = "unstable-2022-06-07";

  src = fetchFromGitHub {
    owner = "quo";
    repo = "ithc-linux";
    rev = "5af2a2213d2f3d944b19ec7ccdb96f16d56adddb";
    hash = "sha256-p4TooWUOWPfNdePE18ESmRJezPDAl9nLb55LQtkJiSg=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "VERSION=${version}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  postPatch = ''
    sed -i ./Makefile -e '/depmod/d'
  '';

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];

  meta = with lib; {
    description = "Linux driver for Intel Touch Host Controller";
    homepage = "https://github.com/quo/ithc-linux";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ aacebedo ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.9";
  };
}
