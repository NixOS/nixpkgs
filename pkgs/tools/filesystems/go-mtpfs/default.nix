{ stdenv, lib, pkgconfig, libusb1, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "go-mtpfs-${version}";
  version = "20150917-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "bc7c0f716e3b4ed5610069a55fc00828ebba890b";

  goPackagePath = "github.com/hanwen/go-mtpfs";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1 ];

  src = fetchgit {
    inherit rev;
    url = "https://github.com/hanwen/go-mtpfs";
    sha256 = "1jcqp9n8fd9psfsnhfj6w97yp0zmyxplsig8pyp2gqzh4lnb5fqm";
  };

  goDeps = ./deps.nix;
}
