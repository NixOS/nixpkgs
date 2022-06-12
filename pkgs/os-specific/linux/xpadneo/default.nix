{ lib, stdenv, fetchFromGitHub, kernel, bluez }:

stdenv.mkDerivation rec {
  pname = "xpadneo";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "atar-axis";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VUcS4OzvPj0o627ZWIOBqEAQJ4JuMCMjgaZoMkL/IHc=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source/hid-xpadneo/src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [ bluez ];

  makeFlags = kernel.makeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${version}"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Advanced Linux driver for Xbox One wireless controllers";
    homepage = "https://atar-axis.github.io/xpadneo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
}
