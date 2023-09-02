{
  stdenv
, fetchurl
, makeBinaryWrapper
, php
, lib
, unzip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n98-magerun";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/netz98/n98-magerun/releases/download/${finalAttrs.version}/n98-magerun-${finalAttrs.version}.phar";
    hash = "sha256-s+Cdr8zU3VBaBzxOh4nXjqPe+JPPxHWiFOEVS/86qOQ=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/n98-magerun

    install -D $src $out/libexec/n98-magerun/n98-magerun.phar
    makeWrapper ${php}/bin/php $out/bin/n98-magerun \
      --add-flags "$out/libexec/n98-magerun/n98-magerun.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}

    runHook postInstall
  '';

  meta = {
    broken = true; # Not compatible with PHP 8.1, see https://github.com/netz98/n98-magerun/issues/1275
    changelog = "https://magerun.net/category/magerun/";
    description = "The swiss army knife for Magento1/OpenMage developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
