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
  outputHash = {
      aarch64-linux = "sha256-DeTJV0kBV83vJXgrK7qiTHxXjBQY+SNwj1HhFi48cMw=";
      x86_64-linux = "sha256-UCXrSXcNHHnVOizm0U099iwGEGWkpFZe0NyoKRJ0jaA=";
      x86_64-darwin = "sha256-IERtY7Eb1OMDagnblKMIk33Z0VO/qnhhI0UIAlTnDCY=";
    }.${stdenvNoCC.system};

  meta = {
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members ++ [ lib.maintainers.ryantm ];
  };

}
