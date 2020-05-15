{ stdenv, fetchFromGitHub, writeText }:

stdenv.mkDerivation rec {
  pname = "dokuwiki";
  version = "2018-04-22b";

  src = fetchFromGitHub {
    owner = "splitbrain";
    repo = "${pname}";
    rev = "release_stable_${version}";
    sha256 = "1na5pn4j4mi2la80ywzg1krwqdxz57mjkw0id6ga9rws809gkdjp";
  };

  preload = writeText "preload.php" ''
  <?php

    $config_cascade = array(
      'acl' => array(
        'default'   => getenv('DOKUWIKI_ACL_AUTH_CONFIG'),
      ),
      'plainauth.users' => array(
        'default'   => getenv('DOKUWIKI_USERS_AUTH_CONFIG'),
        'protected' => "" // not used by default
      ),
    );
  '';

  phpLocalConfig = writeText "local.php" ''
  <?php
    return require(getenv('DOKUWIKI_LOCAL_CONFIG'));
  ?>
  '';

  phpPluginsLocalConfig = writeText "plugins.local.php" ''
  <?php
    return require(getenv('DOKUWIKI_PLUGINS_LOCAL_CONFIG'));
  ?>
  '';

  installPhase = ''
    mkdir -p $out/share/dokuwiki
    cp -r * $out/share/dokuwiki
    cp ${preload} $out/share/dokuwiki/inc/preload.php
    cp ${phpLocalConfig} $out/share/dokuwiki/conf/local.php
    cp ${phpPluginsLocalConfig} $out/share/dokuwiki/conf/plugins.local.php
  '';

  meta = with stdenv.lib; {
    description = "Simple to use and highly versatile Open Source wiki software that doesn't require a database";
    license = licenses.gpl2;
    homepage = "https://www.dokuwiki.org";
    platforms = platforms.all;
    maintainers = [ maintainers."1000101" ];
  };
}
