{ stdenv, fetchFromGitHub, writeText, nixosTests }:

stdenv.mkDerivation rec {
  pname = "limesurvey";
  version = "3.23.7+201006";

  src = fetchFromGitHub {
    owner = "LimeSurvey";
    repo = "LimeSurvey";
    rev = version;
    sha256 = "19p978p0flknsg3iqlrrbr76qsk5ha2a84nxywqsvjrjvqrh5jrc";
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

  meta = with stdenv.lib; {
    description = "Open source survey application";
    license = licenses.gpl2;
    homepage = "https://www.limesurvey.org";
    maintainers = with maintainers; [offline];
    platforms = with platforms; unix;
  };
}
