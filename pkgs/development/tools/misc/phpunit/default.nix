{ stdenv, fetchurl, makeWrapper, lib, php }:

let
  pname = "phpunit";
  version = "10.0.16";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://phar.phpunit.de/phpunit-${version}.phar";
    hash = "sha256-e/wUIri2y4yKI1V+U/vAD3ef2ZeKxBcFrb0Ay/rlTtM=";
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
  };
}
