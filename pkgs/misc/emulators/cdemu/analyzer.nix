{ callPackage, gtk3, glib, libxml2, gnuplot, makeWrapper, stdenv, gnome3 }:
let pkg = import ./base.nix {
  version = "3.0.0";
  pkgName = "image-analyzer";
  pkgSha256 = "1rb3f7c08dxc02zrwrkfvq7qlzlmm0kd2ah1fhxj6ajiyshi8q4v";
};
in callPackage pkg {
  buildInputs = [ glib gtk3 libxml2 gnuplot (callPackage ./libmirage.nix {}) makeWrapper gnome3.gnome_icon_theme_symbolic ];
  drvParams = {
    postFixup = ''
      wrapProgram $out/bin/image-analyzer \
        --prefix XDG_DATA_DIRS : "$out/share:$GSETTINGS_SCHEMAS_PATH:$XDG_DATA_DIRS"
    '';
  };
}
