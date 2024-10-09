{ stdenv
, pkgs
, makeWrapper
, runCommand
, lib
, writeShellScript
, fetchFromGitHub
, bundlerEnv
, callPackage

, ruby_3_2
, replace
, gzip
, gnutar
, git
, cacert
, util-linux
, gawk
, nettools
, imagemagick
, optipng
, pngquant
, libjpeg
, jpegoptim
, gifsicle
, jhead
, oxipng
, libpsl
, redis
, postgresql
, which
, brotli
, procps
, rsync
, icu
, fetchYarnDeps
, yarn
, fixup-yarn-lock
, nodePackages
, nodejs_18
, jq
, moreutils
, terser
, uglify-js

, plugins ? []
}@args:

let
  version = "3.2.5";

  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse";
    rev = "v${version}";
    sha256 = "sha256-+at4IiJ0yRPq9XyvAwa2Kuc0wYQOB5hw7E1jmQAAkc4=";
  };

  ruby = ruby_3_2;

  runtimeDeps = [
    # For backups, themes and assets
    rubyEnv.wrappedRuby
    rsync
    gzip
    gnutar
    git
    brotli
    nodejs_18

    # Misc required system utils
    which
    procps       # For ps and kill
    util-linux   # For renice
    gawk
    nettools     # For hostname

    # Image optimization
    imagemagick
    optipng
    oxipng
    pngquant
    libjpeg
    jpegoptim
    gifsicle
    nodePackages.svgo
    jhead
  ];

  runtimeEnv = {
    HOME = "/run/discourse/home";
    RAILS_ENV = "production";
    UNICORN_LISTENER = "/run/discourse/sockets/unicorn.sock";
  };

  mkDiscoursePlugin =
    { name ? null
    , pname ? null
    , version ? null
    , meta ? null
    , bundlerEnvArgs ? {}
    , preserveGemsDir ? false
    , src
    , ...
    }@args:
    let
      rubyEnv = bundlerEnv (bundlerEnvArgs // {
        inherit name pname version ruby;
      });
    in
      stdenv.mkDerivation (builtins.removeAttrs args [ "bundlerEnvArgs" ] // {
        pluginName = if name != null then name else "${pname}-${version}";
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp -r * $out/
        '' + lib.optionalString (bundlerEnvArgs != {}) (
          if preserveGemsDir then ''
            cp -r ${rubyEnv}/lib/ruby/gems/* $out/gems/
          ''
          else ''
            if [[ -e $out/gems ]]; then
              echo "Warning: The repo contains a 'gems' directory which will be removed!"
              echo "         If you need to preserve it, set 'preserveGemsDir = true'."
              rm -r $out/gems
            fi
            ln -sf ${rubyEnv}/lib/ruby/gems $out/gems
          '' + ''
          runHook postInstall
        '');
      });

  rake = runCommand "discourse-rake" {
    nativeBuildInputs = [ makeWrapper ];
  } ''
    mkdir -p $out/bin
    makeWrapper ${rubyEnv}/bin/rake $out/bin/discourse-rake \
        ${lib.concatStrings (lib.mapAttrsToList (name: value: "--set ${name} '${value}' ") runtimeEnv)} \
        --prefix PATH : ${lib.makeBinPath runtimeDeps} \
        --set RAKEOPT '-f ${discourse}/share/discourse/Rakefile' \
        --chdir '${discourse}/share/discourse'
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
          mini_racer = gems.mini_racer // {
            buildInputs = [ icu ];
            dontBuild = false;
            NIX_LDFLAGS = "-licui18n";
          };
          libv8-node =
            let
              noopScript = writeShellScript "noop" "exit 0";
              linkFiles = writeShellScript "link-files" ''
                cd ../..

                mkdir -p vendor/v8/${stdenv.hostPlatform.system}/libv8/obj/
                ln -s "${nodejs_18.libv8}/lib/libv8.a" vendor/v8/${stdenv.hostPlatform.system}/libv8/obj/libv8_monolith.a

                ln -s ${nodejs_18.libv8}/include vendor/v8/include

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
              cp $(readlink -f ${lib.getLib libpsl}/lib/libpsl.so) vendor/libpsl.x86_64.so
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

    yarnDevOfflineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      hash = "sha256-0s8c2V8Wl3f5kL1OIn2ps6hL7CUQD5+LJm+9LYHc+W0=";
    };

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/app/assets/javascripts/yarn-ember5.lock";
      hash = "sha256-ZBXvNdHHV92kSAswe6KA+OqaY5smf7ZKTTOiY8g78D0=";
    };

    nativeBuildInputs = runtimeDeps ++ [
      postgresql
      redis
      uglify-js
      terser
      yarn
      jq
      moreutils
      fixup-yarn-lock
    ];

    outputs = [ "out" "javascripts" ];

    patches = [
      # Use the Ruby API version in the plugin gem path, to match the
      # one constructed by bundlerEnv
      ./plugin_gem_api_version.patch

      # Change the path to the auto generated plugin assets, which
      # defaults to the plugin's directory and isn't writable at the
      # time of asset generation
      ./auto_generated_path.patch

      # Fix the rake command used to recursively execute itself in the
      # assets precompilation task.
      ./assets_rake_command.patch

      # Little does he know, so he decided there is no need to generate the
      # theme-transpiler over and over again. Which at the same time allows the removal
      # of javascript devDependencies from the runtime environment.
      ./prebuild-theme-transpiler.patch
    ];

    env.RAILS_ENV = "production";

    # We have to set up an environment that is close enough to
    # production ready or the assets:precompile task refuses to
    # run. This means that Redis and PostgreSQL has to be running and
    # database migrations performed.
    preBuild = ''
      # Yarn wants a real home directory to write cache, config, etc to
      export HOME=$NIX_BUILD_TOP/fake_home

      yarn_install() {
        local offlineCache=$1 yarnLock=$2

        # Make yarn install packages from our offline cache, not the registry
        yarn config --offline set yarn-offline-mirror $offlineCache

        # Fixup "resolved"-entries in yarn.lock to match our offline cache
        fixup-yarn-lock $yarnLock

        # Install while ignoring hook scripts
        yarn --offline --ignore-scripts --cwd $(dirname $yarnLock) install
      }

      # Install devDependencies for generating the theme-transpiler executed as
      # dependent task assets:precompile:theme_transpiler before db:migrate
      yarn_install $yarnDevOfflineCache yarn.lock

      # Install the runtime dependencies
      yarn_install $yarnOfflineCache app/assets/javascripts/yarn-ember5.lock
      # Patch before running postinstall hook script
      patchShebangs --build app/assets/javascripts
      yarn --offline --cwd app/assets/javascripts run postinstall
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

      ${lib.concatMapStringsSep "\n" (p: "ln -sf ${p} plugins/${p.pluginName or ""}") plugins}

      bundle exec rake db:migrate >/dev/null
      chmod -R +w tmp
    '';

    buildPhase = ''
      runHook preBuild

      bundle exec rake assets:precompile

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mv public/assets $out

      rm -r app/assets/javascripts/plugins
      mv app/assets/javascripts $javascripts
      ln -sf /run/discourse/assets/javascripts/plugins $javascripts/plugins

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

      # Add the path to the CA cert bundle to make TLS work
      ./action_mailer_ca_cert.patch

      # Log Unicorn messages to the journal and make request timeout
      # configurable
      ./unicorn_logging_and_timeout.patch

      # Use the Ruby API version in the plugin gem path, to match the
      # one constructed by bundlerEnv
      ./plugin_gem_api_version.patch

      # Change the path to the auto generated plugin assets, which
      # defaults to the plugin's directory and isn't writable at the
      # time of asset generation
      ./auto_generated_path.patch

      # Make sure the notification email setting applies
      ./notification_email.patch

      # Little does he know, so he decided there is no need to generate the
      # theme-transpiler over and over again. Which at the same time allows the removal
      # of javascript devDependencies from the runtime environment.
      ./prebuild-theme-transpiler.patch
    ];

    postPatch = ''
      # Always require lib-files and application.rb through their store
      # path, not their relative state directory path. This gets rid of
      # warnings and means we don't have to link back to lib from the
      # state directory.
      find config -type f -name "*.rb" -execdir \
        sed -Ei "s,(\.\./)+(lib|app)/,$out/share/discourse/\2/," {} \;
      find config -maxdepth 1 -type f -name "*.rb" -execdir \
        sed -Ei "s,require_relative (\"|')([[:alnum:]].*)(\"|'),require_relative '$out/share/discourse/config/\2'," {} \;
    '';

    buildPhase = ''
      runHook preBuild

      mv config config.dist
      mv public public.dist

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      cp -r . $out/share/discourse
      rm -r $out/share/discourse/log
      ln -sf /var/log/discourse $out/share/discourse/log
      ln -sf /var/lib/discourse/tmp $out/share/discourse/tmp
      ln -sf /run/discourse/config $out/share/discourse/config
      ln -sf /run/discourse/public $out/share/discourse/public
      ln -sf ${assets} $out/share/discourse/public.dist/assets
      rm -r $out/share/discourse/app/assets/javascripts
      ln -sf ${assets.javascripts} $out/share/discourse/app/assets/javascripts
      ${lib.concatMapStringsSep "\n" (p: "ln -sf ${p} $out/share/discourse/plugins/${p.pluginName or ""}") plugins}

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
      inherit rubyEnv runtimeEnv runtimeDeps rake mkDiscoursePlugin assets;
      inherit (pkgs)
        discourseAllPlugins
      ;
      enabledPlugins = plugins;
      plugins = callPackage ./plugins/all-plugins.nix { inherit mkDiscoursePlugin; };
      ruby = rubyEnv.wrappedRuby;
      tests = import ../../../../nixos/tests/discourse.nix {
        inherit (stdenv) system;
        inherit pkgs;
        package = pkgs.discourse.override args;
      };
    };
  };
in discourse
