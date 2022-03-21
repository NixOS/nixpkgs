{ stdenv, lib, fetchFromGitHub, kernel, fetchurl }:

stdenv.mkDerivation rec {
  name = "xone-${version}-${kernel.version}";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = "xone";
    rev = "v${version}";
    sha256 = "sha256-m4305Xl5w4nyAVqubjwWsiyPDVtfGykjlSW2eKEytVk=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${version}"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Linux kernel driver for Xbox One and Xbox Series X|S accessories";
    homepage = "https://github.com/medusalix/xone";
    license = licenses.gpl2;
    maintainers = with lib.maintainers; [ rhysmdnz ];
    platforms = platforms.linux;
  };
}

