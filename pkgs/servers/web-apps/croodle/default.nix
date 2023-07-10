{ lib
, fetchurl
, nixosTests
, stdenvNoCC
, writeText
, dataDir ? "/var/lib/croodle"
, debug ? false
}:

let
  configFile = writeText "croodle-config.php" ''
    <?php

    return array(
      /*
       * dataDir (String)
       * relative or absolute path to folder where polls are stored
       */
      'dataDir' => getenv('CROODLE__DATA_DIR') ?: '${dataDir}/',

      /*
       * debug (Boolean)
       * controls Slim debug mode
       */
      'debug' => getenv('CROODLE__DEBUG') ?: ${lib.boolToString debug}
    );
  '';

in

stdenvNoCC.mkDerivation rec {
  pname = "croodle";
  version = "0.6.2";

  src = fetchurl {
    url = "https://github.com/jelhan/${pname}/releases/download/v${version}/${pname}-v${version}.tar.gz";
    sha256 = "052kyp6qj6l42nbmdqjr657bzl1q97cklg5nhx7iz186xmf6p8ds";
  };

  sourceRoot = ".";

  postPatch = ''
    rm -rf data
  '';

  installPhase = ''
    runHook preInstall

    rm env-vars
    mkdir -p $out/share/croodle
    cp -r * $out/share/croodle
    cp ${configFile} $out/share/croodle/api/config.php

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) croodle;
  };

  meta = with lib; {
    description = "A web application to schedule a date or to do a poll on a general topics.";
    homepage = "https://github.com/jelhan/croodle";
    license = licenses.mit;
    maintainers = with maintainers; [ jboy ];
    platforms = platforms.all;
  };
}
