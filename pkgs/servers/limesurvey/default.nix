{ stdenv, lib, fetchFromGitHub, writeText, makeWrapper, php }:

stdenv.mkDerivation rec {
  name = "limesurvey-${version}";
  version = "2.05_plus_141210";

  src = fetchFromGitHub {
    owner = "LimeSurvey";
    repo = "LimeSurvey";
    rev = version;
    sha256 = "1b5yixrlrjm055ag07c7phk84mk1892v20nsss1y0xzvgn6s14gq";
  };

  buildInputs = [ makeWrapper ];

  phpConfig = writeText "config.php" ''
  <?php
    return require(getenv('LIMESURVEY_CONFIG'));
  ?>
  '';

  patchPhase = ''
    substituteInPlace application/core/LSYii_Application.php \
      --replace "'basePath" "//'basePath"
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/limesurvey}
    cp -R . $out/share/limesurvey
    cp ${phpConfig} $out/share/limesurvey/application/config/config.php
    makeWrapper ${php}/bin/php $out/bin/limesurvey-console \
      --add-flags "$out/share/limesurvey/application/commands/console.php"
  '';

  meta = with lib; {
    description = "Open source survey application";
    license = licenses.gpl2;
    homepage = https://www.limesurvey.org;
    maintainers = with maintainers; [offline];
    platforms = with platforms; unix;
  };
}
