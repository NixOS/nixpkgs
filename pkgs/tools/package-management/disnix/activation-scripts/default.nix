{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "disnix-activation-scripts-test";
  src = fetchurl {
    url = http://hydra.nixos.org/build/333630/download/1/disnix-activation-scripts-nixos-0.1.tar.gz;
    sha256 = "0izkkdw9r2gff03mq973ah5b9b0a4b07l8ac0406yv8ss9vaaclm";
  };
}
