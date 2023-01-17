{ boehmgc-nix_2_3
, fetchurl
, common
, patch-monitorfdhup
, ...
}:

(common rec {
  version = "2.3.16";
  src = fetchurl {
    url = "https://nixos.org/releases/nix/nix-${version}/nix-${version}.tar.xz";
    hash = "sha256-fuaBtp8FtSVJLSAsO+3Nne4ZYLuBj2JpD2xEk7fCqrw=";
  };
  patches = [
    patch-monitorfdhup
  ];
})
  .override {
    boehmgc = boehmgc-nix_2_3;
  }

