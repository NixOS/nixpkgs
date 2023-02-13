{ lib, stdenv, fetchFromGitHub, writeText, nixosTests }:

stdenv.mkDerivation rec {
  pname = "limesurvey";
  version = "3.27.33+220125";

  src = fetchFromGitHub {
    owner = "LimeSurvey";
    repo = "LimeSurvey";
    rev = version;
    sha256 = "sha256-iwTsn+glh8fwt1IaH9iDKDhEAnx1s1zvv1dmsdzUk8g=";
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
    knownVulnerabilities = [
      "CVE-2022-48008"
      "CVE-2022-48010"
    ];
  };
}
