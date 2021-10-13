{ lib
, stdenv
, fetchurl
, nixosTests
, wordpressPackages
, wpThemes ? [ wordpressPackages.themes.twentynineteen wordpressPackages.themes.twentytwenty wordpressPackages.themes.twentytwentyone ]
, wpPlugins ? [ wordpressPackages.plugins.akismet wordpressPackages.plugins.hello-dolly ]
}:

stdenv.mkDerivation rec {
  pname = "wordpress";
  version = "6.0.1";

  src = fetchurl {
    url = "https://wordpress.org/${pname}-${version}.tar.gz";
    sha256 = "sha256-9nhZaASqidfNySgIYpOEZOqyWurr/vqRrhdeFao+8FQ=";
  };

  installPhase = ''
    mkdir -p $out/share/wordpress
    cp -r . $out/share/wordpress
    rm -r $out/share/wordpress/wp-content/plugins/*
    rm -r $out/share/wordpress/wp-content/themes/*
    ${lib.concatMapStringsSep "\n" (theme: "cp -r ${theme} $out/share/wordpress/wp-content/themes/${theme.passthru.wpName or theme.pname}") wpThemes}
    ${lib.concatMapStringsSep "\n" (plugin: "cp -r ${plugin} $out/share/wordpress/wp-content/plugins/${plugin.passthru.wpName or plugin.pname}") wpPlugins}
  '';

  passthru.tests = {
    inherit (nixosTests) wordpress;
  };

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://wordpress.org";
    description = "WordPress is open source software you can use to create a beautiful website, blog, or app";
    license = [ licenses.gpl2 ];
    maintainers = with maintainers; [ basvandijk ];
    platforms = platforms.all;
  };
}
