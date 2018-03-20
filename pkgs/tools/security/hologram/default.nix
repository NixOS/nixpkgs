{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hologram-2018-03-19";
  rev = "a7bab58642b530edb75b9cf6c1d834c85822ceac";

  src = fetchFromGitHub {
    owner = "AdRoll";
    repo = "hologram";
    inherit rev;
    sha256 = "00scryz8js6gbw8lp2y23qikbazz2dd992r97rqh0l1q4baa0ckn";
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
