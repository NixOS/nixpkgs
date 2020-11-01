{ lib, stdenv, fetchFromGitHub, kernel, bluez }:

stdenv.mkDerivation rec {
  pname = "xpadneo";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "atar-axis";
    repo = pname;
    rev = "v${version}";
    sha256 = "113xa2mxs2hc4fpjdk3jhhchy81kli6jxdd6vib7zz61n10cjb85";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source/hid-xpadneo/src
  '';

  postPatch = ''
    # Set kernel module version
    substituteInPlace hid-xpadneo.c \
      --subst-var-by DO_NOT_CHANGE ${version}
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [ bluez ];

  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Advanced Linux driver for Xbox One wireless controllers";
    homepage = "https://atar-axis.github.io/xpadneo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ metadark ];
    platforms = platforms.linux;
  };
}
