{ stdenv, fetchurl, makeWrapper, php }:

let
  versions = {
    matomo = {
      version = "3.13.0";
      sha256 = "0h4jqibb86zw5l26r927qrbjhba8c79pc4xp3hgpi25p3fjncax8";
    };

    matomo-beta = {
      version = "3.12.0";
      beta = 3;
      sha256 = "1n7b8cag7rpi6y4145cll2irz3in4668jkiicy06wm5nq6lb4bdf";
    };
  };
  common = pname: {version, sha256, beta ? null}:
    let fullVersion = version + stdenv.lib.optionalString (beta != null) "-b${toString beta}";
  name = "${pname}-${fullVersion}";
in

stdenv.mkDerivation rec {
  inherit name;
  version = fullVersion;

  src = fetchurl {
    url = "https://builds.matomo.org/matomo-${version}.tar.gz";
    inherit sha256;
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

    # copy everything to share/, used as webroot folder, and then remove what's known to be not needed
    mkdir -p $out/share
    cp -ra * $out/share/
    # tmp/ is created by matomo in PIWIK_USER_PATH
    rmdir $out/share/tmp
    # config/ needs to be accessed by PIWIK_USER_PATH anyway
    ln -s $out/share/config $out/

    makeWrapper ${php}/bin/php $out/bin/matomo-console \
      --add-flags "$out/share/console"

    runHook postInstall
  '';

  filesToFix = [
    "misc/composer/build-xhprof.sh"
    "misc/composer/clean-xhprof.sh"
    "misc/cron/archive.sh"
    "plugins/Installation/FormDatabaseSetup.php"
    "vendor/leafo/lessphp/package.sh"
    "vendor/pear/archive_tar/sync-php4"
    "vendor/szymach/c-pchart/coverage.sh"
    # drupal_test.sh does not exist in 3.12.0-b3; added for 3.13.0
    "vendor/twig/twig/drupal_test.sh"
  ];

  # This fixes the consistency check in the admin interface
  #
  # The filesToFix list may contain files that are exclusive to only one of the versions we build
  # make sure to test for existence to avoid erroring on an incompatible version and failing
  postFixup = ''
    pushd $out/share > /dev/null
    for f in $filesToFix; do
      if [ -f "$f" ]; then
        length="$(wc -c "$f" | cut -d' ' -f1)"
        hash="$(md5sum "$f" | cut -d' ' -f1)"
        sed -i "s:\\(\"$f\"[^(]*(\\).*:\\1\"$length\", \"$hash\"),:g" config/manifest.inc.php
      fi
    done
    popd > /dev/null
  '';

  meta = with stdenv.lib; {
    description = "A real-time web analytics application";
    license = licenses.gpl3Plus;
    homepage = https://matomo.org/;
    platforms = platforms.all;
    maintainers = with maintainers; [ florianjacob kiwi ];
  };
};
in stdenv.lib.mapAttrs common versions
