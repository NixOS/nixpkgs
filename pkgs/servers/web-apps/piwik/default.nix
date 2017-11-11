{ stdenv, fetchurl, makeWrapper, php }:

stdenv.mkDerivation rec {
  name = "piwik-${version}";
  version = "3.2.0";

  src = fetchurl {
    url = "https://builds.piwik.org/${name}.tar.gz";
    sha512 = "21hss97mms5vavfzw41v2p3qsxx0ar8xa3dnr4d2fw2mps8jg3s5ng9i725lqrbl96q7855fh9ymabjsi1zr4q9nif2yap0izaakxib";
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
