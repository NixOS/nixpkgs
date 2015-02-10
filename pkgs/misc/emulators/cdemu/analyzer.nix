{ callPackage, gtk3, libxml2, gnuplot, makeWrapper, stdenv }:
let pkg = import ./base.nix {
  version = "3.0.0";
  pkgName = "image-analyzer";
  pkgSha256 = "1rb3f7c08dxc02zrwrkfvq7qlzlmm0kd2ah1fhxj6ajiyshi8q4v";
};
in callPackage pkg {
  buildInputs = [ gtk3 libxml2 gnuplot (callPackage ./libmirage.nix {}) makeWrapper ];
  drvParams = {
    postFixup = ''
      wrapProgram $out/bin/image-analyzer \
        --set XDG_DATA_DIRS "$out/share:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS"
    '';
  };
}
