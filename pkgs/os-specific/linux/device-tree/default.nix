{ lib, stdenvNoCC, dtc }:

with lib; {
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
          echo -n "Skipping overlay ${o.name}: incompatible with $(basename "$dtb")"
          continue
        fi
        ${optionalString (o.filter != null) ''
        if [[ "''${dtb//${o.filter}/}" ==  "$dtb" ]]; then
          echo -n "Skipping overlay ${o.name}: filter does not match $(basename "$dtb")"
          continue
        fi
        ''}

        echo -n "Applying overlay ${o.name} to $(basename "$dtb")... "
        mv "$dtb"{,.in}
        fdtoverlay -o "$dtb" -i "$dtb.in" "${o.dtboFile}"
        echo "ok"
        rm "$dtb.in"
        '')}

      done
    '';
  });
}
