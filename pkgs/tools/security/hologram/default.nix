{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "hologram-${version}";
  version = "20170130-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "d20d1c30379e7010e8f9c428a5b9e82f54d390e1";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/AdRoll/hologram";
    sha256 = "0dg5kfs16kf2gzhpmzsg83qzi2pxgnc9g81lw5zpa6fmzpa9kgsn";
  };

  goPackagePath = "github.com/AdRoll/hologram";

  goDeps = ./deps.nix;

  preConfigure = ''
    sed -i 's|cacheTimeout != 3600|cacheTimeout != 0|' cmd/hologram-server/main.go
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/AdRoll/hologram/;
    description = "Easy, painless AWS credentials on developer laptops.";
    maintainers = with maintainers; [ nand0p ];
    platforms = platforms.all;
    license = licenses.asl20;
  };
}
