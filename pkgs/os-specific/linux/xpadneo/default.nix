{ lib
, stdenv
, fetchFromGitHub
, kernel
, bluez
, nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpadneo";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "atar-axis";
    repo = "xpadneo";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-rT2Mq40fE055FemDG7PBjt+cxgIHJG9tTjtw2nW6B98=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/${finalAttrs.src.name}/hid-xpadneo/src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [ bluez ];

  makeFlags = kernel.makeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${finalAttrs.version}"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  passthru.tests = {
    xpadneo = nixosTests.xpadneo;
  };

  meta = with lib; {
    description = "Advanced Linux driver for Xbox One wireless controllers";
    homepage = "https://atar-axis.github.io/xpadneo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
})
