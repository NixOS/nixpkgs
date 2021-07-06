{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "hid-nintendo";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "nicman23";
    repo = "dkms-hid-nintendo";
    rev = version;
    sha256 = "sha256-IanH3yHfkQhqtKvKD8lh+muc9yX8XJ5bfdy1Or8Vd5g=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source/src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "A Nintendo HID kernel module";
    homepage = "https://github.com/nicman23/dkms-hid-nintendo";
    license = licenses.gpl2;
    maintainers = [ maintainers.rencire ];
    platforms = platforms.linux;
    broken = versionOlder kernel.version "4.14";
  };
}
