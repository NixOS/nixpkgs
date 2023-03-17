{ stdenv, fetchurl, makeWrapper, lib, php }:

stdenv.mkDerivation rec {
  pname = "phpDocumentor";
  version = "3.3.1";

  src = fetchurl {
    url = "https://github.com/phpDocumentor/phpDocumentor/releases/download/v${version}/phpDocumentor.phar";
    sha256 = "SpPSeP1FgfF3YJAxNNhfzePUDZP3OcjGSPPtAsnD57s=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phpDocumentor/phpDocumentor.phar
    makeWrapper ${php}/bin/php $out/bin/phpdoc \
      --add-flags "$out/libexec/phpDocumentor/phpDocumentor.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "PHP documentation generator";
    license = licenses.mit;
    homepage = "https://phpdoc.org";
    changelog = "https://github.com/phpDocumentor/phpDocumentor/releases/tag/v${version}";
    maintainers = with maintainers; teams.php.members;
  };
}
