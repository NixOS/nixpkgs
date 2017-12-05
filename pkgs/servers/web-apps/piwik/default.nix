{ stdenv, fetchurl, makeWrapper, php }:

stdenv.mkDerivation rec {
  name = "piwik-${version}";
  version = "3.0.4";

  src = fetchurl {
    url = "https://builds.piwik.org/${name}.tar.gz";
    sha512 = "2i0vydr073ynv7wcn078zxhvywdv85c648hympkzicdd746g995878py9006m96iwkmk4q664wn3f8jnfqsl1jd9f26alz1nssizbn9";
  };

  nativeBuildInputs = [ makeWrapper ];

  # regarding the PIWIK_USER_PATH substitutes:
  #   looks like this is just a bug / confusion of the directories, and nobody has tested this.
  #   PR at https://github.com/piwik/piwik/pull/11661
  # regarding the 127.0.0.1 substitute:
  #   This replaces the default value of the database server field.
  #   unix socket authentication only works with localhost,
  #   but password-based SQL authentication works with both.
  postPatch = ''
    substituteInPlace core/AssetManager/UIAssetFetcher.php \
      --replace "return PIWIK_USER_PATH;" "return PIWIK_DOCUMENT_ROOT;"
    substituteInPlace core/AssetManager/UIAssetMerger/StylesheetUIAssetMerger.php \
      --replace "setImportDir(PIWIK_USER_PATH);" "setImportDir(PIWIK_DOCUMENT_ROOT);"
    substituteInPlace core/AssetManager/UIAssetMerger/StylesheetUIAssetMerger.php \
      --replace "\$absolutePath = PIWIK_USER_PATH" "\$absolutePath = PIWIK_DOCUMENT_ROOT"
    substituteInPlace plugins/Installation/FormDatabaseSetup.php \
      --replace "=> '127.0.0.1'," "=> 'localhost',"
    cp ${./bootstrap.php} bootstrap.php
  '';

  # TODO: Move more unnecessary files from share/, especially using PIWIK_INCLUDE_PATH.
  #       See https://forum.piwik.org/t/bootstrap-php/5926/10 and
  #       https://github.com/piwik/piwik/issues/11654#issuecomment-297730843
  installPhase = ''
    runHook preInstall

    # copy evertything to share/, used as webroot folder, and then remove what's known to be not needed
    mkdir -p $out/share
    cp -ra * $out/share/
    # tmp/ is created by piwik in PIWIK_USER_PATH
    rmdir $out/share/tmp
    # config/ needs to be copied to PIWIK_USER_PATH anyway
    mv $out/share/config $out/

    makeWrapper ${php}/bin/php $out/bin/piwik-console \
      --add-flags "$out/share/console"

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A real-time web analytics application";
    license = licenses.gpl3Plus;
    homepage = https://piwik.org/;
    platforms = platforms.all;
    maintainers = [ maintainers.florianjacob ];
  };
}
