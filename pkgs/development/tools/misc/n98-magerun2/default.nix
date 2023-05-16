<<<<<<< HEAD
{
  stdenv
, fetchurl
, makeBinaryWrapper
, php
, lib
, unzip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n98-magerun2";
  version = "7.1.0";

  src = fetchurl {
    url = "https://github.com/netz98/n98-magerun2/releases/download/${finalAttrs.version}/n98-magerun2.phar";
    hash = "sha256-DE5q1zoWZ4gJSs5JM5cr157oh5ufD1gaNt9X9vtuW/c=";
=======
{ stdenv, fetchFromGitHub, makeWrapper, unzip, lib, php }:

let
  pname = "n98-magerun2";
  version = "6.1.1";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2-dist";
    rev = version;
    sha256 = "sha256-D2U1kLG6sOpBHDzNQ/LbiFUknvFhK+rkOPgWvW0pNmY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontUnpack = true;

<<<<<<< HEAD
  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/n98-magerun2

    install -D $src $out/libexec/n98-magerun2/n98-magerun2.phar
    makeWrapper ${php}/bin/php $out/bin/n98-magerun2 \
      --add-flags "$out/libexec/n98-magerun2/n98-magerun2.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}

    runHook postInstall
  '';

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "The swiss army knife for Magento2 developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
=======
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src/n98-magerun2 $out/libexec/n98-magerun2/n98-magerun2-${version}.phar
    makeWrapper ${php}/bin/php $out/bin/n98-magerun2 \
      --add-flags "$out/libexec/n98-magerun2/n98-magerun2-${version}.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "The swiss army knife for Magento2 developers";
    license = licenses.mit;
    homepage = "https://magerun.net/";
    changelog = "https://magerun.net/category/magerun/";
    maintainers = teams.php.members;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
