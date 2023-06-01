{ lib, stdenv, fetchFromGitHub, writeText, nixosTests }:

stdenv.mkDerivation rec {
  pname = "limesurvey";
  version = "5.6.9+230306";

  src = fetchFromGitHub {
    owner = "LimeSurvey";
    repo = "LimeSurvey";
    rev = version;
    hash = "sha256-FBcpP9Zb4flr1AZlocRW8xx9UCXJAU9aaGXcWQE6iWc=";
  };

  phpConfig = writeText "config.php" ''
  <?php
    return require(getenv('LIMESURVEY_CONFIG'));
  ?>
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/limesurvey
    cp -r . $out/share/limesurvey
    cp ${phpConfig} $out/share/limesurvey/application/config/config.php

    runHook postInstall
  '';

  passthru.tests = {
    smoke-test = nixosTests.limesurvey;
  };

  meta = with lib; {
    description = "Open source survey application";
    license = licenses.gpl2;
    homepage = "https://www.limesurvey.org";
    maintainers = with maintainers; [offline];
    platforms = with platforms; unix;
    broken = true; # Not compatible with PHP 8.1
  };
}
