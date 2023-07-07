{ lib
, stdenv
, fetchFromGitHub
, writeText
, nixosTests
, dokuwiki
}:

stdenv.mkDerivation rec {
  pname = "dokuwiki";
  version = "2023-04-04a";

  src = fetchFromGitHub {
    owner = "dokuwiki";
    repo = pname;
    rev = "release-${version}";
    sha256 = "sha256-PVfJfGYa2Drf4ljnnhb7kNpjfQlW4dDt5Xd5h+C8tP4=";
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
    runHook preInstall

    mkdir -p $out/share/dokuwiki
    cp -r * $out/share/dokuwiki
    cp ${preload} $out/share/dokuwiki/inc/preload.php
    cp ${phpLocalConfig} $out/share/dokuwiki/conf/local.php
    cp ${phpPluginsLocalConfig} $out/share/dokuwiki/conf/plugins.local.php

    runHook postInstall
  '';

  passthru = {
    combine = { basePackage ? dokuwiki
      , plugins ? []
      , templates ? []
      , localConfig ? null
      , pluginsConfig ? null
      , aclConfig ? null
      , pname ? (p: "${p.pname}-combined")
    }: let
      isNotEmpty = x: lib.optionalString (! builtins.elem x [ null "" ]);
    in basePackage.overrideAttrs (prev: {
      pname = if builtins.isFunction pname then pname prev else pname;

      postInstall = prev.postInstall or "" + ''
        ${lib.concatMapStringsSep "\n" (tpl: "cp -r ${toString tpl} $out/share/dokuwiki/lib/tpl/${tpl.name}") templates}
        ${lib.concatMapStringsSep "\n" (plugin: "cp -r ${toString plugin} $out/share/dokuwiki/lib/plugins/${plugin.name}") plugins}
        ${isNotEmpty localConfig "ln -sf ${localConfig} $out/share/dokuwiki/conf/local.php" }
        ${isNotEmpty pluginsConfig "ln -sf ${pluginsConfig} $out/share/dokuwiki/conf/plugins.local.php" }
        ${isNotEmpty aclConfig "ln -sf ${aclConfig} $out/share/dokuwiki/acl.auth.php" }
      '';
    });
    tests = {
      inherit (nixosTests) dokuwiki;
    };
  };

  meta = with lib; {
    description = "Simple to use and highly versatile Open Source wiki software that doesn't require a database";
    license = licenses.gpl2;
    homepage = "https://www.dokuwiki.org";
    platforms = platforms.all;
    maintainers = with maintainers; [ _1000101 ];
  };
}
