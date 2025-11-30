{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "hid-ite8291r3";
  version = "0-unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "pobrn";
    repo = "hid-ite8291r3";
    rev = "961702de7d80609a2a21567e44dd2fe860b96c87";
    hash = "sha256-egFX+Dm3KSEVAP/YIy1/KUypBHClZW8o49ua47o64N8=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "VERSION=${version}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -D hid-ite8291r3.ko -t $out/lib/modules/${kernel.modDirVersion}/extra
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "Linux driver for the ITE 8291 RGB keyboard backlight controller";
    homepage = "https://github.com/pobrn/hid-ite8291r3/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ aacebedo ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.9";
  };
}
