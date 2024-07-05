{ stdenvNoCC
, lib
, fetchFromGitHub
, nixosTests
, php
, writeText
}:

stdenvNoCC.mkDerivation rec {
  pname = "FreshRSS";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "FreshRSS";
    repo = "FreshRSS";
    rev = version;
    hash = "sha256-AAOON1RdbG6JSnCc123jmIlIXHOE1PE49BV4hcASO/s=";
  };

  postPatch = ''
    patchShebangs cli/*.php app/actualize_script.php
  '';

  # the thirdparty_extension_path can only be set by config, but should be read by an env-var.
  overrideConfig = writeText "constants.local.php" ''
    <?php
      define('THIRDPARTY_EXTENSIONS_PATH', getenv('THIRDPARTY_EXTENSIONS_PATH') . '/extensions');
  '';

  buildInputs = [ php ];

  # There's nothing to build.
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -vr * $out/
    cp $overrideConfig $out/constants.local.php
    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) freshrss-sqlite freshrss-pgsql freshrss-http-auth freshrss-none-auth freshrss-extensions;
  };

  meta = with lib; {
    description = "FreshRSS is a free, self-hostable RSS aggregator";
    homepage = "https://www.freshrss.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ etu stunkymonkey ];
  };
}
