{ stdenv, fetchurl, makeWrapper, php }:

stdenv.mkDerivation rec {
  name = "matomo-${version}";
  version = "3.3.0";

  src = fetchurl {
    # TODO: As soon as the tarballs are renamed as well on future releases, this should be enabled again
    # url = "https://builds.matomo.org/${name}.tar.gz";
    url = "https://builds.matomo.org/piwik-${version}.tar.gz";
    sha256 = "1ybzj3kk0x29nv8c6xnhir5d9dr0q0fl1vnm4i7zvhml73ryqk0f";
  };

  nativeBuildInputs = [ makeWrapper ];

  # regarding the 127.0.0.1 substitute:
  #   This replaces the default value of the database server field.
  #   unix socket authentication only works with localhost,
  #   but password-based SQL authentication works with both.
  postPatch = ''
    substituteInPlace plugins/Installation/FormDatabaseSetup.php \
      --replace "=> '127.0.0.1'," "=> 'localhost',"
    cp ${./bootstrap.php} bootstrap.php
  '';

  # TODO: future versions might rename the PIWIK_… variables to MATOMO_…
  # TODO: Move more unnecessary files from share/, especially using PIWIK_INCLUDE_PATH.
  #       See https://forum.matomo.org/t/bootstrap-php/5926/10 and
  #       https://github.com/matomo-org/matomo/issues/11654#issuecomment-297730843
  installPhase = ''
    runHook preInstall

    # copy evertything to share/, used as webroot folder, and then remove what's known to be not needed
    mkdir -p $out/share
    cp -ra * $out/share/
    # tmp/ is created by matomo in PIWIK_USER_PATH
    rmdir $out/share/tmp
    # config/ needs to be copied to PIWIK_USER_PATH anyway
    mv $out/share/config $out/

    makeWrapper ${php}/bin/php $out/bin/matomo-console \
      --add-flags "$out/share/console"

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A real-time web analytics application";
    license = licenses.gpl3Plus;
    homepage = https://matomo.org/;
    platforms = platforms.all;
    maintainers = [ maintainers.florianjacob ];
  };
}
