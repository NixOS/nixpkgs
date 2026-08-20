{
  stdenv,
  pkgs,
  makeWrapper,
  runCommand,
  lib,
  writeShellScript,
  fetchFromGitHub,
  bundlerEnv,
  callPackage,
  nixosTests,

  defaultGemConfig,
  ruby_3_4,
  fetchzip,
  gzip,
  gnutar,
  git,
  cacert,
  util-linux,
  gawk,
  net-tools,
  imagemagick,
  optipng,
  pngquant,
  libjpeg,
  jpegoptim,
  gifsicle,
  jhead,
  oxipng,
  libpsl,
  redis,
  postgresql,
  which,
  brotli,
  procps,
  rsync,
  icu,
  rustPlatform,
  buildRubyGem,
  rustc,
  cargo,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  svgo,
  nodejs-slim_22,
  jq,
  moreutils,
  terser,
  uglify-js,

  plugins ? [ ],
}:

let
  version = "2026.7.1";

  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse";
    rev = "v${version}";
    sha256 = "sha256-sGygaOCygtDVjg8uBGdDVaRouUKib8aAukaBAY8aQ9w=";
  };

  pnpm = pnpm_10;

  ruby = ruby_3_4;

  runtimeDeps = [
    # For backups, themes and assets
    rubyEnv.wrappedRuby
    rsync
    gzip
    gnutar
    git
    brotli
    nodejs-slim_22

    # Misc required system utils
    which
    procps # For ps and kill
    util-linux # For renice
    gawk
    net-tools # For hostname

    # Image optimization
    imagemagick
    optipng
    oxipng
    pngquant
    libjpeg
    jpegoptim
    gifsicle
    svgo
    jhead
  ];

  runtimeEnv = {
    HOME = "/run/discourse/home";
    RAILS_ENV = "production";
    UNICORN_LISTENER = "/run/discourse/sockets/unicorn.sock";
  };

  mkDiscoursePlugin =
    {
      name ? null,
      pname ? null,
      version ? null,
      meta ? null,
      bundlerEnvArgs ? { },
      preserveGemsDir ? false,
      src,
      ...
    }@args:
    let
      rubyEnv = bundlerEnv (
        bundlerEnvArgs
        // {
          inherit
            name
            pname
            version
            ruby
            ;
        }
      );
    in
    stdenv.mkDerivation (
      # Allow overriding the plugin name
      {
        pluginName = if name != null then name else "${pname}-${version}";
      }
      // removeAttrs args [ "bundlerEnvArgs" ]
      // {
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp -r * $out/
        ''
        + lib.optionalString (bundlerEnvArgs != { }) (
          if preserveGemsDir then
            ''
              cp -r ${rubyEnv}/lib/ruby/gems/* $out/gems/
            ''
          else
            ''
              if [[ -e $out/gems ]]; then
                echo "Warning: The repo contains a 'gems' directory which will be removed!"
                echo "         If you need to preserve it, set 'preserveGemsDir = true'."
                rm -r $out/gems
              fi
              ln -sf ${rubyEnv}/lib/ruby/gems $out/gems
            ''
            + ''
              runHook postInstall
            ''
        );
      }
    );

  rake =
    runCommand "discourse-rake"
      {
        nativeBuildInputs = [ makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        makeWrapper ${rubyEnv}/bin/rake $out/bin/discourse-rake \
            ${
              lib.concatStrings (lib.mapAttrsToList (name: value: "--set ${name} '${value}' ") runtimeEnv)
            } \
            --prefix PATH : ${lib.makeBinPath runtimeDeps} \
            --set RAKEOPT '-f ${discourse}/share/discourse/Rakefile' \
            --chdir '${discourse}/share/discourse'
      '';

  rubyEnv =
    let
      # these hashes are auto-updated by update.py
      dart-x64-hash = "sha256-2rnqNeEr8PFMuFa4IhutxxXui1dCw3XQVqCV5ZwsUR8=";
      dart-arm64-hash = "sha256-8sgc9IaeWSRnURFtMuSOqnKACkDc5WynmLIboYWwoSM=";
    in
    bundlerEnv rec {
      name = "discourse-ruby-env-${version}";
      inherit version ruby;
      gemdir = ./rubyEnv;
      gemset = import (gemdir + "/gemset.nix") src;
      passthru = {
        # these MUST be passthru'd for update.py to function correctly (to update dart-dart-x64-hash and dart-arm64-hash)
        inherit dart-x64-hash dart-arm64-hash gemset;
      };
      gemConfig = defaultGemConfig // {
        mini_racer = attrs: {
          buildInputs = [ icu ];
          dontBuild = false;
          NIX_LDFLAGS = "-licui18n";
        };
        libv8-node =
          attrs:
          let
            noopScript = writeShellScript "noop" "exit 0";
            linkFiles = writeShellScript "link-files" ''
              cd ../..

              mkdir -p vendor/v8/${stdenv.hostPlatform.system}/libv8/obj/
              ln -s "${nodejs-slim_22.libv8}/lib/libv8.a" vendor/v8/${stdenv.hostPlatform.system}/libv8/obj/libv8_monolith.a

              ln -s ${nodejs-slim_22.libv8}/include vendor/v8/include

              mkdir -p ext/libv8-node
              echo '--- !ruby/object:Libv8::Node::Location::Vendor {}' >ext/libv8-node/.location.yml
            '';
          in
          {
            dontBuild = false;
            postPatch = ''
              cp ${noopScript} libexec/build-libv8
              cp ${noopScript} libexec/build-monolith
              cp ${noopScript} libexec/download-node
              cp ${noopScript} libexec/extract-node
              cp ${linkFiles} libexec/inject-libv8
            '';
          };
        mini_suffix = attrs: {
          propagatedBuildInputs = [ libpsl ];
          dontBuild = false;
          # Use our libpsl instead of the vendored one, which isn't
          # available for aarch64. It has to be called
          # libpsl.x86_64.so or it isn't found.
          postPatch = ''
            cp $(readlink -f ${lib.getLib libpsl}/lib/libpsl.so) vendor/libpsl.x86_64.so
          '';
        };
        tokenizers = attrs: {
          cargoDeps = rustPlatform.fetchCargoVendor {
            inherit (buildRubyGem { inherit (attrs) gemName version source; })
              name
              src
              unpackPhase
              nativeBuildInputs
              ;
            hash = "sha256-BWOnHSgEkhK1yYcQIYMbGz8HyATuQ8tFk8QzoNiuML8=";
          };

          dontBuild = false;

          nativeBuildInputs = [
            cargo
            rustc
            rustPlatform.cargoSetupHook
            rustPlatform.bindgenHook
          ];

          disallowedReferences = [
            rustc.unwrapped
          ];

          preInstall = ''
            export CARGO_HOME="$PWD/../.cargo/"
          '';

          postInstall = ''
            find $out -type f -name .rustc_info.json -delete
          '';
        };
        tiktoken_ruby = attrs: {
          cargoDeps = rustPlatform.fetchCargoVendor {
            inherit (buildRubyGem { inherit (attrs) gemName version source; })
              name
              src
              unpackPhase
              nativeBuildInputs
              ;
            hash = "sha256-OIkSavAjja1atbeyPAKFXsXoYI3nUk9c5G3RFBj53Uk=";
          };

          dontBuild = false;

          nativeBuildInputs = [
            cargo
            rustc
            rustPlatform.cargoSetupHook
            rustPlatform.bindgenHook
          ];

          disallowedReferences = [
            rustc.unwrapped
          ];

          preInstall = ''
            export CARGO_HOME="$PWD/../.cargo/"
          '';

          postInstall = ''
            #ls $GEM_HOME/gems/${attrs.gemName}-${attrs.version}/lib
            #mv -v $GEM_HOME/gems/${attrs.gemName}-${attrs.version}/lib/{glfm_markdown/glfm_markdown.so,}
            find $out -type f -name .rustc_info.json -delete
          '';
        };
        sass-embedded = attrs: {
          # pre-download dart sass with the version matching sass-embedded. this is the same behavior as sass-embedded does internally
          # but packages don't get internet access during build so it can't do it itself
          env =
            let
              system-code =
                if stdenv.system == "x86_64-linux" then
                  "linux-x64"
                else if stdenv.system == "aarch64-linux" then
                  "linux-arm64"
                else
                  "unsupported-system-triple-download-will-fail";
              hash =
                if stdenv.system == "x86_64-linux" then
                  dart-x64-hash
                else if stdenv.system == "aarch64-linux" then
                  dart-arm64-hash
                else
                  "unsupported-system";
            in
            attrs.env or { }
            // {
              DART_SASS_VENDORED = fetchzip {
                inherit hash;
                url = "https://github.com/sass/dart-sass/releases/download/${attrs.version}/dart-sass-${attrs.version}-${system-code}.tar.gz";
              };
            };
          dontBuild = false;
          patches = [
            ./sass_embedded_vendored_dart_sass.patch
          ];
        };
      };

      groups = [
        "default"
        "assets"
        "development"
        "test"
      ];
    };

  assets = stdenv.mkDerivation {
    pname = "discourse-assets";
    inherit version src;

    pnpmDeps = fetchPnpmDeps {
      pname = "discourse-assets";
      inherit version src pnpm;
      fetcherVersion = 3;
      hash = "sha256-T0qcUYHqpjeGlyozcaiVI/Art0zh2PLyuMzbquhfe/o=";
    };

    nativeBuildInputs = runtimeDeps ++ [
      (postgresql.withPackages (ps: [
        ps.pgvector
      ]))
      redis
      uglify-js
      terser
      jq
      moreutils
      nodejs-slim_22
      pnpmConfigHook
      pnpm
    ];

    outputs = [
      "out"
      "node_modules"
      "generated"
      "frontend"
    ];

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

      # Because the required dependencies to execute the build at runtime don't exist, and
      # because we fail to copy tmp/ (the default directory where the asset processor is cached,
      # see notes in the discourse `installPhase`) we need to change the directory to something under
      # frontend/ which is moved over as expected.
      ./prebuild-asset-processor.patch

      # safe_exec.rb, which is used to execute ImageMagick among other things, restricts executable paths to standard FHS paths
      # which breaks on nix. this patch adds the entire /nix/store to allowed paths, which is sub-optimal but
      # still provides some benifits over disabling entirely.
      ./safe-exec-from-nix-store.patch
    ];

    env.RAILS_ENV = "production";
    env.DISCOURSE_DOWNLOAD_PRE_BUILT_ASSETS = "0";
    # Allow to use different bundler version than the lockfile has
    env.BUNDLER_VERSION = pkgs.bundler.version;

    # requires full git and repository, even a src `leaveDotGit` is not enough. So patch this function to return the version
    postPatch = ''
      substituteInPlace script/assemble_ember_build.rb --replace-fail "def core_tree_hash" "def core_tree_hash; return \"v${version}\""
    '';

    # We have to set up an environment that is close enough to
    # production ready or the assets:precompile task refuses to
    # run. This means that Redis and PostgreSQL has to be running and
    # database migrations performed.
    preBuild = ''
      # Patch before running postinstall hook script
      patchShebangs node_modules/
      patchShebangs --build frontend/
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
      psql 'discourse' -tAc "CREATE EXTENSION IF NOT EXISTS vector"

      ${lib.concatMapStringsSep "\n" (p: "ln -sf ${p} plugins/${p.pluginName or ""}") plugins}

      bundle exec rake db:migrate >/dev/null
      chmod -R +w tmp
    '';

    buildPhase = ''
      runHook preBuild

      patchShebangs script/
      patchShebangs bin/
      bundle exec rake assets:precompile

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mv public/assets $out

      mv node_modules $node_modules

      mv app/assets/generated $generated
      mv frontend $frontend

      runHook postInstall
    '';

    # The node_modules output by design has broken symlinks, as it refers to the source code.
    # They are resolved in the primary discourse derivation.
    dontCheckForBrokenSymlinks = true;
  };

  discourse = stdenv.mkDerivation {
    pname = "discourse";
    inherit version src;

    buildInputs = [
      rubyEnv
      rubyEnv.wrappedRuby
      rubyEnv.bundler
    ];

    patches = [
      # Load a separate NixOS site settings file
      ./nixos_defaults.patch

      # Add a noninteractive admin creation task
      ./admin_create.patch

      # Add the path to the CA cert bundle to make TLS work
      ./action_mailer_ca_cert.patch

      # Use the Ruby API version in the plugin gem path, to match the
      # one constructed by bundlerEnv
      ./plugin_gem_api_version.patch

      # Change the path to the auto generated plugin assets, which
      # defaults to the plugin's directory and isn't writable at the
      # time of asset generation
      ./auto_generated_path.patch

      # Make sure the notification email setting applies
      ./notification_email.patch

      # Because the required dependencies to execute the build at runtime don't exist, and
      # because we fail to copy tmp/ (the default directory where the asset processor is cached,
      # see notes in the discourse `installPhase`) we need to change the directory to something under
      # frontend/ which is moved over as expected.
      ./prebuild-asset-processor.patch

      # safe_exec.rb, which is used to execute ImageMagick among other things, restricts executable paths to standard FHS paths
      # which breaks on nix. this patch adds the entire /nix/store to allowed paths, which is sub-optimal but
      # still provides some benifits over disabling entirely.
      ./safe-exec-from-nix-store.patch

      # Our app/assets/generated folder is a symlink, but the ruby File.mkdir_p doesn't allow
      # a symlink in the way to the last directory. This patch explicitly resolves the symlink.
      ./resolve_generated_assets_symlink.patch
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
      # we don't copy `tmp` from ${assets}, which means that any pre-cached content will be re-generated later
      # however, we also can't copy `tmp` because then it would not be writeable by discourse, which it must be
      # and we can't write to /var/lib/discourse/tmp, because you can't do that in a build. this sucks.
      ln -sf /var/lib/discourse/tmp $out/share/discourse/tmp
      ln -sf /run/discourse/config $out/share/discourse/config
      ln -sf /run/discourse/public $out/share/discourse/public
      ln -sf /run/discourse/assets-generated $out/share/discourse/app/assets/generated
      ln -sf ${assets.node_modules} $out/share/discourse/node_modules
      ln -sf ${assets} $out/share/discourse/public.dist/assets
      # This needs to be copied because it contains symlinks to node_modules
      rm -r $out/share/discourse/frontend
      cp -r ${assets.frontend} $out/share/discourse/frontend
      ${lib.concatMapStringsSep "\n" (
        p: "ln -sf ${p} $out/share/discourse/plugins/${p.pluginName or ""}"
      ) plugins}

      runHook postInstall
    '';

    passthru = {
      inherit
        rubyEnv
        runtimeEnv
        runtimeDeps
        rake
        mkDiscoursePlugin
        assets
        ;
      inherit (pkgs)
        discourseAllPlugins
        ;
      enabledPlugins = plugins;
      plugins = callPackage ./plugins/all-plugins.nix { inherit mkDiscoursePlugin; };
      ruby = rubyEnv.wrappedRuby;
      tests = {
        inherit (nixosTests)
          discourse
          discourseAllPlugins
          ;
      };
    };
    meta = {
      homepage = "https://www.discourse.org/";
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [
        leona
        talyz
      ];
      license = lib.licenses.gpl2Plus;
      description = "Open source discussion platform";
    };
  };
in
discourse
