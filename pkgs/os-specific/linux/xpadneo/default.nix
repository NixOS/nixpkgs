{ lib
, stdenv
, fetchFromGitHub
, kernel
, bluez
, nixosTests
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpadneo";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "atar-axis";
    repo = "xpadneo";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-pX9zpAGnhDLKUAKOQ5iqtK8cKEkjCqDa5v3MwYViWX4=";
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Advanced Linux driver for Xbox One wireless controllers";
    homepage = "https://atar-axis.github.io/xpadneo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
})
