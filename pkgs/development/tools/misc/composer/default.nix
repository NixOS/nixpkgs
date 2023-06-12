{ lib, stdenvNoCC, fetchurl, php, unzip, _7zz, xz, git, curl, cacert, makeBinaryWrapper }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "composer-phar";
  version = "2.5.8";

  src = fetchurl {
    url = "https://github.com/composer/composer/releases/download/${finalAttrs.version}/composer.phar";
    hash = "sha256-8Hk0+tRPkEjA3IdaUGzKMcwnlNauv8GGfzsfv0jc4sU=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -D $src $out/libexec/composer/composer.phar
    makeWrapper ${php}/bin/php $out/bin/composer \
      --add-flags "$out/libexec/composer/composer.phar" \
      --prefix PATH : ${lib.makeBinPath [ _7zz cacert curl git unzip xz ]}

    runHook postInstall
  '';

  meta = {
    description = "Dependency Manager for PHP, shipped from the PHAR file";
    license = lib.licenses.mit;
    homepage = "https://getcomposer.org/";
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    maintainers = lib.teams.php.members;
    platforms = lib.platforms.all;
  };
})
