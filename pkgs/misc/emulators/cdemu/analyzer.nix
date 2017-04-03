{ callPackage, gtk3, glib, libxml2, gnuplot, makeWrapper, stdenv, gnome3, gdk_pixbuf, librsvg, intltool }:
let pkg = import ./base.nix {
  version = "3.0.1";
  pkgName = "image-analyzer";
  pkgSha256 = "19x5hx991pl55ddm2wjd2ylm2hiz9yvzgrwmpnsqr9zqc4lja682";
};
in callPackage pkg {
  buildInputs = [ glib gtk3 libxml2 gnuplot (callPackage ./libmirage.nix {}) makeWrapper
                  gnome3.defaultIconTheme gdk_pixbuf librsvg intltool ];
  drvParams = {
    postFixup = ''
      wrapProgram $out/bin/image-analyzer \
        --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    '';
  };
}
