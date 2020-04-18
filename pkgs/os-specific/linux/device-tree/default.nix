{ stdenvNoCC, dtc, findutils }:

with stdenvNoCC.lib; {
  applyOverlays = (base: overlays: stdenvNoCC.mkDerivation {
    name = "device-tree-overlays";
    nativeBuildInputs = [ dtc findutils ];
    buildCommand = let
      quotedDtbos = concatMapStringsSep " " (o: "\"${toString o}\"") (toList overlays);
    in ''
      for dtb in $(find ${base} -name "*.dtb" ); do
        outDtb=$out/$(realpath --relative-to "${base}" "$dtb")
        mkdir -p "$(dirname "$outDtb")"
        fdtoverlay -o "$outDtb" -i "$dtb" ${quotedDtbos};
      done
    '';
  });
}
