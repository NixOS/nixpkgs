{ lib, stdenv, fetchFromGitHub, writeText, nixosTests }:

stdenv.mkDerivation rec {
  pname = "dokuwiki";
  version = "2022-07-31a";

  src = fetchFromGitHub {
    owner = "splitbrain";
    repo = pname;
    rev = "release_stable_${version}";
    sha256 = "sha256-gtWEtc3kbMokKycTx71XXblkDF39i926uN2kU3oOeVw=";
  };

  patches = [
    # Manually backported fix for a high severity vulnerability, allowing to inject
    # arbitrary HTML and thus cross site scripting via RSS feeds.
    # For reference see:
    # https://github.com/dokuwiki/dokuwiki/commit/53df38b0e4465894a67a5890f74a6f5f82e827de
    # https://huntr.dev/bounties/c6119106-1a5c-464c-94dd-ee7c5d0bece0/
    ./backport-rss-xss-fix.patch
  ];

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

  passthru.tests = {
    inherit (nixosTests) dokuwiki;
  };

  meta = with lib; {
    description = "Simple to use and highly versatile Open Source wiki software that doesn't require a database";
    license = licenses.gpl2;
    homepage = "https://www.dokuwiki.org";
    platforms = platforms.all;
    maintainers = with maintainers; [ _1000101 ];
  };
}
