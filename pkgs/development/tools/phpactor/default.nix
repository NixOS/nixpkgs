{ lib, stdenvNoCC, fetchFromGitHub, php, phpPackages }:

let
  version = "2023.06.17";

  src = fetchFromGitHub {
    owner = "phpactor";
    repo = "phpactor";
    rev = version;
    hash = "sha256-NI+CLXlflQ8zQ+0AbjhJFdV6Y2+JGy7XDj0RBJ4YRRg=";
  };

  vendor = stdenvNoCC.mkDerivation {
    pname = "phpactor-vendor";
    inherit src version;

    # See https://github.com/NixOS/nix/issues/6660
    dontPatchShebangs = true;

    nativeBuildInputs = [
      php
      phpPackages.composer
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

      mkdir -p $out
      cp -ar ./vendor $out/

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-fjcfdNzQsVgRpksxybSIpdHz1BOLTlY49Cjeaw0Evl8=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "phpactor";
  inherit src version;

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
