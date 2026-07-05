{
  lib,
  makeWrapper,
  symlinkJoin,
  radare2,
  plugins,
}:
symlinkJoin {
  name = "radare2-with-plugins-${radare2.version}";

  paths = [ radare2 ] ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  passthru = {
    unwrapped = radare2;
  };

  postBuild = ''
    mkdir -p $out/share/radare2-plugins-home/radare2
    ln -s $out/lib/radare2/plugins $out/share/radare2-plugins-home/radare2/plugins

    wrapperArgs=(--set XDG_DATA_HOME "$out/share/radare2-plugins-home")
    # r2ghidra looks up its sleigh specs relative to $SLEIGHHOME instead of
    # scanning dir.plugins/XDG_DATA_HOME like other plugins.
    if [ -d "$out/lib/radare2/plugins/r2ghidra_sleigh" ]; then
      wrapperArgs+=(--set SLEIGHHOME "$out/lib/radare2/plugins/r2ghidra_sleigh")
    fi

    rm $out/bin/*
    for binary in $(ls ${radare2}/bin); do
      makeWrapper ${radare2}/bin/$binary $out/bin/$binary "''${wrapperArgs[@]}"
    done
  '';

  meta = radare2.meta // {
    # prefer wrapped over unwrapped
    priority = (radare2.meta.priority or lib.meta.defaultPriority) - 1;
  };
}
