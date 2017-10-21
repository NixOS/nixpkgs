{ callPackage, gtk3, glib, libxml2, gnuplot, makeWrapper, stdenv, gnome3, gdk_pixbuf, librsvg, intltool }:
let pkg = import ./base.nix {
  version = "3.1.0";
  pkgName = "image-analyzer";
  pkgSha256 = "1pr23kxx83xp83h27fkdv86f3bxclkx056f9jx8jhnpn113xp7r2";
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
