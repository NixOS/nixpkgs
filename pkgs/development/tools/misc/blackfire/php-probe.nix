{ stdenv
, lib
, fetchurl
, dpkg
, autoPatchelfHook
, php
, writeShellScript
, curl
, jq
, common-updater-scripts
}:

let
  soFile = {
    "7.3" = "blackfire-20180731";
    "7.4" = "blackfire-20190902";
    "8.0" = "blackfire-20200930";
  }.${lib.versions.majorMinor php.version} or (throw "Unsupported PHP version.");
in stdenv.mkDerivation rec {
  pname = "php-blackfire";
  version = "1.69.0";

  src = fetchurl {
    url = "https://packages.blackfire.io/debian/pool/any/main/b/blackfire-php/blackfire-php_${version}_amd64.deb";
    sha256 = "5wE6yCl4N6PJiL2up9y/me/Sg2hZ4HnIKsbuhDzyFco=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb -x $src pkg
    sourceRoot=pkg

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -D usr/lib/blackfire-php/amd64/${soFile}${lib.optionalString php.ztsSupport "-zts"}.so $out/lib/php/extensions/blackfire.so

    runHook postInstall
  '';

  passthru = {
    updateScript = writeShellScript "update-${pname}" ''
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      update-source-version "$UPDATE_NIX_ATTR_PATH" "$(curl https://blackfire.io/api/v1/releases | jq .probe.php --raw-output)"
    '';
  };

  meta = with lib; {
    description = "Blackfire Profiler PHP module";
    homepage = "https://blackfire.io/";
    license = licenses.unfree;
    maintainers = with maintainers; [ jtojnar ];
    platforms = [ "x86_64-linux" ];
  };
}
