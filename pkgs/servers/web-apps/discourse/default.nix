{ stdenv, makeWrapper, runCommandNoCC, lib, nixosTests, writeShellScript
, fetchFromGitHub, bundlerEnv, ruby, replace, gzip, gnutar, git, cacert
, util-linux, gawk, imagemagick, optipng, pngquant, libjpeg, jpegoptim
, gifsicle, libpsl, redis, postgresql, which, brotli, procps, rsync
, nodePackages, v8
}:

let
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse";
    rev = "v${version}";
    sha256 = "sha256-w26pwGDL2j7qbporUzZATgw7E//E6xwahCbXv35QNnc=";
  };

  runtimeDeps = [
    # For backups, themes and assets
    rubyEnv.wrappedRuby
    rsync
    gzip
    gnutar
    git
    brotli

    # Misc required system utils
    which
    procps       # For ps and kill
    util-linux   # For renice
    gawk

    # Image optimization
    imagemagick
    optipng
    pngquant
    libjpeg
    jpegoptim
    gifsicle
    nodePackages.svgo
  ];

  runtimeEnv = {
    HOME = "/run/discourse/home";
    RAILS_ENV = "production";
    UNICORN_LISTENER = "/run/discourse/sockets/unicorn.sock";
  };

  rake = runCommandNoCC "discourse-rake" {
    nativeBuildInputs = [ makeWrapper ];
  } ''
    mkdir -p $out/bin
    makeWrapper ${rubyEnv}/bin/rake $out/bin/discourse-rake \
        ${lib.concatStrings (lib.mapAttrsToList (name: value: "--set ${name} '${value}' ") runtimeEnv)} \
        --prefix PATH : ${lib.makeBinPath runtimeDeps} \
        --set RAKEOPT '-f ${discourse}/share/discourse/Rakefile' \
        --run 'cd ${discourse}/share/discourse'
  '';

  rubyEnv = bundlerEnv {
    name = "discourse-ruby-env-${version}";
    inherit version ruby;
    gemdir = ./rubyEnv;
    gemset =
      let
        gems = import ./rubyEnv/gemset.nix;
      in
        gems // {
          libv8-node =
            let
              noopScript = writeShellScript "noop" "exit 0";
              linkFiles = writeShellScript "link-files" ''
                cd ../..

                mkdir -p vendor/v8/out.gn/libv8/obj/
                ln -s "${v8}/lib/libv8.a" vendor/v8/out.gn/libv8/obj/libv8_monolith.a

                ln -s ${v8}/include vendor/v8/include

                mkdir -p ext/libv8-node
                echo '--- !ruby/object:Libv8::Node::Location::Vendor {}' >ext/libv8-node/.location.yml
              '';
            in gems.libv8-node // {
              dontBuild = false;
              postPatch = ''
                cp ${noopScript} libexec/build-libv8
                cp ${noopScript} libexec/build-monolith
                cp ${noopScript} libexec/download-node
                cp ${noopScript} libexec/extract-node
                cp ${linkFiles} libexec/inject-libv8
              '';
            };
          mini_suffix = gems.mini_suffix // {
            propagatedBuildInputs = [ libpsl ];
            dontBuild = false;
            # Use our libpsl instead of the vendored one, which isn't
            # available for aarch64. It has to be called
            # libpsl.x86_64.so or it isn't found.
            postPatch = ''
              cp $(readlink -f ${libpsl}/lib/libpsl.so) vendor/libpsl.x86_64.so
            '';
          };
        };

    groups = [
      "default" "assets" "development" "test"
    ];
  };

  assets = stdenv.mkDerivation {
    pname = "discourse-assets";
    inherit version src;

    nativeBuildInputs = [
      rubyEnv.wrappedRuby
      postgresql
      redis
      which
      brotli
      procps
      nodePackages.uglify-js
    ];

    # We have to set up an environment that is close enough to
    # production ready or the assets:precompile task refuses to
    # run. This means that Redis and PostgreSQL has to be running and
    # database migrations performed.
    preBuild = ''
      export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

      redis-server >/dev/null &

      initdb -A trust $NIX_BUILD_TOP/postgres >/dev/null
      postgres -D $NIX_BUILD_TOP/postgres -k $NIX_BUILD_TOP >/dev/null &
      export PGHOST=$NIX_BUILD_TOP

      echo "Waiting for Redis and PostgreSQL to be ready.."
      while ! redis-cli --scan >/dev/null || ! psql -l >/dev/null; do
        sleep 0.1
      done

      psql -d postgres -tAc 'CREATE USER "discourse"'
      psql -d postgres -tAc 'CREATE DATABASE "discourse" OWNER "discourse"'
      psql 'discourse' -tAc "CREATE EXTENSION IF NOT EXISTS pg_trgm"
      psql 'discourse' -tAc "CREATE EXTENSION IF NOT EXISTS hstore"

      # Create a temporary home dir to stop bundler from complaining
      mkdir $NIX_BUILD_TOP/tmp_home
      export HOME=$NIX_BUILD_TOP/tmp_home

      export RAILS_ENV=production

      bundle exec rake db:migrate >/dev/null
      rm -r tmp/*
    '';

    buildPhase = ''
      runHook preBuild

      bundle exec rake assets:precompile

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mv public/assets $out

      runHook postInstall
    '';
  };

  discourse = stdenv.mkDerivation {
    pname = "discourse";
    inherit version src;

    buildInputs = [
      rubyEnv rubyEnv.wrappedRuby rubyEnv.bundler
    ];

    patches = [
      # Load a separate NixOS site settings file
      ./nixos_defaults.patch

      # Add a noninteractive admin creation task
      ./admin_create.patch

      # Disable jhead, which is currently marked as vulnerable
      ./disable_jhead.patch

      # Add the path to the CA cert bundle to make TLS work
      ./action_mailer_ca_cert.patch

      # Log Unicorn messages to the journal and make request timeout
      # configurable
      ./unicorn_logging_and_timeout.patch
    ];

    postPatch = ''
      # Always require lib-files and application.rb through their store
      # path, not their relative state directory path. This gets rid of
      # warnings and means we don't have to link back to lib from the
      # state directory.
      find config -type f -execdir sed -Ei "s,(\.\./)+(lib|app)/,$out/share/discourse/\2/," {} \;

      ${replace}/bin/replace-literal -f -r -e 'File.rename(temp_destination, destination)' "FileUtils.mv(temp_destination, destination)" .
    '';

    buildPhase = ''
      runHook preBuild

      mv config config.dist
      mv public public.dist
      mv plugins plugins.dist

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      cp -r . $out/share/discourse
      rm -r $out/share/discourse/log
      ln -sf /var/log/discourse $out/share/discourse/log
      ln -sf /run/discourse/tmp $out/share/discourse/tmp
      ln -sf /run/discourse/config $out/share/discourse/config
      ln -sf /run/discourse/assets/javascripts/plugins $out/share/discourse/app/assets/javascripts/plugins
      ln -sf /run/discourse/public $out/share/discourse/public
      ln -sf /run/discourse/plugins $out/share/discourse/plugins
      ln -sf ${assets} $out/share/discourse/public.dist/assets

      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://www.discourse.org/";
      platforms = platforms.linux;
      maintainers = with maintainers; [ talyz ];
      license = licenses.gpl2Plus;
      description = "Discourse is an open source discussion platform";
    };

    passthru = {
      inherit rubyEnv runtimeEnv runtimeDeps rake;
      ruby = rubyEnv.wrappedRuby;
      tests = nixosTests.discourse;
    };
  };
in discourse
