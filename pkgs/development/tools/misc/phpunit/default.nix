{ stdenv, fetchurl, makeWrapper, lib, php }:

let
  pname = "phpunit";
  version = "10.3.3";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://phar.phpunit.de/phpunit-${version}.phar";
    hash = "sha256-fhgsP/sA2nQXBQ34V2/Zvc+SPiDYWfkEXKKHoD+Heak=";
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
