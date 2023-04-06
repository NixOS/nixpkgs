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

  buildInputs = [
    composer
    php
  ];

  buildPhase = ''
    patchShebangs .
    substituteInPlace composer.json \
      --replace '"config": {' '"config": { "autoloader-suffix": "Phpactor",' \
      --replace '"name": "phpactor/phpactor",' '"name": "phpactor/phpactor", "version": "${version}",'

    composer dump-autoload --optimize --no-dev
    composer install --no-interaction --optimize-autoloader --no-dev

    mkdir -p $out/share/php/phpactor $out/bin
    cp -r . $out/share/php/phpactor
    ln -s $out/share/php/phpactor/bin/phpactor $out/bin/phpactor
  '';

  dontInstall = true;

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-Vf7tuzKekbWju0Tgef3MTAMi59dDxILV4A3DSRUORts=";

  meta = with lib; {
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = licenses.mit;
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };

}
