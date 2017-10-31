{ callPackage, pythonPackages, gtk3, glib, libnotify, intltool, makeWrapper, gobjectIntrospection, gnome3, gdk_pixbuf, librsvg }:
let
  pkg = import ./base.nix {
    version = "3.1.0";
    pkgName = "gcdemu";
    pkgSha256 = "0rmnw302fk9vli22v54qx19lqxy23syxi154klxz2vma009q0p02";
  };
  inherit (pythonPackages) python pygobject3;
in callPackage pkg {
  buildInputs = [ python pygobject3 gtk3 glib libnotify intltool makeWrapper
                  gnome3.defaultIconTheme gdk_pixbuf librsvg ];
  drvParams = {
    postFixup = ''
      wrapProgram $out/bin/gcdemu \
        --set PYTHONPATH "$PYTHONPATH" \
        --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH" \
        --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    '';
    # TODO AppIndicator
  };
}
