{ stdenv, fetchFromGitHub, writeText }:

stdenv.mkDerivation rec {
  pname = "limesurvey";
  version = "3.17.1+190408";

  src = fetchFromGitHub {
    owner = "LimeSurvey";
    repo = "LimeSurvey";
    rev = version;
    sha256 = "0d6dgw9af492vn5yg2hq82ipq4p80c19lhky0dpwrm5kv67kxbhv";
  };

  phpConfig = writeText "config.php" ''
  <?php
    return require(getenv('LIMESURVEY_CONFIG'));
  ?>
  '';

  installPhase = ''
    mkdir -p $out/share/limesurvey
    cp -r . $out/share/limesurvey
    cp ${phpConfig} $out/share/limesurvey/application/config/config.php
  '';

  meta = with stdenv.lib; {
    description = "Open source survey application";
    license = licenses.gpl2;
    homepage = "https://www.limesurvey.org";
    maintainers = with maintainers; [offline];
    platforms = with platforms; unix;
  };
}
