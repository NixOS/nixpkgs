{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpadneo";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "atar-axis";
    repo = "xpadneo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GeQls+DeJrzduBRQw0rc9hf58Ncd5fRmn6Xwn0kMaXs=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/${finalAttrs.src.name}/hid-xpadneo/src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${finalAttrs.version}"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  passthru = {
    tests.xpadneo = nixosTests.xpadneo;
    updateScript = nix-update-script {
      extraArgs = [
        # Skips pre-releases
        "--version-regex"
        "^v([\\d.]+)$"
      ];
    };
  };

  meta = {
    description = "Advanced Linux driver for Xbox One wireless controllers";
    homepage = "https://atar-axis.github.io/xpadneo";
    changelog = "https://github.com/atar-axis/xpadneo/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl2Only
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ kira-bruneau ];
    platforms = lib.platforms.linux;
  };
})
