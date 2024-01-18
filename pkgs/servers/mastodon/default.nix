{ lib, stdenv, nodejs-slim, bundlerEnv, nixosTests
, yarn, callPackage, ruby, writeShellScript
, fetchYarnDeps, prefetch-yarn-deps
, brotli

  # Allow building a fork or custom version of Mastodon:
, pname ? "mastodon"
, version ? srcOverride.version
, patches ? []
  # src is a package
, srcOverride ? callPackage ./source.nix { inherit patches; }
, gemset ? ./. + "/gemset.nix"
, yarnHash ? srcOverride.yarnHash
}:

stdenv.mkDerivation rec {
  inherit pname version;

  src = srcOverride;

  mastodonGems = bundlerEnv {
    name = "${pname}-gems-${version}";
    inherit version gemset ruby;
    gemdir = src;
    # This fix (copied from https://github.com/NixOS/nixpkgs/pull/76765) replaces the gem
    # symlinks with directories, resolving this error when running rake:
    #   /nix/store/451rhxkggw53h7253izpbq55nrhs7iv0-mastodon-gems-3.0.1/lib/ruby/gems/2.6.0/gems/bundler-1.17.3/lib/bundler/settings.rb:6:in `<module:Bundler>': uninitialized constant Bundler::Settings (NameError)
    postBuild = ''
      for gem in "$out"/lib/ruby/gems/*/gems/*; do
        cp -a "$gem/" "$gem.new"
        rm "$gem"
        # needed on macOS, otherwise the mv yields permission denied
        chmod +w "$gem.new"
        mv "$gem.new" "$gem"
      done
    '';
  };

  mastodonModules = stdenv.mkDerivation {
    pname = "${pname}-modules";
    inherit src version;

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${src}/yarn.lock";
      hash = yarnHash;
    };

    nativeBuildInputs = [ prefetch-yarn-deps nodejs-slim yarn mastodonGems mastodonGems.wrappedRuby brotli ];

    RAILS_ENV = "production";
    NODE_ENV = "production";

    buildPhase = ''
      runHook preBuild

      export HOME=$PWD
      # This option is needed for openssl-3 compatibility
      # Otherwise we encounter this upstream issue: https://github.com/mastodon/mastodon/issues/17924
      export NODE_OPTIONS=--openssl-legacy-provider
      fixup-yarn-lock ~/yarn.lock
      yarn config --offline set yarn-offline-mirror $yarnOfflineCache
      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress

      patchShebangs ~/bin
      patchShebangs ~/node_modules

      # skip running yarn install
      rm -rf ~/bin/yarn

      OTP_SECRET=precompile_placeholder SECRET_KEY_BASE=precompile_placeholder \
        rails assets:precompile
      yarn cache clean --offline
      rm -rf ~/node_modules/.cache

      # Create missing static gzip and brotli files
      gzip --best --keep ~/public/assets/500.html
      gzip --best --keep ~/public/packs/report.html
      find ~/public/assets -maxdepth 1 -type f -name '.*.json' \
        -exec gzip --best --keep --force {} ';'
      brotli --best --keep ~/public/packs/report.html
      find ~/public/assets -type f -regextype posix-extended -iregex '.*\.(css|js|json|html)' \
        -exec brotli --best --keep {} ';'

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/public
      cp -r node_modules $out/node_modules
      cp -r public/assets $out/public
      cp -r public/packs $out/public

      runHook postInstall
    '';
  };

  propagatedBuildInputs = [ mastodonGems.wrappedRuby ];
  nativeBuildInputs = [ brotli ];
  buildInputs = [ mastodonGems nodejs-slim ];

  buildPhase = ''
    runHook preBuild

    ln -s $mastodonModules/node_modules node_modules
    ln -s $mastodonModules/public/assets public/assets
    ln -s $mastodonModules/public/packs public/packs

    patchShebangs bin/
    for b in $(ls $mastodonGems/bin/)
    do
      if [ ! -f bin/$b ]; then
        ln -s $mastodonGems/bin/$b bin/$b
      fi
    done

    # Remove execute permissions
    chmod 0444 public/emoji/*.svg

    # Create missing static gzip and brotli files
    find public -maxdepth 1 -type f -regextype posix-extended -iregex '.*\.(css|js|svg|txt|xml)' \
      -exec gzip --best --keep --force {} ';' \
      -exec brotli --best --keep {} ';'
    find public/emoji -type f -name '.*.svg' \
      -exec gzip --best --keep --force {} ';' \
      -exec brotli --best --keep {} ';'
    ln -s assets/500.html.gz public/500.html.gz
    ln -s assets/500.html.br public/500.html.br
    ln -s packs/sw.js.gz public/sw.js.gz
    ln -s packs/sw.js.br public/sw.js.br
    ln -s packs/sw.js.map.gz public/sw.js.map.gz
    ln -s packs/sw.js.map.br public/sw.js.map.br

    rm -rf log
    ln -s /var/log/mastodon log
    ln -s /tmp tmp

    runHook postBuild
  '';

  installPhase = let
    run-streaming = writeShellScript "run-streaming.sh" ''
      # NixOS helper script to consistently use the same NodeJS version the package was built with.
      ${nodejs-slim}/bin/node ./streaming
    '';
  in ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out/
    ln -s ${run-streaming} $out/run-streaming.sh

    runHook postInstall
  '';

  passthru = {
    tests.mastodon = nixosTests.mastodon;
    # run with: nix-shell ./maintainers/scripts/update.nix --argstr package mastodon
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Self-hosted, globally interconnected microblogging software based on ActivityPub";
    homepage = "https://joinmastodon.org";
    license = licenses.agpl3Plus;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ happy-river erictapen izorkin ghuntley ];
  };
}
