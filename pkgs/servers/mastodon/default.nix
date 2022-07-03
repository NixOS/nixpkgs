{ lib, stdenv, nodejs-slim, mkYarnPackage, fetchFromGitHub, bundlerEnv, nixosTests
, yarn, callPackage, imagemagick, ffmpeg, file, ruby_3_0, writeShellScript
, fetchYarnDeps, fixup_yarn_lock

  # Allow building a fork or custom version of Mastodon:
, pname ? "mastodon"
, version ? import ./version.nix
, srcOverride ? null
, dependenciesDir ? ./.  # Should contain gemset.nix, yarn.nix and package.json.
}:

stdenv.mkDerivation rec {
  inherit pname version;

  # Using overrideAttrs on src does not build the gems and modules with the overridden src.
  # Putting the callPackage up in the arguments list also does not work.
  src = if srcOverride != null then srcOverride else callPackage ./source.nix {};

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    sha256 = "sha256-2NSibx026ENAqphGGhNoLwUldWTEPbDBrYu3hgeRlnM=";
  };

  mastodon-gems = bundlerEnv {
    name = "${pname}-gems-${version}";
    inherit version;
    ruby = ruby_3_0;
    gemdir = src;
    gemset = dependenciesDir + "/gemset.nix";
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

  mastodon-modules = stdenv.mkDerivation {
    pname = "${pname}-modules";
    inherit src version;

    nativeBuildInputs = [ fixup_yarn_lock nodejs-slim yarn mastodon-gems mastodon-gems.wrappedRuby ];

    RAILS_ENV = "production";
    NODE_ENV = "production";

    buildPhase = ''
      export HOME=$PWD
      fixup_yarn_lock ~/yarn.lock
      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress

      patchShebangs ~/bin
      patchShebangs ~/node_modules

      # skip running yarn install
      rm -rf ~/bin/yarn

      OTP_SECRET=precompile_placeholder SECRET_KEY_BASE=precompile_placeholder \
        rails assets:precompile
      yarn cache clean --offline
      rm -rf ~/node_modules/.cache
    '';

    installPhase = ''
      mkdir -p $out/public
      cp -r node_modules $out/node_modules
      cp -r public/assets $out/public
      cp -r public/packs $out/public
    '';
  };

  propagatedBuildInputs = [ imagemagick ffmpeg file mastodon-gems.wrappedRuby ];
  buildInputs = [ mastodon-gems nodejs-slim ];

  buildPhase = ''
    ln -s ${mastodon-modules}/node_modules node_modules
    ln -s ${mastodon-modules}/public/assets public/assets
    ln -s ${mastodon-modules}/public/packs public/packs

    patchShebangs bin/
    for b in $(ls ${mastodon-gems}/bin/)
    do
      if [ ! -f bin/$b ]; then
        ln -s ${mastodon-gems}/bin/$b bin/$b
      fi
    done

    rm -rf log
    ln -s /var/log/mastodon log
    ln -s /tmp tmp
  '';

  installPhase = let
    run-streaming = writeShellScript "run-streaming.sh" ''
      # NixOS helper script to consistently use the same NodeJS version the package was built with.
      ${nodejs-slim}/bin/node ./streaming
    '';
  in ''
    mkdir -p $out
    cp -r * $out/
    ln -s ${run-streaming} $out/run-streaming.sh
  '';

  passthru = {
    tests.mastodon = nixosTests.mastodon;
    updateScript = callPackage ./update.nix {};
  };

  meta = with lib; {
    description = "Self-hosted, globally interconnected microblogging software based on ActivityPub";
    homepage = "https://joinmastodon.org";
    license = licenses.agpl3Plus;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ happy-river erictapen izorkin ];
  };
}
