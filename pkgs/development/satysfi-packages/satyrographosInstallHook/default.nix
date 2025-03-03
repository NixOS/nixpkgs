{
  lib,
  stdenv,
  python3,
  python3Packages,
}:
stdenv.mkDerivation {
  name = "satyrographosInstallHook";
  propagatedBuildInputs = [
    python3
    python3Packages.sexpdata
  ];

  src = ./.;

  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r $src/satyrographosInstallHook.py $out/bin/satyrographosInstallHook
    patchShebangs $out/bin
    chmod +x $out/bin/satyrographosInstallHook
    runHook postInstall
  '';

  meta = {
    description = "Install hook for Satyrographos";
    mainProgram = "satyrographosInstallHook";
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
