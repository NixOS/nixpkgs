{ stdenv, callPackage, lib, wineUnstable, libtxc_dxtn_Name }:

with callPackage ./util.nix {};

let patch = (callPackage ./sources.nix {}).staging;
    build-inputs = pkgNames: extra:
      (mkBuildInputs wineUnstable.pkgArches pkgNames) ++ extra;
in assert (builtins.parseDrvName wineUnstable.name).version == patch.version;

stdenv.lib.overrideDerivation wineUnstable (self: {
  buildInputs = build-inputs [ "perl" "utillinux" "autoconf" libtxc_dxtn_Name ] self.buildInputs;

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
})
