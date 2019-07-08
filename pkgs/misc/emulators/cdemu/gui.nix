{ callPackage, makeWrapper, gobject-introspection, cmake
, python3Packages, gtk3, glib, libnotify, intltool, gnome3, gdk_pixbuf, librsvg }:
let
  pkg = import ./base.nix {
    version = "3.2.1";
    pkgName = "gcdemu";
    pkgSha256 = "0lmyvhbf57wcm8k2a33j2dhy4gblaiycy33q070gdrxi37xk7w5g";
  };
  inherit (python3Packages) python pygobject3;
in callPackage pkg {
  buildInputs = [ python pygobject3 gtk3 glib libnotify intltool makeWrapper
                  gnome3.adwaita-icon-theme gdk_pixbuf librsvg ];
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
