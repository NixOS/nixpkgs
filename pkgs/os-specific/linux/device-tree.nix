{ stdenvNoCC, dtc, findutils, raspberrypifw }:

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

  raspberryPiDtbs = stdenvNoCC.mkDerivation {
    name = "raspberrypi-dtbs-${raspberrypifw.version}";
    nativeBuildInputs = [ raspberrypifw ];
    buildCommand = ''
      mkdir -p $out/broadcom/
      cp ${raspberrypifw}/share/raspberrypi/boot/bcm*.dtb $out/broadcom
    '';
  };

  raspberryPiOverlays = "${raspberrypifw}/share/raspberrypi/boot/overlays";
}
