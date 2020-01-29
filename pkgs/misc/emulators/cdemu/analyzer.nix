{ callPackage, makeWrapper, gobject-introspection, cmake
, python3Packages, gtk3, glib, libxml2, gnuplot, gnome3, gdk-pixbuf, librsvg, intltool, libmirage }:
let pkg = import ./base.nix {
  version = "3.2.3";
  pkgName = "image-analyzer";
  pkgSha256 = "17yfjmf65s77214qassz6l01cjcni4cv06nzfsm7qrzw172fmci4";
};
in callPackage pkg {
  buildInputs = [ glib gtk3 libxml2 gnuplot libmirage makeWrapper
                  gnome3.adwaita-icon-theme gdk-pixbuf librsvg intltool
                  python3Packages.python python3Packages.pygobject3 python3Packages.matplotlib ];
  drvParams = {
    nativeBuildInputs = [ gobject-introspection cmake ];
    postFixup = ''
      wrapProgram $out/bin/image-analyzer \
        --set PYTHONPATH "$PYTHONPATH" \
        --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH" \
        --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    '';
  };
}
