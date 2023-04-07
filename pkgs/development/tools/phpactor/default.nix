{ lib, stdenvNoCC, fetchFromGitHub, php, composer }:

stdenvNoCC.mkDerivation rec {
  pname = "phpactor";
  version = "2023.01.21";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = version;
    hash = "sha256-jWZgBEaffjQ5wCStSEe+eIi7BJt6XAQFEjmq5wvW5V8=";
  };

  nativeBuildInputs = [
    composer
    php
  ];

  buildPhase = ''
    runHook preBuild

    substituteInPlace composer.json \
      --replace '"config": {' '"config": { "autoloader-suffix": "Phpactor",' \
      --replace '"name": "phpactor/phpactor",' '"name": "phpactor/phpactor", "version": "${version}",'

    composer install --no-interaction --optimize-autoloader --no-dev --no-scripts

    sha256sum composer.lock
    cat composer.lock

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/php/phpactor $out/bin
    cp -r . $out/share/php/phpactor
    ln -s $out/share/php/phpactor/bin/phpactor $out/bin/phpactor

    runHook postInstall
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-UCXrSXcNHHnVOizm0U099iwGEGWkpFZe0NyoKRJ0jaA=";

  meta = {
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members ++ [ lib.maintainers.ryantm ];
  };

}
