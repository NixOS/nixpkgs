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
  pname = "n98-magerun";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/netz98/n98-magerun/releases/download/${finalAttrs.version}/n98-magerun.phar";
    hash = "sha256-s+Cdr8zU3VBaBzxOh4nXjqPe+JPPxHWiFOEVS/86qOQ=";
=======
{ stdenv, fetchFromGitHub, makeWrapper, unzip, lib, php80 }:

let
  pname = "n98-magerun";
  version = "2.3.0";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun1-dist";
    rev = version;
    sha256 = "sha256-T7wQmEEYMG0J6+9nRt+tiMuihjnjjQ7UWy1C0vKoQY4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontUnpack = true;

<<<<<<< HEAD
  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/n98-magerun

    install -D $src $out/libexec/n98-magerun/n98-magerun.phar
    makeWrapper ${php}/bin/php $out/bin/n98-magerun \
      --add-flags "$out/libexec/n98-magerun/n98-magerun.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}

    runHook postInstall
  '';

  meta = {
    broken = true; # Not compatible with PHP 8.1, see https://github.com/netz98/n98-magerun/issues/1275
    changelog = "https://magerun.net/category/magerun/";
    description = "The swiss army knife for Magento1/OpenMage developers";
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
    install -D $src/n98-magerun $out/libexec/n98-magerun/n98-magerun-${version}.phar
    makeWrapper ${php80}/bin/php $out/bin/n98-magerun \
      --add-flags "$out/libexec/n98-magerun/n98-magerun-${version}.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "The swiss army knife for Magento1/OpenMage developers";
    license = licenses.mit;
    homepage = "https://magerun.net/";
    changelog = "https://magerun.net/category/magerun/";
    maintainers = teams.php.members;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
