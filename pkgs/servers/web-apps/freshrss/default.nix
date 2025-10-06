{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nixosTests,
  php,
  writeText,
}:

stdenvNoCC.mkDerivation rec {
  pname = "FreshRSS";
  version = "1.27.1";

  src = fetchFromGitHub {
    owner = "FreshRSS";
    repo = "FreshRSS";
    rev = version;
    hash = "sha256-EpszwgYzobRA7LohtJJtgTefFAEmCXvcP3ilfsu+obo=";
  };

  postPatch = ''
    patchShebangs cli/*.php app/actualize_script.php
  '';

  # THIRDPARTY_EXTENSIONS_PATH can only be set by config, but should be read from an env-var.
  overrideConfig = writeText "constants.local.php" ''
    <?php
      $thirdpartyExtensionsPath = getenv('THIRDPARTY_EXTENSIONS_PATH');
      if (is_string($thirdpartyExtensionsPath) && $thirdpartyExtensionsPath !== "") {
        define('THIRDPARTY_EXTENSIONS_PATH', $thirdpartyExtensionsPath . '/extensions');
      }
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
    inherit (nixosTests) freshrss;
  };

  meta = with lib; {
    description = "FreshRSS is a free, self-hostable RSS aggregator";
    homepage = "https://www.freshrss.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      stunkymonkey
    ];
  };
}
