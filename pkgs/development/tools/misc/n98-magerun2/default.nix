{
  stdenv
, fetchurl
, makeBinaryWrapper
, php
, lib
, unzip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n98-magerun2";
  version = "7.1.0";

  src = fetchurl {
    url = "https://github.com/netz98/n98-magerun2/releases/download/${finalAttrs.version}/n98-magerun2.phar";
    hash = "sha256-DE5q1zoWZ4gJSs5JM5cr157oh5ufD1gaNt9X9vtuW/c=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/n98-magerun2

    install -D $src $out/libexec/n98-magerun2/n98-magerun2.phar
    makeWrapper ${php}/bin/php $out/bin/n98-magerun2 \
      --add-flags "$out/libexec/n98-magerun2/n98-magerun2.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}

    runHook postInstall
  '';

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "The swiss army knife for Magento2 developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
