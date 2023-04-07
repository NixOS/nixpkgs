{ lib, stdenvNoCC, fetchFromGitHub, php }:

stdenvNoCC.mkDerivation rec {
  pname = "phpactor";
  version = "2023.01.21";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = version;
    hash = "sha256-jWZgBEaffjQ5wCStSEe+eIi7BJt6XAQFEjmq5wvW5V8=";
  };

  vendor = stdenvNoCC.mkDerivation rec {
    pname = "phpactor-vendor";

    inherit src version;

    # See https://github.com/NixOS/nix/issues/6660
    dontPatchShebangs = true;

    nativeBuildInputs = [
      php
    ];

    buildPhase = ''
      runHook preBuild

      substituteInPlace composer.json \
        --replace '"config": {' '"config": { "autoloader-suffix": "Phpactor",'
      ${php.packages.composer}/bin/composer install --no-interaction --optimize-autoloader --no-dev --no-scripts

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -ar ./vendor $out/

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-7N6PGtk+pEzw7jsJzQ4s5jVOOiY6OW/1dAYnhOy2grE=";
  };

  buildInputs = [
    php
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/php/phpactor $out/bin
    cp -r . $out/share/php/phpactor
    cp -r ${vendor}/vendor $out/share/php/phpactor
    ln -s $out/share/php/phpactor/bin/phpactor $out/bin/phpactor

    runHook postInstall
  '';

  meta = {
    description = "Mainly a PHP Language Server";
    homepage = "https://github.com/phpactor/phpactor";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members ++ [ lib.maintainers.ryantm ];
  };

}
