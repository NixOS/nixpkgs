{ stdenv, fetchFromGitHub, kernel, bluez }:

stdenv.mkDerivation rec {
  pname = "xpadneo";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "atar-axis";
    repo = pname;
    rev = "v${version}";
    sha256 = "1g3ml7vq0dzwl9815c3l0i0qz3a7v8c376c6dqbfkbj2f1d43vqs";
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

  meta = with stdenv.lib; {
    description = "Advanced Linux driver for Xbox One wireless controllers";
    homepage = "https://atar-axis.github.io/xpadneo";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
