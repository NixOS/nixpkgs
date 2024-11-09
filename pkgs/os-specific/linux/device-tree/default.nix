{ lib, stdenv, stdenvNoCC, dtc, writers, python3 }:

{
  # Compile single Device Tree overlay source
  # file (.dts) into its compiled variant (.dtb)
  compileDTS = ({
    name,
    dtsFile,
    includePaths ? [],
    extraPreprocessorFlags ? []
  }: stdenv.mkDerivation {
    inherit name;

    nativeBuildInputs = [ dtc ];

    buildCommand =
      let
        includeFlagsStr = lib.concatMapStringsSep " " (includePath: "-I${includePath}") includePaths;
        extraPreprocessorFlagsStr = lib.concatStringsSep " " extraPreprocessorFlags;
      in
      ''
        $CC -E -nostdinc ${includeFlagsStr} -undef -D__DTS__ -x assembler-with-cpp ${extraPreprocessorFlagsStr} ${dtsFile} | \
        dtc -I dts -O dtb -@ -o $out
      '';
  });

  applyOverlays = (base: overlays': stdenvNoCC.mkDerivation {
    name = "device-tree-overlays";
    nativeBuildInputs = [
      (python3.pythonOnBuildForHost.withPackages(ps: [ps.libfdt]))
    ];
    buildCommand = ''
      python ${./apply_overlays.py} --source ${base} --destination $out --overlays ${writers.writeJSON "overlays.json" overlays'}
    '';
  });
}
