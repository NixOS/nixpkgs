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
<<<<<<< HEAD
  version = "1.28.0";
=======
  version = "1.27.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "FreshRSS";
    repo = "FreshRSS";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-//UiGxsdJQAc9qAn3P8/bCl8ka5LacfqkydU4b2/TtI=";
=======
    hash = "sha256-EpszwgYzobRA7LohtJJtgTefFAEmCXvcP3ilfsu+obo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "FreshRSS is a free, self-hostable RSS aggregator";
    homepage = "https://www.freshrss.org/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "FreshRSS is a free, self-hostable RSS aggregator";
    homepage = "https://www.freshrss.org/";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      stunkymonkey
    ];
  };
}
