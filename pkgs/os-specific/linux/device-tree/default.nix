{ stdenvNoCC, dtc, raspberrypi-tools, findutils }:

with stdenvNoCC.lib; {
  # Merge overlays with `fdtoverlay` from `dtc`
  applyOverlays = (base: overlays': stdenvNoCC.mkDerivation (let
    overlays = toList overlays';
    overlayPaths = assert all (o: length o.params == 0) overlays;
      map (o: o.overlay) overlays;
  in {
    name = "device-tree-overlays";
    nativeBuildInputs = [ dtc findutils ];
    buildCommand = ''
      for dtb in $(find ${escapeShellArg base} -name "*.dtb" ); do
        outDtb=$out/$(realpath --relative-to ${escapeShellArg base} "$dtb")
        mkdir -p "$(dirname "$outDtb")"
        fdtoverlay -o "$outDtb" -i "$dtb" ${escapeShellArgs overlayPaths};
      done
    '';
  }));

  # Merge overlays with `dtmerge` from `raspberrypi-tools`
  mergeOverlays = (base: overlays': stdenvNoCC.mkDerivation (let
    overlays = toList overlays';
    dtmergeCommands = concatImapStringsSep "\n" (i: o: ''
      dtmerge $TMPDIR/${toString (i - 1)}.dtb $TMPDIR/${toString i}.dtb \
        ${escapeShellArg o.overlay} ${escapeShellArgs o.params}
    '') overlays;
  in {
    name = "device-tree-overlays";
    nativeBuildInputs = [ raspberrypi-tools findutils ];
    buildCommand = ''
      for dtb in $(find ${escapeShellArg base} -name "*.dtb" ); do
        cp -f $dtb $TMPDIR/0.dtb
        ${dtmergeCommands}

        outDtb=$out/$(realpath --relative-to ${escapeShellArg base} "$dtb")
        mkdir -p "$(dirname "$outDtb")"
        cp $TMPDIR/${toString (length overlays)}.dtb $outDtb
      done
    '';
  }));
}
