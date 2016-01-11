{ stdenv, callPackage, lib, fetchFromGitHub, wineUnstable, libtxc_dxtn_Name }:

with callPackage ./util.nix {};

let v = (import ./versions.nix).staging;
    inherit (v) version;
    patch = fetchFromGitHub {
      inherit (v) sha256;
      owner = "wine-compholio";
      repo = "wine-staging";
      rev = "v${version}";
    };
    build-inputs = pkgNames: extra:
      (mkBuildInputs wineUnstable.pkgArches pkgNames) ++ extra;
in assert (builtins.parseDrvName wineUnstable.name).version == version;

stdenv.lib.overrideDerivation wineUnstable (self: {
  nativeBuildInputs = build-inputs [ libtxc_dxtn_Name ] self.nativeBuildInputs; 
  buildInputs = build-inputs [ "perl" "utillinux" "autoconf" ] self.buildInputs;

  name = "${self.name}-staging";

  postPatch = self.postPatch or "" + ''
    patchShebangs tools
    cp -r ${patch}/patches .
    chmod +w patches
    cd patches
    patchShebangs gitapply.sh
    ./patchinstall.sh DESTDIR="$TMP/$sourceRoot" --all
    cd ..
  '';
})
