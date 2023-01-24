{ lib, stdenv, fetchurl, bundlerEnv, ruby, makeWrapper, nixosTests }:

let
  version = "4.2.9";
  rubyEnv = bundlerEnv {
    name = "redmine-env-${version}";

    inherit ruby;
    gemdir = ./.;
    groups = [ "development" "ldap" "markdown" "minimagick" "openid" "test" ];
  };
in
  stdenv.mkDerivation rec {
    pname = "redmine";
    inherit version;

    src = fetchurl {
      url = "https://www.redmine.org/releases/${pname}-${version}.tar.gz";
      sha256 = "sha256-04dBNF9u/RDAeYmAk7JZ2NxNzY5B38T2RkloWueoyx4=";
    };

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler ];

    # taken from https://www.redmine.org/issues/33784
    # can be dropped when the upstream bug is closed and the fix is present in the upstream release
    patches = [ ./0001-python3.patch ];

    buildPhase = ''
      mv config config.dist
      mv public/themes public/themes.dist
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share
      cp -r . $out/share/redmine
      for i in config files log plugins public/plugin_assets public/themes tmp; do
        rm -rf $out/share/redmine/$i
        ln -fs /run/redmine/$i $out/share/redmine/$i
      done

      makeWrapper ${rubyEnv.wrappedRuby}/bin/ruby $out/bin/rdm-mailhandler.rb --add-flags $out/share/redmine/extra/mail_handler/rdm-mailhandler.rb
    '';

    passthru.tests.redmine = nixosTests.redmine;

    meta = with lib; {
      homepage = "https://www.redmine.org/";
      platforms = platforms.linux;
      maintainers = with maintainers; [ aanderse felixsinger ];
      license = licenses.gpl2;
    };
  }
