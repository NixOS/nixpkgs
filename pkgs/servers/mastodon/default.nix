{ lib, stdenv, nodejs-slim, mkYarnPackage, fetchFromGitHub, fetchpatch, bundlerEnv
, yarn, callPackage, imagemagick, ffmpeg, file, ruby_3_0, writeShellScript

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

  patches = [
    (fetchpatch {
      name = "CVE-2022-0432.patch";
      url = "https://github.com/mastodon/mastodon/commit/4d6d4b43c6186a13e67b92eaf70fe1b70ea24a09.patch";
      sha256 = "sha256-C18X2ErBqP/dIEt8NrA7hdiqxUg5977clouuu7Lv4/E=";
    })
  ];

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

  mastodon-js-modules = mkYarnPackage {
    pname = "${pname}-modules";
    yarnNix = dependenciesDir + "/yarn.nix";
    packageJSON = dependenciesDir + "/package.json";
    inherit src version;
  };

  mastodon-assets = stdenv.mkDerivation {
    pname = "${pname}-assets";
    inherit src version;

    buildInputs = [
      mastodon-gems nodejs-slim yarn
    ];

    # FIXME: "production" would require OTP_SECRET to be set, so we use
    # development here.
    RAILS_ENV = "development";

    buildPhase = ''
      # Support Mastodon forks which don't call themselves 'mastodon' or which
      # omit the organization name from package.json.
      if [ "$(ls ${mastodon-js-modules}/libexec/* | grep node_modules)" ]; then
          cp -r ${mastodon-js-modules}/libexec/*/node_modules node_modules
      else
          cp -r ${mastodon-js-modules}/libexec/*/*/node_modules node_modules
      fi
      chmod -R u+w node_modules
      rake webpacker:compile
      rails assets:precompile
    '';

    installPhase = ''
      mkdir -p $out/public
      cp -r public/assets $out/public
      cp -r public/packs $out/public
    '';
  };

  passthru.updateScript = callPackage ./update.nix {};

  buildPhase = ''
    if [ "$(ls ${mastodon-js-modules}/libexec/* | grep node_modules)" ]; then
        ln -s ${mastodon-js-modules}/libexec/*/node_modules node_modules
    else
        ln -s ${mastodon-js-modules}/libexec/*/*/node_modules node_modules
    fi
    ln -s ${mastodon-assets}/public/assets public/assets
    ln -s ${mastodon-assets}/public/packs public/packs

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

  propagatedBuildInputs = [ imagemagick ffmpeg file mastodon-gems.wrappedRuby ];

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

  meta = with lib; {
    description = "Self-hosted, globally interconnected microblogging software based on ActivityPub";
    homepage = "https://joinmastodon.org";
    license = licenses.agpl3Plus;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ petabyteboy happy-river erictapen ];
  };
}
