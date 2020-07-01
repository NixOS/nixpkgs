{ stdenv, callPackage, wineUnstable }:

with callPackage ./util.nix {};

let patch = (callPackage ./sources.nix {}).staging;
    build-inputs = pkgNames: extra:
      (mkBuildInputs wineUnstable.pkgArches pkgNames) ++ extra;
in assert stdenv.lib.getVersion wineUnstable == patch.version;

(stdenv.lib.overrideDerivation wineUnstable (self: {
  buildInputs = build-inputs [ "perl" "utillinux" "autoconf" ] self.buildInputs;

  name = "${self.name}-staging";

  postPatch = self.postPatch or "" + ''
    patchShebangs tools
    cp -r ${patch}/patches .
    chmod +w patches
    cd patches
    patchShebangs gitapply.sh
    ./patchinstall.sh DESTDIR="$PWD/.." --all
    cd ..
  '';
})) // {
  meta = wineUnstable.meta // {
    description = wineUnstable.meta.description + " (with staging patches)";
  };
}
