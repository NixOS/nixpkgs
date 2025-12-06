{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  kernel,
  kernelModuleMakeFlags,
  bluez,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpadneo";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "atar-axis";
    repo = "xpadneo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-evmjQrQPHe8F+6w12bnUv6P4QKGkm63cmP1HEv6equw=";
  };

  patches = [
    # Remove deprecated ida_simple_xx() usage
    (fetchpatch {
      url = "https://github.com/orderedstereographic/xpadneo/commit/233e1768fff838b70b9e942c4a5eee60e57c54d4.patch";
      hash = "sha256-HL+SdL9kv3gBOdtsSyh49fwYgMCTyNkrFrT+Ig0ns7E=";
      stripLen = 2;
    })
  ];

  setSourceRoot = ''
    export sourceRoot=$(pwd)/${finalAttrs.src.name}/hid-xpadneo/src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;
  buildInputs = [ bluez ];

  makeFlags = kernelModuleMakeFlags ++ [
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

  meta = {
    description = "Advanced Linux driver for Xbox One wireless controllers";
    homepage = "https://atar-axis.github.io/xpadneo";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kira-bruneau ];
    platforms = lib.platforms.linux;
  };
})
