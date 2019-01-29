{ stdenv, fetchurl, makeWrapper, php }:

stdenv.mkDerivation rec {
  name = "matomo-${version}";
  version = "3.7.0";

  src = fetchurl {
    # TODO: As soon as the tarballs are renamed as well on future releases, this should be enabled again
    # url = "https://builds.matomo.org/${name}.tar.gz";
    url = "https://builds.matomo.org/piwik-${version}.tar.gz";
    sha256 = "17ihsmwdfrx1c1v8cp5pc3swx3h0i0l9pjrc8jyww08kavfbfly6";
  };

  nativeBuildInputs = [ makeWrapper ];

  # make-localhost-default-database-server.patch:
  #   This changes the default value of the database server field
  #   from 127.0.0.1 to localhost.
  #   unix socket authentication only works with localhost,
  #   but password-based SQL authentication works with both.
  # TODO: is upstream interested in this?
  # -> discussion at https://github.com/matomo-org/matomo/issues/12646
  patches = [ ./make-localhost-default-database-host.patch ];

  # this bootstrap.php adds support for getting PIWIK_USER_PATH
  # from an environment variable. Point it to a mutable location
  # to be able to use matomo read-only from the nix store
  postPatch = ''
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
