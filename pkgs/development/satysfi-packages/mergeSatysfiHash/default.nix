{
  lib,
  stdenv,
  python3,
}:
stdenv.mkDerivation {
  name = "mergeSatysfiHash";

  src = ./.;

  dontBuild = true;

  propagatedBuildInputs = [
    python3
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/mergeSatysfiHash.py $out/bin/mergeSatysfiHash
    patchShebangs $out/bin
    chmod +x $out/bin/mergeSatysfiHash
    runHook postInstall
  '';

  meta = {
    description = "Merge SATySFi hash files";
    mainProgram = "mergeSatysfiHash";
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
