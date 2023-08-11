{ lib
, makeWrapper
, symlinkJoin
, unwrapped
, plugins
# NIX_RZ_PREFIX only changes where *Rizin* locates files (plugins,
# themes, etc). But we must change it even for wrapping Cutter, because
# Cutter plugins often have associated Rizin plugins. This means that
# NIX_RZ_PREFIX must always contain Rizin files, even if we only wrap
# Cutter - so for Cutter, include Rizin to symlinkJoin paths.
, rizin ? null
}:

symlinkJoin {
  name = "${unwrapped.pname}-with-plugins-${unwrapped.version}";

  paths = [ unwrapped ] ++ lib.optional (rizin != null) rizin ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  passthru = {
    inherit unwrapped;
  };

  postBuild = ''
    rm $out/bin/*
    wrapperArgs=(--set NIX_RZ_PREFIX $out)
    if [ -d $out/share/rizin/cutter ]; then
      wrapperArgs+=(--prefix XDG_DATA_DIRS : $out/share)
    fi
    for binary in $(ls ${unwrapped}/bin); do
      makeWrapper ${unwrapped}/bin/$binary $out/bin/$binary "''${wrapperArgs[@]}"
    done
    ${lib.optionalString (rizin != null) ''
      for binary in $(ls ${rizin}/bin); do
        makeWrapper ${rizin}/bin/$binary $out/bin/$binary "''${wrapperArgs[@]}"
      done
    ''}
  '';

  meta = unwrapped.meta // {
    # prefer wrapped over unwrapped, prefer cutter wrapper over rizin wrapper
    # (because cutter versions of plugins also contain rizin plugins)
    priority = (unwrapped.meta.priority or 0) - (if rizin != null then 2 else 1);
  };
}
