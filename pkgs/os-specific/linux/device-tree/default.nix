{ lib, stdenvNoCC, dtc }:

with lib; {
  applyOverlays = (base: overlays': stdenvNoCC.mkDerivation {
    name = "device-tree-overlays";
    nativeBuildInputs = [ dtc ];
    buildCommand = let
      overlays = toList overlays';
    in ''
      mkdir -p $out
      cd ${base}
      find . -type f -name '*.dtb' -print0 \
        | xargs -0 cp -v --no-preserve=mode --target-directory $out --parents

      for dtb in $(find $out -type f -name '*.dtb'); do
        dtbCompat="$( fdtget -t s $dtb / compatible )"

        ${flip (concatMapStringsSep "\n") overlays (o: ''
        overlayCompat="$( fdtget -t s ${o.dtboFile} / compatible )"
        # overlayCompat in dtbCompat
        if [[ "$dtbCompat" =~ "$overlayCompat" ]]; then
          echo "Applying overlay ${o.name} to $( basename $dtb )"
          mv $dtb{,.in}
          fdtoverlay -o "$dtb" -i "$dtb.in" ${o.dtboFile};
          rm $dtb.in
        fi
        '')}

      done
    '';
  });
}
