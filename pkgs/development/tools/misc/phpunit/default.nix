{ stdenv, fetchurl, makeWrapper, lib, php }:

let
  pname = "phpunit";
<<<<<<< HEAD
  version = "10.3.3";
=======
  version = "10.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://phar.phpunit.de/phpunit-${version}.phar";
<<<<<<< HEAD
    hash = "sha256-fhgsP/sA2nQXBQ34V2/Zvc+SPiDYWfkEXKKHoD+Heak=";
=======
    hash = "sha256-X6upMANmKU2H8Qs0pOd/uRL2GdH/JPyOAQ/P8Z5yNl8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phpunit/phpunit.phar
    makeWrapper ${php}/bin/php $out/bin/phpunit \
      --add-flags "$out/libexec/phpunit/phpunit.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "PHP Unit Testing framework";
    license = licenses.bsd3;
    homepage = "https://phpunit.de";
    changelog = "https://github.com/sebastianbergmann/phpunit/blob/${version}/ChangeLog-${lib.versions.majorMinor version}.md";
    maintainers = with maintainers; [ onny ] ++ teams.php.members;
    platforms = platforms.all;
  };
}
