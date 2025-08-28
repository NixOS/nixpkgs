{
  lib,
  buildGhidraExtension,
  ghidra,
  python3,
}:

buildGhidraExtension {
  pname = "sleighdevtools";
  version = lib.getVersion ghidra;

  src = "${ghidra}/lib/ghidra/Extensions/Ghidra/${ghidra.distroPrefix}_SleighDevTools.zip";
  dontUnpack = true;

  # Built as part ghidra
  dontBuild = true;
  buildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/ghidra/Ghidra/Extensions
    unzip -d $out/lib/ghidra/Ghidra/Extensions $src

    runHook postInstall
  '';

  meta = with lib; {
    inherit (ghidra.meta) homepage license;
    description = "Sleigh language development tools including external disassembler capabilities";
    longDescription = ''
      Sleigh language development tools including external disassembler capabilities.
      The GnuDisassembler extension may be also be required as a disassembly provider.
    '';
    downloadPage = "https://github.com/NationalSecurityAgency/ghidra/tree/master/Ghidra/Extensions/SleighDevTools";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
  };
}
