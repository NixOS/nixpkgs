{ lib, stdenv, stdenvNoCC, dtc }:

with lib; {
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
    nativeBuildInputs = [ dtc ];
    buildCommand = let
      overlays = toList overlays';
    in ''
      mkdir -p $out
      cd "${base}"
      find . -type f -name '*.dtb' -print0 \
        | xargs -0 cp -v --no-preserve=mode --target-directory "$out" --parents

      for dtb in $(find "$out" -type f -name '*.dtb'); do
        dtbCompat=$(fdtget -t s "$dtb" / compatible 2>/dev/null || true)
        # skip files without `compatible` string
        test -z "$dtbCompat" && continue

        ${flip (concatMapStringsSep "\n") overlays (o: ''
        overlayCompat="$(fdtget -t s "${o.dtboFile}" / compatible)"

        # skip incompatible and non-matching overlays
        if [[ ! "$dtbCompat" =~ "$overlayCompat" ]]; then
          echo "Skipping overlay ${o.name}: incompatible with $(basename "$dtb")"
        elif ${if (o.filter == null) then "false" else ''
          [[ "''${dtb//${o.filter}/}" ==  "$dtb" ]]
        ''}
        then
          echo "Skipping overlay ${o.name}: filter does not match $(basename "$dtb")"
        else
          echo -n "Applying overlay ${o.name} to $(basename "$dtb")... "
          mv "$dtb"{,.in}
          fdtoverlay -o "$dtb" -i "$dtb.in" "${o.dtboFile}"
          echo "ok"
          rm "$dtb.in"
        fi
        '')}

      done
    '';
  });
}
