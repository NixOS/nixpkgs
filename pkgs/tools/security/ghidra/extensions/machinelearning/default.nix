{
  lib,
  buildGhidraExtension,
  ghidra,
}:

buildGhidraExtension {
  pname = "machinelearning";
  version = lib.getVersion ghidra;

  src = "${ghidra}/lib/ghidra/Extensions/Ghidra/${ghidra.distroPrefix}_MachineLearning.zip";
  dontUnpack = true;

  # Built as part ghidra
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/ghidra/Ghidra/Extensions
    unzip -d $out/lib/ghidra/Ghidra/Extensions $src

    runHook postInstall
  '';

  meta = with lib; {
    inherit (ghidra.meta) homepage license;
    description = "Finds functions using ML";
    downloadPage = "https://github.com/NationalSecurityAgency/ghidra/tree/master/Ghidra/Extensions/MachineLearning";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
  };
}
