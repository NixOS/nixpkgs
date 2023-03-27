{ stdenv, fetchurl, makeBinaryWrapper, lib, php }:

stdenv.mkDerivation rec {
  pname = "phpbench";
  version = "1.2.10";

  src = fetchurl {
    url = "https://github.com/phpbench/phpbench/releases/download/${version}/phpbench.phar";
    hash = "sha256-pdgeUvlBp3JtR7+OR+LnXaBQlPq/Mnfpzhtds4h9UOQ=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -D $src $out/libexec/phpbench/phpbench.phar
    makeWrapper ${php}/bin/php $out/bin/phpbench \
      --add-flags "$out/libexec/phpbench/phpbench.phar"

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/phpbench/phpbench/blob/${version}/CHANGELOG.md";
    description = "PHP Benchmarking framework";
    homepage = "https://github.com/phpbench/phpbench";
    license = licenses.mit;
    maintainers = with maintainers; [ drupol ] ++ teams.php.members;
  };
}
