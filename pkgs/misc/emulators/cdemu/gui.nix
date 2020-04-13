{ callPackage, makeWrapper, gobject-introspection, cmake
, python3Packages, gtk3, glib, libnotify, intltool, gnome3, gdk-pixbuf, librsvg }:
let
  pkg = import ./base.nix {
    version = "3.2.3";
    pkgName = "gcdemu";
    pkgSha256 = "19vy1awha8s7cfja3a6npaf3rfy3pl3cbsh4vd609q9jz4v4lyg4";
  };
  inherit (python3Packages) python pygobject3;
in callPackage pkg {
  buildInputs = [ python pygobject3 gtk3 glib libnotify intltool makeWrapper
                  gnome3.adwaita-icon-theme gdk-pixbuf librsvg ];
  drvParams = {
    nativeBuildInputs = [ gobject-introspection cmake ];
    postFixup = ''
      wrapProgram $out/bin/gcdemu \
        --set PYTHONPATH "$PYTHONPATH" \
        --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH" \
        --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    '';
    # TODO AppIndicator
  };
}
