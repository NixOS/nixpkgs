{ stdenv, pkgconfig, libusb1, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "go-mtpfs-${version}";
  version = "2018-02-09";
  rev = "d6f8f3c05ce0ed31435057ec342268a0735863bb";

  goPackagePath = "github.com/hanwen/go-mtpfs";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1 ];

  src = fetchgit {
    inherit rev;
    url = "https://github.com/hanwen/go-mtpfs";
    sha256 = "0a0d5dy92nzp1czh87hx3xfdcpa4jh14j0b64c025ha62s9a4gxk";
  };

  goDeps = ./deps.nix;
}
