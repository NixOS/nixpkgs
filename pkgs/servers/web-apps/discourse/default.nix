{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, bundlerEnv
, defaultGemConfig
, v8
}:

let
  rubyEnv = bundlerEnv {
    name = "discourse-env";

    # XXX: Gemfile.lock needs to be patched with due to bundix expecting bundler 1.x
    # https://github.com/NixOS/nixpkgs/issues/68089
    # perl -i -p0e 's/BUNDLED WITH.*2.*$/BUNDLED WITH\n   1.17.2/s' $out/Gemfile.lock

    # afterwards generate gemset.nix from repo checkout using
    # $ nix-shell -p bundix
    # $ bundix

    gemdir  = ./rubyEnv;
    gemset   = ./rubyEnv/gemset.nix;

    # Bundler groups available in this environment
    groups = ["assets" "default" "development" "test"];

    gemConfig = defaultGemConfig // {
      mini_racer = attrs: {
        buildInputs = [ v8 ];
        dontBuild = false;
        # force v8 check to use C++
        postPatch = ''
          substituteInPlace ext/mini_racer_extension/extconf.rb \
            --replace "Libv8.configure_makefile" \
                      "with_cflags(\"-x c++\") do Libv8.configure_makefile end"
        '';
      };
    };
  };

in stdenv.mkDerivation rec {
  pname = "discourse";
  version = "2.4.1";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse";
    rev = "v${version}";
    sha256 = "1nfvfrlbimfhi2dfsk4y6pbv1rbxxwkbnazm9br5cfiikc54zv3b";
  };

  buildInputs = [
    rubyEnv
    rubyEnv.wrappedRuby
    rubyEnv.bundler
    makeWrapper
  ];

  postPatch = ''
    sed -i 's~CREATE EXTENSION IF NOT EXISTS hstore~~'  db/migrate/20120924182000_add_hstore_extension.rb
    sed -i 's~CREATE EXTENSION IF NOT EXISTS hstore~~'  db/migrate/20120921162512_add_meta_data_to_forum_threads.rb
    sed -i 's~CREATE EXTENSION IF NOT EXISTS pg_trgm~~' db/migrate/20130315180637_enable_trigram_support.rb
  '';

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -r . $out/share/discourse
  '';

  passthru = {
    inherit rubyEnv;
  };

  meta = with lib; {
    homepage = "https://www.discourse.org/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ sorki ];
    license = licenses.gpl2;
    description = "A platform for community discussion";
    longDescription = "Discourse is the 100% open source discussion platform built for the next decade of the Internet.";
  };
}
