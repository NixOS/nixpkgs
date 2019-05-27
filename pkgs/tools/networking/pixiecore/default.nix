{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "netboot-unstable-${version}";
  version = "2019-02-14";
  rev = "01f30467ac8e8f4e3a3c6b6a8642d62a04e97631";

  goPackagePath = "go.universe.tf/netboot";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/google/netboot";
    sha256 = "1ddbp63zx1qwxwm58cx9km2nbccwgy032v143nwa4gq9z4p5mr0z";
  };

  goDeps = ./deps.nix;

  # TODO: add metadata https://nixos.org/nixpkgs/manual/#sec-standard-meta-attributes
  meta = {
    description = "A tool to manage network booting of machines";
    homepage = "https://github.com/danderson/netboot/tree/master/pixiecore";
    license =  stdenv.lib.licenses.asl20;
    maintainers = [ "Rauno Väli rauno@oyenetwork.com" ];
    platforms = stdenv.lib.platforms.linux;
  };
}
