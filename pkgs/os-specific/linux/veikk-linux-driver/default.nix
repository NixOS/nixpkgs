{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "veikk-linux-driver";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "jlam55555";
    repo = "veikk-linux-driver";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Nn90s22yrynYFYLSlBN4aRvdISPsxBFr21yiohs5r4Y=";
  };

  patches = [ ./fix-6.12-build.patch ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ kernel ];

  makeFlags = kernelModuleMakeFlags ++ [
    "BUILD_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/veikk
    install -Dm755 veikk.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/veikk

    runHook postInstall
  '';

  meta = {
    description = "Linux driver for VEIKK-brand digitizers";
    homepage = "https://github.com/jlam55555/veikk-linux-driver/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nicbk ];
    broken = kernel.kernelOlder "4.19";
  };
})
