{
  lib,
  beamPackages,
  overrides ? (x: y: { }),
}:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages =
    with beamPackages;
    with self;
    {
      absinthe = buildMix rec {
        name = "absinthe";
        version = "1.9.0";

        src = fetchHex {
          pkg = "absinthe";
          version = "${version}";
          sha256 = "db65993420944ad90e932827663d4ab704262b007d4e3900cd69615f14ccc8ce";
        };

        beamDeps = [
          dataloader
          decimal
          nimble_parsec
          telemetry
        ];
      };

      absinthe_phoenix = buildMix rec {
        name = "absinthe_phoenix";
        version = "2.0.4";

        src = fetchHex {
          pkg = "absinthe_phoenix";
          version = "${version}";
          sha256 = "66617ee63b725256ca16264364148b10b19e2ecb177488cd6353584f2e6c1cf3";
        };

        beamDeps = [
          absinthe
          absinthe_plug
          decimal
          phoenix
          phoenix_html
          phoenix_pubsub
        ];
      };

      absinthe_plug = buildMix rec {
        name = "absinthe_plug";
        version = "1.5.9";

        src = fetchHex {
          pkg = "absinthe_plug";
          version = "${version}";
          sha256 = "dcdc84334b0e9e2cd439bd2653678a822623f212c71088edf0a4a7d03f1fa225";
        };

        beamDeps = [
          absinthe
          plug
        ];
      };

      argon2_elixir = buildMix rec {
        name = "argon2_elixir";
        version = "4.1.3";

        src = fetchHex {
          pkg = "argon2_elixir";
          version = "${version}";
          sha256 = "7c295b8d8e0eaf6f43641698f962526cdf87c6feb7d14bd21e599271b510608c";
        };

        beamDeps = [
          comeonin
          elixir_make
        ];
      };

      atomex = buildMix rec {
        name = "atomex";
        version = "0.5.1";

        src = fetchHex {
          pkg = "atomex";
          version = "${version}";
          sha256 = "6248891b5fcab8503982e090eedeeadb757a6311c2ef2e2998b874f7d319ab3f";
        };

        beamDeps = [ xml_builder ];
      };

      bandit = buildMix rec {
        name = "bandit";
        version = "1.10.1";

        src = fetchHex {
          pkg = "bandit";
          version = "${version}";
          sha256 = "4b4c35f273030e44268ace53bf3d5991dfc385c77374244e2f960876547671aa";
        };

        beamDeps = [
          hpax
          plug
          telemetry
          thousand_island
          websock
        ];
      };

      bunt = buildMix rec {
        name = "bunt";
        version = "1.0.0";

        src = fetchHex {
          pkg = "bunt";
          version = "${version}";
          sha256 = "dc5f86aa08a5f6fa6b8096f0735c4e76d54ae5c9fa2c143e5a1fc7c1cd9bb6b5";
        };

        beamDeps = [ ];
      };

      cachex = buildMix rec {
        name = "cachex";
        version = "3.6.0";

        src = fetchHex {
          pkg = "cachex";
          version = "${version}";
          sha256 = "ebf24e373883bc8e0c8d894a63bbe102ae13d918f790121f5cfe6e485cc8e2e2";
        };

        beamDeps = [
          eternal
          jumper
          sleeplocks
          unsafe
        ];
      };

      castore = buildMix rec {
        name = "castore";
        version = "1.0.17";

        src = fetchHex {
          pkg = "castore";
          version = "${version}";
          sha256 = "12d24b9d80b910dd3953e165636d68f147a31db945d2dcb9365e441f8b5351e5";
        };

        beamDeps = [ ];
      };

      certifi = buildRebar3 rec {
        name = "certifi";
        version = "2.15.0";

        src = fetchHex {
          pkg = "certifi";
          version = "${version}";
          sha256 = "b147ed22ce71d72eafdad94f055165c1c182f61a2ff49df28bcc71d1d5b94a60";
        };

        beamDeps = [ ];
      };

      cldr_utils = buildMix rec {
        name = "cldr_utils";
        version = "2.29.1";

        src = fetchHex {
          pkg = "cldr_utils";
          version = "${version}";
          sha256 = "3844a0a0ed7f42e6590ddd8bd37eb4b1556b112898f67dea3ba068c29aabd6c2";
        };

        beamDeps = [
          castore
          certifi
          decimal
        ];
      };

      codepagex = buildMix rec {
        name = "codepagex";
        version = "0.1.13";

        src = fetchHex {
          pkg = "codepagex";
          version = "${version}";
          sha256 = "c328170767e3ec04682193e7a07a8074c934a995a903d1836777c0ca5edf0d46";
        };

        beamDeps = [ ];
      };

      combine = buildMix rec {
        name = "combine";
        version = "0.10.0";

        src = fetchHex {
          pkg = "combine";
          version = "${version}";
          sha256 = "1b1dbc1790073076580d0d1d64e42eae2366583e7aecd455d1215b0d16f2451b";
        };

        beamDeps = [ ];
      };

      comeonin = buildMix rec {
        name = "comeonin";
        version = "5.5.1";

        src = fetchHex {
          pkg = "comeonin";
          version = "${version}";
          sha256 = "65aac8f19938145377cee73973f192c5645873dcf550a8a6b18187d17c13ccdb";
        };

        beamDeps = [ ];
      };

      cors_plug = buildMix rec {
        name = "cors_plug";
        version = "3.0.3";

        src = fetchHex {
          pkg = "cors_plug";
          version = "${version}";
          sha256 = "3f2d759e8c272ed3835fab2ef11b46bddab8c1ab9528167bd463b6452edf830d";
        };

        beamDeps = [ plug ];
      };

      credo = buildMix rec {
        name = "credo";
        version = "1.7.15";

        src = fetchHex {
          pkg = "credo";
          version = "${version}";
          sha256 = "291e8645ea3fea7481829f1e1eb0881b8395db212821338e577a90bf225c5607";
        };

        beamDeps = [
          bunt
          file_system
          jason
        ];
      };

      credo_code_climate = buildMix rec {
        name = "credo_code_climate";
        version = "0.1.0";

        src = fetchHex {
          pkg = "credo_code_climate";
          version = "${version}";
          sha256 = "75529fe38056f4e229821d604758282838b8397c82e2c12e409fda16b16821ca";
        };

        beamDeps = [
          credo
          jason
        ];
      };

      dataloader = buildMix rec {
        name = "dataloader";
        version = "2.0.2";

        src = fetchHex {
          pkg = "dataloader";
          version = "${version}";
          sha256 = "4c6cabc0b55e96e7de74d14bf37f4a5786f0ab69aa06764a1f39dda40079b098";
        };

        beamDeps = [
          ecto
          telemetry
        ];
      };

      db_connection = buildMix rec {
        name = "db_connection";
        version = "2.8.1";

        src = fetchHex {
          pkg = "db_connection";
          version = "${version}";
          sha256 = "a61a3d489b239d76f326e03b98794fb8e45168396c925ef25feb405ed09da8fd";
        };

        beamDeps = [ telemetry ];
      };

      decimal = buildMix rec {
        name = "decimal";
        version = "2.3.0";

        src = fetchHex {
          pkg = "decimal";
          version = "${version}";
          sha256 = "a4d66355cb29cb47c3cf30e71329e58361cfcb37c34235ef3bf1d7bf3773aeac";
        };

        beamDeps = [ ];
      };

      dialyxir = buildMix rec {
        name = "dialyxir";
        version = "1.4.7";

        src = fetchHex {
          pkg = "dialyxir";
          version = "${version}";
          sha256 = "b34527202e6eb8cee198efec110996c25c5898f43a4094df157f8d28f27d9efe";
        };

        beamDeps = [ erlex ];
      };

      digital_token = buildMix rec {
        name = "digital_token";
        version = "1.0.0";

        src = fetchHex {
          pkg = "digital_token";
          version = "${version}";
          sha256 = "8ed6f5a8c2fa7b07147b9963db506a1b4c7475d9afca6492136535b064c9e9e6";
        };

        beamDeps = [
          cldr_utils
          jason
        ];
      };

      doctor = buildMix rec {
        name = "doctor";
        version = "0.22.0";

        src = fetchHex {
          pkg = "doctor";
          version = "${version}";
          sha256 = "96e22cf8c0df2e9777dc55ebaa5798329b9028889c4023fed3305688d902cd5b";
        };

        beamDeps = [ decimal ];
      };

      earmark_parser = buildMix rec {
        name = "earmark_parser";
        version = "1.4.44";

        src = fetchHex {
          pkg = "earmark_parser";
          version = "${version}";
          sha256 = "4778ac752b4701a5599215f7030989c989ffdc4f6df457c5f36938cc2d2a2750";
        };

        beamDeps = [ ];
      };

      eblurhash = buildRebar3 rec {
        name = "eblurhash";
        version = "1.2.2";

        src = fetchHex {
          pkg = "eblurhash";
          version = "${version}";
          sha256 = "8c20ca00904de023a835a9dcb7b7762fed32264c85a80c3cafa85288e405044c";
        };

        beamDeps = [ ];
      };

      ecto = buildMix rec {
        name = "ecto";
        version = "3.13.5";

        src = fetchHex {
          pkg = "ecto";
          version = "${version}";
          sha256 = "df9efebf70cf94142739ba357499661ef5dbb559ef902b68ea1f3c1fabce36de";
        };

        beamDeps = [
          decimal
          jason
          telemetry
        ];
      };

      ecto_autoslug_field = buildMix rec {
        name = "ecto_autoslug_field";
        version = "3.1.0";

        src = fetchHex {
          pkg = "ecto_autoslug_field";
          version = "${version}";
          sha256 = "b6ddd614805263e24b5c169532c934440d0289181cce873061fca3a8e92fd9ff";
        };

        beamDeps = [
          ecto
          slugify
        ];
      };

      ecto_dev_logger = buildMix rec {
        name = "ecto_dev_logger";
        version = "0.15.0";

        src = fetchHex {
          pkg = "ecto_dev_logger";
          version = "${version}";
          sha256 = "b2c807d7d599a4fcf288139851c09262333b193bdb41f8d65f515853d117e88a";
        };

        beamDeps = [
          ecto
          geo
          jason
          postgrex
        ];
      };

      ecto_enum = buildMix rec {
        name = "ecto_enum";
        version = "1.4.0";

        src = fetchHex {
          pkg = "ecto_enum";
          version = "${version}";
          sha256 = "8fb55c087181c2b15eee406519dc22578fa60dd82c088be376d0010172764ee4";
        };

        beamDeps = [
          ecto
          ecto_sql
          postgrex
        ];
      };

      ecto_shortuuid = buildMix rec {
        name = "ecto_shortuuid";
        version = "0.4.0";

        src = fetchHex {
          pkg = "ecto_shortuuid";
          version = "${version}";
          sha256 = "1edb0e17f689c564039cb780b6a7409076f179ad236ad96413f00c7613db8bb3";
        };

        beamDeps = [
          ecto
          shortuuid
        ];
      };

      ecto_sql = buildMix rec {
        name = "ecto_sql";
        version = "3.13.4";

        src = fetchHex {
          pkg = "ecto_sql";
          version = "${version}";
          sha256 = "2b38cf0749ca4d1c5a8bcbff79bbe15446861ca12a61f9fba604486cb6b62a14";
        };

        beamDeps = [
          db_connection
          ecto
          postgrex
          telemetry
        ];
      };

      elixir_feed_parser = buildMix rec {
        name = "elixir_feed_parser";
        version = "2.1.0";

        src = fetchHex {
          pkg = "elixir_feed_parser";
          version = "${version}";
          sha256 = "2d3c62fe7b396ee3b73d7160bc8fadbd78bfe9597c98c7d79b3f1038d9cba28f";
        };

        beamDeps = [ timex ];
      };

      elixir_make = buildMix rec {
        name = "elixir_make";
        version = "0.9.0";

        src = fetchHex {
          pkg = "elixir_make";
          version = "${version}";
          sha256 = "db23d4fd8b757462ad02f8aa73431a426fe6671c80b200d9710caf3d1dd0ffdb";
        };

        beamDeps = [ ];
      };

      erlex = buildMix rec {
        name = "erlex";
        version = "0.2.8";

        src = fetchHex {
          pkg = "erlex";
          version = "${version}";
          sha256 = "9d66ff9fedf69e49dc3fd12831e12a8a37b76f8651dd21cd45fcf5561a8a7590";
        };

        beamDeps = [ ];
      };

      erlport = buildRebar3 rec {
        name = "erlport";
        version = "0.11.0";

        src = fetchHex {
          pkg = "erlport";
          version = "${version}";
          sha256 = "8eb136ccaf3948d329b8d1c3278ad2e17e2a7319801bc4cc2da6db278204eee4";
        };

        beamDeps = [ ];
      };

      eternal = buildMix rec {
        name = "eternal";
        version = "1.2.2";

        src = fetchHex {
          pkg = "eternal";
          version = "${version}";
          sha256 = "2c9fe32b9c3726703ba5e1d43a1d255a4f3f2d8f8f9bc19f094c7cb1a7a9e782";
        };

        beamDeps = [ ];
      };

      ex_cldr = buildMix rec {
        name = "ex_cldr";
        version = "2.44.1";

        src = fetchHex {
          pkg = "ex_cldr";
          version = "${version}";
          sha256 = "3880cd6137ea21c74250cd870d3330c4a9fdec07fabd5e37d1b239547929e29b";
        };

        beamDeps = [
          cldr_utils
          decimal
          gettext
          jason
          nimble_parsec
        ];
      };

      ex_cldr_calendars = buildMix rec {
        name = "ex_cldr_calendars";
        version = "2.4.1";

        src = fetchHex {
          pkg = "ex_cldr_calendars";
          version = "${version}";
          sha256 = "e29b2b186ce2832cc0da1574944cf206dd221da13b3da98c80da62d6ab71b343";
        };

        beamDeps = [
          ex_cldr_numbers
          ex_doc
          jason
        ];
      };

      ex_cldr_currencies = buildMix rec {
        name = "ex_cldr_currencies";
        version = "2.16.5";

        src = fetchHex {
          pkg = "ex_cldr_currencies";
          version = "${version}";
          sha256 = "4397179028f0a7389de278afd0239771f39ba8d1984ce072bc9b715fa28f30d3";
        };

        beamDeps = [
          ex_cldr
          jason
        ];
      };

      ex_cldr_dates_times = buildMix rec {
        name = "ex_cldr_dates_times";
        version = "2.25.2";

        src = fetchHex {
          pkg = "ex_cldr_dates_times";
          version = "${version}";
          sha256 = "3766037b28d0ba576a33ba432f2d5c4c437ed79ab18c343df543e34a23858d0a";
        };

        beamDeps = [
          ex_cldr_calendars
          jason
        ];
      };

      ex_cldr_languages = buildMix rec {
        name = "ex_cldr_languages";
        version = "0.3.3";

        src = fetchHex {
          pkg = "ex_cldr_languages";
          version = "${version}";
          sha256 = "22fb1fef72b7b4b4872d243b34e7b83734247a78ad87377986bf719089cc447a";
        };

        beamDeps = [
          ex_cldr
          jason
        ];
      };

      ex_cldr_numbers = buildMix rec {
        name = "ex_cldr_numbers";
        version = "2.37.0";

        src = fetchHex {
          pkg = "ex_cldr_numbers";
          version = "${version}";
          sha256 = "adc011aad34ab545e1d53ae248891479efcd25ba51f662822ec7c5083d0122f8";
        };

        beamDeps = [
          decimal
          digital_token
          ex_cldr
          ex_cldr_currencies
          jason
        ];
      };

      ex_cldr_plugs = buildMix rec {
        name = "ex_cldr_plugs";
        version = "1.3.4";

        src = fetchHex {
          pkg = "ex_cldr_plugs";
          version = "${version}";
          sha256 = "30829e097eac403013101dc087e6cabf5e01a1c5e3a6b23ea4562e85521ff52a";
        };

        beamDeps = [
          ex_cldr
          gettext
          jason
          plug
        ];
      };

      ex_doc = buildMix rec {
        name = "ex_doc";
        version = "0.39.3";

        src = fetchHex {
          pkg = "ex_doc";
          version = "${version}";
          sha256 = "0590955cf7ad3b625780ee1c1ea627c28a78948c6c0a9b0322bd976a079996e1";
        };

        beamDeps = [
          earmark_parser
          makeup_elixir
          makeup_erlang
        ];
      };

      ex_hash_ring = buildMix rec {
        name = "ex_hash_ring";
        version = "6.0.4";

        src = fetchHex {
          pkg = "ex_hash_ring";
          version = "${version}";
          sha256 = "89adabf31f7d3dfaa36802ce598ce918e9b5b33bae8909ac1a4d052e1e567d18";
        };

        beamDeps = [ ];
      };

      ex_ical = buildMix rec {
        name = "ex_ical";
        version = "0.2.0";

        src = fetchHex {
          pkg = "ex_ical";
          version = "${version}";
          sha256 = "db76473b2ae0259e6633c6c479a5a4d8603f09497f55c88f9ef4d53d2b75befb";
        };

        beamDeps = [ timex ];
      };

      ex_machina = buildMix rec {
        name = "ex_machina";
        version = "2.8.0";

        src = fetchHex {
          pkg = "ex_machina";
          version = "${version}";
          sha256 = "79fe1a9c64c0c1c1fab6c4fa5d871682cb90de5885320c187d117004627a7729";
        };

        beamDeps = [
          ecto
          ecto_sql
        ];
      };

      ex_optimizer = buildMix rec {
        name = "ex_optimizer";
        version = "0.1.1";

        src = fetchHex {
          pkg = "ex_optimizer";
          version = "${version}";
          sha256 = "e6f5c059bcd58b66be2f6f257fdc4f69b74b0fa5c9ddd669486af012e4b52286";
        };

        beamDeps = [ file_info ];
      };

      ex_unit_notifier = buildMix rec {
        name = "ex_unit_notifier";
        version = "1.3.1";

        src = fetchHex {
          pkg = "ex_unit_notifier";
          version = "${version}";
          sha256 = "87eb1cea911ed1753e1cc046cbf1c7f86af9058e30672a355f0699b41e5e119d";
        };

        beamDeps = [ ];
      };

      excoveralls = buildMix rec {
        name = "excoveralls";
        version = "0.18.5";

        src = fetchHex {
          pkg = "excoveralls";
          version = "${version}";
          sha256 = "523fe8a15603f86d64852aab2abe8ddbd78e68579c8525ae765facc5eae01562";
        };

        beamDeps = [
          castore
          jason
        ];
      };

      exgravatar = buildMix rec {
        name = "exgravatar";
        version = "2.0.3";

        src = fetchHex {
          pkg = "exgravatar";
          version = "${version}";
          sha256 = "aca18ff9bd8991d3be3e5446d3bdefc051be084c1ffc9ab2d43b3e65339300e1";
        };

        beamDeps = [ ];
      };

      expo = buildMix rec {
        name = "expo";
        version = "1.1.1";

        src = fetchHex {
          pkg = "expo";
          version = "${version}";
          sha256 = "5fb308b9cb359ae200b7e23d37c76978673aa1b06e2b3075d814ce12c5811640";
        };

        beamDeps = [ ];
      };

      export = buildMix rec {
        name = "export";
        version = "0.1.1";

        src = fetchHex {
          pkg = "export";
          version = "${version}";
          sha256 = "3da7444ff4053f1824352f4bdb13fbd2c28c93c2011786fb686b649fdca1021f";
        };

        beamDeps = [ erlport ];
      };

      fast_html = buildMix rec {
        name = "fast_html";
        version = "2.5.0";

        src = fetchHex {
          pkg = "fast_html";
          version = "${version}";
          sha256 = "69eb46ed98a5d9cca1ccd4a5ac94ce5dd626fc29513fbaa0a16cd8b2da67ae3e";
        };

        beamDeps = [
          elixir_make
          nimble_pool
        ];
      };

      fast_sanitize = buildMix rec {
        name = "fast_sanitize";
        version = "0.2.3";

        src = fetchHex {
          pkg = "fast_sanitize";
          version = "${version}";
          sha256 = "e8ad286d10d0386e15d67d0ee125245ebcfbc7d7290b08712ba9013c8c5e56e2";
        };

        beamDeps = [
          fast_html
          plug
        ];
      };

      file_info = buildMix rec {
        name = "file_info";
        version = "0.0.4";

        src = fetchHex {
          pkg = "file_info";
          version = "${version}";
          sha256 = "50e7ad01c2c8b9339010675fe4dc4a113b8d6ca7eddce24d1d74fd0e762781a5";
        };

        beamDeps = [ mimetype_parser ];
      };

      file_system = buildMix rec {
        name = "file_system";
        version = "1.1.1";

        src = fetchHex {
          pkg = "file_system";
          version = "${version}";
          sha256 = "7a15ff97dfe526aeefb090a7a9d3d03aa907e100e262a0f8f7746b78f8f87a5d";
        };

        beamDeps = [ ];
      };

      floki = buildMix rec {
        name = "floki";
        version = "0.38.0";

        src = fetchHex {
          pkg = "floki";
          version = "${version}";
          sha256 = "a5943ee91e93fb2d635b612caf5508e36d37548e84928463ef9dd986f0d1abd9";
        };

        beamDeps = [ ];
      };

      gen_smtp = buildRebar3 rec {
        name = "gen_smtp";
        version = "1.3.0";

        src = fetchHex {
          pkg = "gen_smtp";
          version = "${version}";
          sha256 = "0b73fbf069864ecbce02fe653b16d3f35fd889d0fdd4e14527675565c39d84e6";
        };

        beamDeps = [ ranch ];
      };

      geo = buildMix rec {
        name = "geo";
        version = "4.1.0";

        src = fetchHex {
          pkg = "geo";
          version = "${version}";
          sha256 = "19edb2b3398ca9f701b573b1fb11bc90951ebd64f18b06bd1bf35abe509a2934";
        };

        beamDeps = [ jason ];
      };

      geo_postgis = buildMix rec {
        name = "geo_postgis";
        version = "3.7.1";

        src = fetchHex {
          pkg = "geo_postgis";
          version = "${version}";
          sha256 = "c20d823c600d35b7fe9ddd5be03052bb7136c57d6f1775dbd46871545e405280";
        };

        beamDeps = [
          ecto
          geo
          jason
          postgrex
        ];
      };

      geohax = buildMix rec {
        name = "geohax";
        version = "1.0.2";

        src = fetchHex {
          pkg = "geohax";
          version = "${version}";
          sha256 = "4c782de1e1ee781e2fa07ba6ebfbfb66b91c215b901073defe6196184b8b60a4";
        };

        beamDeps = [ ];
      };

      geolix = buildMix rec {
        name = "geolix";
        version = "2.0.0";

        src = fetchHex {
          pkg = "geolix";
          version = "${version}";
          sha256 = "8742bf588ed0bb7def2c443204d09d355990846c6efdff96ded66aac24c301df";
        };

        beamDeps = [ ];
      };

      geolix_adapter_mmdb2 = buildMix rec {
        name = "geolix_adapter_mmdb2";
        version = "0.6.0";

        src = fetchHex {
          pkg = "geolix_adapter_mmdb2";
          version = "${version}";
          sha256 = "06ff962feae8a310cffdf86b74bfcda6e2d0dccb439bb1f62df2b657b1c0269b";
        };

        beamDeps = [
          geolix
          mmdb2_decoder
        ];
      };

      gettext = buildMix rec {
        name = "gettext";
        version = "0.26.2";

        src = fetchHex {
          pkg = "gettext";
          version = "${version}";
          sha256 = "aa978504bcf76511efdc22d580ba08e2279caab1066b76bb9aa81c4a1e0a32a5";
        };

        beamDeps = [ expo ];
      };

      guardian = buildMix rec {
        name = "guardian";
        version = "2.4.0";

        src = fetchHex {
          pkg = "guardian";
          version = "${version}";
          sha256 = "5c80103a9c538fbc2505bf08421a82e8f815deba9eaedb6e734c66443154c518";
        };

        beamDeps = [
          jose
          plug
        ];
      };

      guardian_db = buildMix rec {
        name = "guardian_db";
        version = "3.0.0";

        src = fetchHex {
          pkg = "guardian_db";
          version = "${version}";
          sha256 = "9c2ec4278efa34f9f1cc6ba795e552d41fdc7ffba5319d67eeb533b89392d183";
        };

        beamDeps = [
          ecto
          ecto_sql
          guardian
          postgrex
        ];
      };

      guardian_phoenix = buildMix rec {
        name = "guardian_phoenix";
        version = "2.0.1";

        src = fetchHex {
          pkg = "guardian_phoenix";
          version = "${version}";
          sha256 = "21f439246715192b231f228680465d1ed5fbdf01555a4a3b17165532f5f9a08c";
        };

        beamDeps = [
          guardian
          phoenix
        ];
      };

      hackney = buildRebar3 rec {
        name = "hackney";
        version = "1.25.0";

        src = fetchHex {
          pkg = "hackney";
          version = "${version}";
          sha256 = "7209bfd75fd1f42467211ff8f59ea74d6f2a9e81cbcee95a56711ee79fd6b1d4";
        };

        beamDeps = [
          certifi
          idna
          metrics
          mimerl
          parse_trans
          ssl_verify_fun
          unicode_util_compat
        ];
      };

      hammer = buildMix rec {
        name = "hammer";
        version = "6.2.1";

        src = fetchHex {
          pkg = "hammer";
          version = "${version}";
          sha256 = "b9476d0c13883d2dc0cc72e786bac6ac28911fba7cc2e04b70ce6a6d9c4b2bdc";
        };

        beamDeps = [ poolboy ];
      };

      haversine = buildMix rec {
        name = "haversine";
        version = "0.1.0";

        src = fetchHex {
          pkg = "haversine";
          version = "${version}";
          sha256 = "54dc48e895bc18a59437a37026c873634e17b648a64cb87bfafb96f64d607060";
        };

        beamDeps = [ ];
      };

      hpax = buildMix rec {
        name = "hpax";
        version = "1.0.3";

        src = fetchHex {
          pkg = "hpax";
          version = "${version}";
          sha256 = "8eab6e1cfa8d5918c2ce4ba43588e894af35dbd8e91e6e55c817bca5847df34a";
        };

        beamDeps = [ ];
      };

      html_entities = buildMix rec {
        name = "html_entities";
        version = "0.5.2";

        src = fetchHex {
          pkg = "html_entities";
          version = "${version}";
          sha256 = "c53ba390403485615623b9531e97696f076ed415e8d8058b1dbaa28181f4fdcc";
        };

        beamDeps = [ ];
      };

      http_signatures = buildMix rec {
        name = "http_signatures";
        version = "0.1.2";

        src = fetchHex {
          pkg = "http_signatures";
          version = "${version}";
          sha256 = "f08aa9ac121829dae109d608d83c84b940ef2f183ae50f2dd1e9a8bc619d8be7";
        };

        beamDeps = [ ];
      };

      httpoison = buildMix rec {
        name = "httpoison";
        version = "1.8.2";

        src = fetchHex {
          pkg = "httpoison";
          version = "${version}";
          sha256 = "2bb350d26972e30c96e2ca74a1aaf8293d61d0742ff17f01e0279fef11599921";
        };

        beamDeps = [ hackney ];
      };

      idna = buildRebar3 rec {
        name = "idna";
        version = "6.1.1";

        src = fetchHex {
          pkg = "idna";
          version = "${version}";
          sha256 = "92376eb7894412ed19ac475e4a86f7b413c1b9fbb5bd16dccd57934157944cea";
        };

        beamDeps = [ unicode_util_compat ];
      };

      inet_cidr = buildMix rec {
        name = "inet_cidr";
        version = "1.0.9";

        src = fetchHex {
          pkg = "inet_cidr";
          version = "${version}";
          sha256 = "172da15ff7cf635b1feaf14f5818be28c811b37cc5fb7c5f7c01058c1c1066cc";
        };

        beamDeps = [ ];
      };

      ip_reserved = buildMix rec {
        name = "ip_reserved";
        version = "0.1.1";

        src = fetchHex {
          pkg = "ip_reserved";
          version = "${version}";
          sha256 = "55fcd2b6e211caef09ea3f54ef37d43030bec486325d12fe865ab5ed8140a4fe";
        };

        beamDeps = [ inet_cidr ];
      };

      jason = buildMix rec {
        name = "jason";
        version = "1.4.4";

        src = fetchHex {
          pkg = "jason";
          version = "${version}";
          sha256 = "c5eb0cab91f094599f94d55bc63409236a8ec69a21a67814529e8d5f6cc90b3b";
        };

        beamDeps = [ decimal ];
      };

      jose = buildMix rec {
        name = "jose";
        version = "1.11.12";

        src = fetchHex {
          pkg = "jose";
          version = "${version}";
          sha256 = "31e92b653e9210b696765cdd885437457de1add2a9011d92f8cf63e4641bab7b";
        };

        beamDeps = [ ];
      };

      jumper = buildMix rec {
        name = "jumper";
        version = "1.0.2";

        src = fetchHex {
          pkg = "jumper";
          version = "${version}";
          sha256 = "9b7782409021e01ab3c08270e26f36eb62976a38c1aa64b2eaf6348422f165e1";
        };

        beamDeps = [ ];
      };

      junit_formatter = buildMix rec {
        name = "junit_formatter";
        version = "3.4.0";

        src = fetchHex {
          pkg = "junit_formatter";
          version = "${version}";
          sha256 = "bb36e2ae83f1ced6ab931c4ce51dd3dbef1ef61bb4932412e173b0cfa259dacd";
        };

        beamDeps = [ ];
      };

      linkify = buildMix rec {
        name = "linkify";
        version = "0.5.3";

        src = fetchHex {
          pkg = "linkify";
          version = "${version}";
          sha256 = "3ef35a1377d47c25506e07c1c005ea9d38d700699d92ee92825f024434258177";
        };

        beamDeps = [ ];
      };

      makeup = buildMix rec {
        name = "makeup";
        version = "1.2.1";

        src = fetchHex {
          pkg = "makeup";
          version = "${version}";
          sha256 = "d36484867b0bae0fea568d10131197a4c2e47056a6fbe84922bf6ba71c8d17ce";
        };

        beamDeps = [ nimble_parsec ];
      };

      makeup_elixir = buildMix rec {
        name = "makeup_elixir";
        version = "1.0.1";

        src = fetchHex {
          pkg = "makeup_elixir";
          version = "${version}";
          sha256 = "7284900d412a3e5cfd97fdaed4f5ed389b8f2b4cb49efc0eb3bd10e2febf9507";
        };

        beamDeps = [
          makeup
          nimble_parsec
        ];
      };

      makeup_erlang = buildMix rec {
        name = "makeup_erlang";
        version = "1.0.3";

        src = fetchHex {
          pkg = "makeup_erlang";
          version = "${version}";
          sha256 = "953297c02582a33411ac6208f2c6e55f0e870df7f80da724ed613f10e6706afd";
        };

        beamDeps = [ makeup ];
      };

      meck = buildRebar3 rec {
        name = "meck";
        version = "0.9.2";

        src = fetchHex {
          pkg = "meck";
          version = "${version}";
          sha256 = "81344f561357dc40a8344afa53767c32669153355b626ea9fcbc8da6b3045826";
        };

        beamDeps = [ ];
      };

      metrics = buildRebar3 rec {
        name = "metrics";
        version = "1.0.1";

        src = fetchHex {
          pkg = "metrics";
          version = "${version}";
          sha256 = "69b09adddc4f74a40716ae54d140f93beb0fb8978d8636eaded0c31b6f099f16";
        };

        beamDeps = [ ];
      };

      mime = buildMix rec {
        name = "mime";
        version = "2.0.7";

        src = fetchHex {
          pkg = "mime";
          version = "${version}";
          sha256 = "6171188e399ee16023ffc5b76ce445eb6d9672e2e241d2df6050f3c771e80ccd";
        };

        beamDeps = [ ];
      };

      mimerl = buildRebar3 rec {
        name = "mimerl";
        version = "1.4.0";

        src = fetchHex {
          pkg = "mimerl";
          version = "${version}";
          sha256 = "13af15f9f68c65884ecca3a3891d50a7b57d82152792f3e19d88650aa126b144";
        };

        beamDeps = [ ];
      };

      mimetype_parser = buildMix rec {
        name = "mimetype_parser";
        version = "0.1.3";

        src = fetchHex {
          pkg = "mimetype_parser";
          version = "${version}";
          sha256 = "7d8f80c567807ce78cd93c938e7f4b0a20b1aaaaab914bf286f68457d9f7a852";
        };

        beamDeps = [ ];
      };

      mix_test_watch = buildMix rec {
        name = "mix_test_watch";
        version = "1.4.0";

        src = fetchHex {
          pkg = "mix_test_watch";
          version = "${version}";
          sha256 = "2b4693e17c8ead2ef56d4f48a0329891e8c2d0d73752c0f09272a2b17dc38d1b";
        };

        beamDeps = [ file_system ];
      };

      mmdb2_decoder = buildMix rec {
        name = "mmdb2_decoder";
        version = "3.0.1";

        src = fetchHex {
          pkg = "mmdb2_decoder";
          version = "${version}";
          sha256 = "316af0f388fac824782d944f54efe78e7c9691bbbdb0afd5cccdd0510adf559d";
        };

        beamDeps = [ ];
      };

      mock = buildMix rec {
        name = "mock";
        version = "0.3.9";

        src = fetchHex {
          pkg = "mock";
          version = "${version}";
          sha256 = "9e1b244c4ca2551bb17bb8415eed89e40ee1308e0fbaed0a4fdfe3ec8a4adbd3";
        };

        beamDeps = [ meck ];
      };

      mogrify = buildMix rec {
        name = "mogrify";
        version = "0.9.3";

        src = fetchHex {
          pkg = "mogrify";
          version = "${version}";
          sha256 = "0189b1e1de27455f2b9ae8cf88239cefd23d38de9276eb5add7159aea51731e6";
        };

        beamDeps = [ ];
      };

      mox = buildMix rec {
        name = "mox";
        version = "1.2.0";

        src = fetchHex {
          pkg = "mox";
          version = "${version}";
          sha256 = "c7b92b3cc69ee24a7eeeaf944cd7be22013c52fcb580c1f33f50845ec821089a";
        };

        beamDeps = [ nimble_ownership ];
      };

      nimble_csv = buildMix rec {
        name = "nimble_csv";
        version = "1.3.0";

        src = fetchHex {
          pkg = "nimble_csv";
          version = "${version}";
          sha256 = "41ccdc18f7c8f8bb06e84164fc51635321e80d5a3b450761c4997d620925d619";
        };

        beamDeps = [ ];
      };

      nimble_options = buildMix rec {
        name = "nimble_options";
        version = "1.1.1";

        src = fetchHex {
          pkg = "nimble_options";
          version = "${version}";
          sha256 = "821b2470ca9442c4b6984882fe9bb0389371b8ddec4d45a9504f00a66f650b44";
        };

        beamDeps = [ ];
      };

      nimble_ownership = buildMix rec {
        name = "nimble_ownership";
        version = "1.0.2";

        src = fetchHex {
          pkg = "nimble_ownership";
          version = "${version}";
          sha256 = "098af64e1f6f8609c6672127cfe9e9590a5d3fcdd82bc17a377b8692fd81a879";
        };

        beamDeps = [ ];
      };

      nimble_parsec = buildMix rec {
        name = "nimble_parsec";
        version = "1.4.2";

        src = fetchHex {
          pkg = "nimble_parsec";
          version = "${version}";
          sha256 = "4b21398942dda052b403bbe1da991ccd03a053668d147d53fb8c4e0efe09c973";
        };

        beamDeps = [ ];
      };

      nimble_pool = buildMix rec {
        name = "nimble_pool";
        version = "1.1.0";

        src = fetchHex {
          pkg = "nimble_pool";
          version = "${version}";
          sha256 = "af2e4e6b34197db81f7aad230c1118eac993acc0dae6bc83bac0126d4ae0813a";
        };

        beamDeps = [ ];
      };

      oauth2 = buildMix rec {
        name = "oauth2";
        version = "2.1.0";

        src = fetchHex {
          pkg = "oauth2";
          version = "${version}";
          sha256 = "8ac07f85b3307dd1acfeb0ec852f64161b22f57d0ce0c15e616a1dfc8ebe2b41";
        };

        beamDeps = [ tesla ];
      };

      oauther = buildMix rec {
        name = "oauther";
        version = "1.3.0";

        src = fetchHex {
          pkg = "oauther";
          version = "${version}";
          sha256 = "78eb888ea875c72ca27b0864a6f550bc6ee84f2eeca37b093d3d833fbcaec04e";
        };

        beamDeps = [ ];
      };

      oban = buildMix rec {
        name = "oban";
        version = "2.20.2";

        src = fetchHex {
          pkg = "oban";
          version = "${version}";
          sha256 = "523365ef0217781c061d15f496e3200a5f1b43e08b1a27c34799ef8bfe95815f";
        };

        beamDeps = [
          ecto_sql
          jason
          postgrex
          telemetry
        ];
      };

      paasaa = buildMix rec {
        name = "paasaa";
        version = "1.0.0";

        src = fetchHex {
          pkg = "paasaa";
          version = "${version}";
          sha256 = "709262e8df8fa3b93e502c04d255a63d8729e609d9eb7fc42b9479f3f98e02b7";
        };

        beamDeps = [ ];
      };

      parse_trans = buildRebar3 rec {
        name = "parse_trans";
        version = "3.4.1";

        src = fetchHex {
          pkg = "parse_trans";
          version = "${version}";
          sha256 = "620a406ce75dada827b82e453c19cf06776be266f5a67cff34e1ef2cbb60e49a";
        };

        beamDeps = [ ];
      };

      phoenix = buildMix rec {
        name = "phoenix";
        version = "1.8.3";

        src = fetchHex {
          pkg = "phoenix";
          version = "${version}";
          sha256 = "36169f95cc2e155b78be93d9590acc3f462f1e5438db06e6248613f27c80caec";
        };

        beamDeps = [
          bandit
          jason
          phoenix_pubsub
          phoenix_template
          phoenix_view
          plug
          plug_crypto
          telemetry
          websock_adapter
        ];
      };

      phoenix_ecto = buildMix rec {
        name = "phoenix_ecto";
        version = "4.7.0";

        src = fetchHex {
          pkg = "phoenix_ecto";
          version = "${version}";
          sha256 = "1d75011e4254cb4ddf823e81823a9629559a1be93b4321a6a5f11a5306fbf4cc";
        };

        beamDeps = [
          ecto
          phoenix_html
          plug
          postgrex
        ];
      };

      phoenix_html = buildMix rec {
        name = "phoenix_html";
        version = "4.3.0";

        src = fetchHex {
          pkg = "phoenix_html";
          version = "${version}";
          sha256 = "3eaa290a78bab0f075f791a46a981bbe769d94bc776869f4f3063a14f30497ad";
        };

        beamDeps = [ ];
      };

      phoenix_html_helpers = buildMix rec {
        name = "phoenix_html_helpers";
        version = "1.0.1";

        src = fetchHex {
          pkg = "phoenix_html_helpers";
          version = "${version}";
          sha256 = "cffd2385d1fa4f78b04432df69ab8da63dc5cf63e07b713a4dcf36a3740e3090";
        };

        beamDeps = [
          phoenix_html
          plug
        ];
      };

      phoenix_live_reload = buildMix rec {
        name = "phoenix_live_reload";
        version = "1.6.2";

        src = fetchHex {
          pkg = "phoenix_live_reload";
          version = "${version}";
          sha256 = "d1f89c18114c50d394721365ffb428cce24f1c13de0467ffa773e2ff4a30d5b9";
        };

        beamDeps = [
          file_system
          phoenix
        ];
      };

      phoenix_live_view = buildMix rec {
        name = "phoenix_live_view";
        version = "1.1.19";

        src = fetchHex {
          pkg = "phoenix_live_view";
          version = "${version}";
          sha256 = "d5ad357d6b21562a5b431f0ad09dfe76db9ce5648c6949f1aac334c8c4455d32";
        };

        beamDeps = [
          jason
          phoenix
          phoenix_html
          phoenix_template
          phoenix_view
          plug
          telemetry
        ];
      };

      phoenix_pubsub = buildMix rec {
        name = "phoenix_pubsub";
        version = "2.2.0";

        src = fetchHex {
          pkg = "phoenix_pubsub";
          version = "${version}";
          sha256 = "adc313a5bf7136039f63cfd9668fde73bba0765e0614cba80c06ac9460ff3e96";
        };

        beamDeps = [ ];
      };

      phoenix_swoosh = buildMix rec {
        name = "phoenix_swoosh";
        version = "1.2.1";

        src = fetchHex {
          pkg = "phoenix_swoosh";
          version = "${version}";
          sha256 = "4000eeba3f9d7d1a6bf56d2bd56733d5cadf41a7f0d8ffe5bb67e7d667e204a2";
        };

        beamDeps = [
          hackney
          phoenix
          phoenix_html
          phoenix_view
          swoosh
        ];
      };

      phoenix_template = buildMix rec {
        name = "phoenix_template";
        version = "1.0.4";

        src = fetchHex {
          pkg = "phoenix_template";
          version = "${version}";
          sha256 = "2c0c81f0e5c6753faf5cca2f229c9709919aba34fab866d3bc05060c9c444206";
        };

        beamDeps = [ phoenix_html ];
      };

      phoenix_view = buildMix rec {
        name = "phoenix_view";
        version = "2.0.4";

        src = fetchHex {
          pkg = "phoenix_view";
          version = "${version}";
          sha256 = "4e992022ce14f31fe57335db27a28154afcc94e9983266835bb3040243eb620b";
        };

        beamDeps = [
          phoenix_html
          phoenix_template
        ];
      };

      plug = buildMix rec {
        name = "plug";
        version = "1.19.1";

        src = fetchHex {
          pkg = "plug";
          version = "${version}";
          sha256 = "560a0017a8f6d5d30146916862aaf9300b7280063651dd7e532b8be168511e62";
        };

        beamDeps = [
          mime
          plug_crypto
          telemetry
        ];
      };

      plug_crypto = buildMix rec {
        name = "plug_crypto";
        version = "2.1.1";

        src = fetchHex {
          pkg = "plug_crypto";
          version = "${version}";
          sha256 = "6470bce6ffe41c8bd497612ffde1a7e4af67f36a15eea5f921af71cf3e11247c";
        };

        beamDeps = [ ];
      };

      poolboy = buildRebar3 rec {
        name = "poolboy";
        version = "1.5.2";

        src = fetchHex {
          pkg = "poolboy";
          version = "${version}";
          sha256 = "dad79704ce5440f3d5a3681c8590b9dc25d1a561e8f5a9c995281012860901e3";
        };

        beamDeps = [ ];
      };

      postgrex = buildMix rec {
        name = "postgrex";
        version = "0.21.1";

        src = fetchHex {
          pkg = "postgrex";
          version = "${version}";
          sha256 = "27d8d21c103c3cc68851b533ff99eef353e6a0ff98dc444ea751de43eb48bdac";
        };

        beamDeps = [
          db_connection
          decimal
          jason
        ];
      };

      progress_bar = buildMix rec {
        name = "progress_bar";
        version = "3.0.0";

        src = fetchHex {
          pkg = "progress_bar";
          version = "${version}";
          sha256 = "6981c2b25ab24aecc91a2dc46623658e1399c21a2ae24db986b90d678530f2b7";
        };

        beamDeps = [ decimal ];
      };

      ranch = buildRebar3 rec {
        name = "ranch";
        version = "2.2.0";

        src = fetchHex {
          pkg = "ranch";
          version = "${version}";
          sha256 = "fa0b99a1780c80218a4197a59ea8d3bdae32fbff7e88527d7d8a4787eff4f8e7";
        };

        beamDeps = [ ];
      };

      remote_ip = buildMix rec {
        name = "remote_ip";
        version = "1.2.0";

        src = fetchHex {
          pkg = "remote_ip";
          version = "${version}";
          sha256 = "2ff91de19c48149ce19ed230a81d377186e4412552a597d6a5137373e5877cb7";
        };

        beamDeps = [
          combine
          plug
        ];
      };

      replug = buildMix rec {
        name = "replug";
        version = "0.1.0";

        src = fetchHex {
          pkg = "replug";
          version = "${version}";
          sha256 = "f71f7a57e944e854fe4946060c6964098e53958074c69fb844b96e0bd58cfa60";
        };

        beamDeps = [ plug ];
      };

      sentry = buildMix rec {
        name = "sentry";
        version = "11.0.4";

        src = fetchHex {
          pkg = "sentry";
          version = "${version}";
          sha256 = "feaafc284dc204c82aadaddc884227aeaa3480decb274d30e184b9d41a700c66";
        };

        beamDeps = [
          hackney
          jason
          nimble_options
          nimble_ownership
          phoenix
          phoenix_live_view
          plug
          telemetry
        ];
      };

      shortuuid = buildMix rec {
        name = "shortuuid";
        version = "4.1.0";

        src = fetchHex {
          pkg = "shortuuid";
          version = "${version}";
          sha256 = "7336719118b3cca1ac73e95810199b0b9b7d00f9d71bd2c2d27fed4c4f74388e";
        };

        beamDeps = [ ];
      };

      sitemapper = buildMix rec {
        name = "sitemapper";
        version = "0.10.0";

        src = fetchHex {
          pkg = "sitemapper";
          version = "${version}";
          sha256 = "89ef80f04e4092cb3a8cbcf37520fa31784cc07104c0b47354539e38d2e62443";
        };

        beamDeps = [ xml_builder ];
      };

      sleeplocks = buildRebar3 rec {
        name = "sleeplocks";
        version = "1.1.3";

        src = fetchHex {
          pkg = "sleeplocks";
          version = "${version}";
          sha256 = "d3b3958552e6eb16f463921e70ae7c767519ef8f5be46d7696cc1ed649421321";
        };

        beamDeps = [ ];
      };

      slugger = buildMix rec {
        name = "slugger";
        version = "0.3.0";

        src = fetchHex {
          pkg = "slugger";
          version = "${version}";
          sha256 = "20d0ded0e712605d1eae6c5b4889581c3460d92623a930ddda91e0e609b5afba";
        };

        beamDeps = [ ];
      };

      slugify = buildMix rec {
        name = "slugify";
        version = "1.3.1";

        src = fetchHex {
          pkg = "slugify";
          version = "${version}";
          sha256 = "cb090bbeb056b312da3125e681d98933a360a70d327820e4b7f91645c4d8be76";
        };

        beamDeps = [ ];
      };

      sobelow = buildMix rec {
        name = "sobelow";
        version = "0.14.1";

        src = fetchHex {
          pkg = "sobelow";
          version = "${version}";
          sha256 = "8fac9a2bd90fdc4b15d6fca6e1608efb7f7c600fa75800813b794ee9364c87f2";
        };

        beamDeps = [ jason ];
      };

      ssl_verify_fun = buildRebar3 rec {
        name = "ssl_verify_fun";
        version = "1.1.7";

        src = fetchHex {
          pkg = "ssl_verify_fun";
          version = "${version}";
          sha256 = "fe4c190e8f37401d30167c8c405eda19469f34577987c76dde613e838bbc67f8";
        };

        beamDeps = [ ];
      };

      struct_access = buildMix rec {
        name = "struct_access";
        version = "1.1.2";

        src = fetchHex {
          pkg = "struct_access";
          version = "${version}";
          sha256 = "e4c411dcc0226081b95709909551fc92b8feb1a3476108348ea7e3f6c12e586a";
        };

        beamDeps = [ ];
      };

      sweet_xml = buildMix rec {
        name = "sweet_xml";
        version = "0.7.5";

        src = fetchHex {
          pkg = "sweet_xml";
          version = "${version}";
          sha256 = "193b28a9b12891cae351d81a0cead165ffe67df1b73fe5866d10629f4faefb12";
        };

        beamDeps = [ ];
      };

      swoosh = buildMix rec {
        name = "swoosh";
        version = "1.20.0";

        src = fetchHex {
          pkg = "swoosh";
          version = "${version}";
          sha256 = "13e610f709bae54851d68afb6862882aa646e5c974bf49e3bf5edd84a73cf213";
        };

        beamDeps = [
          bandit
          gen_smtp
          hackney
          idna
          jason
          mime
          plug
          telemetry
        ];
      };

      telemetry = buildRebar3 rec {
        name = "telemetry";
        version = "1.3.0";

        src = fetchHex {
          pkg = "telemetry";
          version = "${version}";
          sha256 = "7015fc8919dbe63764f4b4b87a95b7c0996bd539e0d499be6ec9d7f3875b79e6";
        };

        beamDeps = [ ];
      };

      tesla = buildMix rec {
        name = "tesla";
        version = "1.15.3";

        src = fetchHex {
          pkg = "tesla";
          version = "${version}";
          sha256 = "98bb3d4558abc67b92fb7be4cd31bb57ca8d80792de26870d362974b58caeda7";
        };

        beamDeps = [
          castore
          hackney
          jason
          mime
          mox
          telemetry
        ];
      };

      thousand_island = buildMix rec {
        name = "thousand_island";
        version = "1.4.3";

        src = fetchHex {
          pkg = "thousand_island";
          version = "${version}";
          sha256 = "6e4ce09b0fd761a58594d02814d40f77daff460c48a7354a15ab353bb998ea0b";
        };

        beamDeps = [ telemetry ];
      };

      timex = buildMix rec {
        name = "timex";
        version = "3.7.13";

        src = fetchHex {
          pkg = "timex";
          version = "${version}";
          sha256 = "09588e0522669328e973b8b4fd8741246321b3f0d32735b589f78b136e6d4c54";
        };

        beamDeps = [
          combine
          gettext
          tzdata
        ];
      };

      tls_certificate_check = buildRebar3 rec {
        name = "tls_certificate_check";
        version = "1.31.0";

        src = fetchHex {
          pkg = "tls_certificate_check";
          version = "${version}";
          sha256 = "9d2b41b128d5507bd8ad93e1a998e06d0ab2f9a772af343f4c00bf76c6be1532";
        };

        beamDeps = [ ssl_verify_fun ];
      };

      tz_world = buildMix rec {
        name = "tz_world";
        version = "1.4.1";

        src = fetchHex {
          pkg = "tz_world";
          version = "${version}";
          sha256 = "9173ba7aa7c5e627e23adfc0c8d001a56a7072d5bdc8d3a94e4cd44e25decba1";
        };

        beamDeps = [
          castore
          certifi
          geo
          jason
        ];
      };

      tzdata = buildMix rec {
        name = "tzdata";
        version = "1.1.3";

        src = fetchHex {
          pkg = "tzdata";
          version = "${version}";
          sha256 = "d4ca85575a064d29d4e94253ee95912edfb165938743dbf002acdf0dcecb0c28";
        };

        beamDeps = [ hackney ];
      };

      ueberauth = buildMix rec {
        name = "ueberauth";
        version = "0.10.8";

        src = fetchHex {
          pkg = "ueberauth";
          version = "${version}";
          sha256 = "f2d3172e52821375bccb8460e5fa5cb91cfd60b19b636b6e57e9759b6f8c10c1";
        };

        beamDeps = [ plug ];
      };

      ueberauth_cas = buildMix rec {
        name = "ueberauth_cas";
        version = "2.3.1";

        src = fetchHex {
          pkg = "ueberauth_cas";
          version = "${version}";
          sha256 = "5068ae2b9e217c2f05aa9a67483a6531e21ba0be9a6f6c8749bb7fd1599be321";
        };

        beamDeps = [
          httpoison
          sweet_xml
          ueberauth
        ];
      };

      ueberauth_discord = buildMix rec {
        name = "ueberauth_discord";
        version = "0.7.0";

        src = fetchHex {
          pkg = "ueberauth_discord";
          version = "${version}";
          sha256 = "d6f98ef91abb4ddceada4b7acba470e0e68c4d2de9735ff2f24172a8e19896b4";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_facebook = buildMix rec {
        name = "ueberauth_facebook";
        version = "0.10.0";

        src = fetchHex {
          pkg = "ueberauth_facebook";
          version = "${version}";
          sha256 = "bf8ce5d66b1c50da8abff77e8086c1b710bdde63f4acaef19a651ba43a9537a8";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_github = buildMix rec {
        name = "ueberauth_github";
        version = "0.8.3";

        src = fetchHex {
          pkg = "ueberauth_github";
          version = "${version}";
          sha256 = "ae0ab2879c32cfa51d7287a48219b262bfdab0b7ec6629f24160564247493cc6";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_gitlab_strategy = buildMix rec {
        name = "ueberauth_gitlab_strategy";
        version = "0.4.0";

        src = fetchHex {
          pkg = "ueberauth_gitlab_strategy";
          version = "${version}";
          sha256 = "e86e2e794bb063c07c05a6b1301b73f2be3ba9308d8f47ecc4d510ef9226091e";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_google = buildMix rec {
        name = "ueberauth_google";
        version = "0.12.1";

        src = fetchHex {
          pkg = "ueberauth_google";
          version = "${version}";
          sha256 = "7f7deacd679b2b66e3bffb68ecc77aa1b5396a0cbac2941815f253128e458c38";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_keycloak_strategy = buildMix rec {
        name = "ueberauth_keycloak_strategy";
        version = "0.4.0";

        src = fetchHex {
          pkg = "ueberauth_keycloak_strategy";
          version = "${version}";
          sha256 = "c03027937bddcbd9ff499e457f9bb05f79018fa321abf79ebcfed2af0007211b";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_twitter = buildMix rec {
        name = "ueberauth_twitter";
        version = "0.4.1";

        src = fetchHex {
          pkg = "ueberauth_twitter";
          version = "${version}";
          sha256 = "83ca8ea3e1a3f976f1adbebfb323b9ebf53af453fbbf57d0486801a303b16065";
        };

        beamDeps = [
          httpoison
          oauther
          ueberauth
        ];
      };

      unicode_util_compat = buildRebar3 rec {
        name = "unicode_util_compat";
        version = "0.7.1";

        src = fetchHex {
          pkg = "unicode_util_compat";
          version = "${version}";
          sha256 = "b3a917854ce3ae233619744ad1e0102e05673136776fb2fa76234f3e03b23642";
        };

        beamDeps = [ ];
      };

      unplug = buildMix rec {
        name = "unplug";
        version = "1.1.0";

        src = fetchHex {
          pkg = "unplug";
          version = "${version}";
          sha256 = "a3b302125ed60b658a9a7c0dff6941050bfc56dc77a0bca72facdb743159898f";
        };

        beamDeps = [ plug ];
      };

      unsafe = buildMix rec {
        name = "unsafe";
        version = "1.0.2";

        src = fetchHex {
          pkg = "unsafe";
          version = "${version}";
          sha256 = "b485231683c3ab01a9cd44cb4a79f152c6f3bb87358439c6f68791b85c2df675";
        };

        beamDeps = [ ];
      };

      vite_phx = buildMix rec {
        name = "vite_phx";
        version = "0.3.2";

        src = fetchHex {
          pkg = "vite_phx";
          version = "${version}";
          sha256 = "43e95d2d80e0cb62c33fc6db4aa6a6135efe1a70395c85a44bdc855da01587ba";
        };

        beamDeps = [
          jason
          phoenix
        ];
      };

      websock = buildMix rec {
        name = "websock";
        version = "0.5.3";

        src = fetchHex {
          pkg = "websock";
          version = "${version}";
          sha256 = "6105453d7fac22c712ad66fab1d45abdf049868f253cf719b625151460b8b453";
        };

        beamDeps = [ ];
      };

      websock_adapter = buildMix rec {
        name = "websock_adapter";
        version = "0.5.9";

        src = fetchHex {
          pkg = "websock_adapter";
          version = "${version}";
          sha256 = "5534d5c9adad3c18a0f58a9371220d75a803bf0b9a3d87e6fe072faaeed76a08";
        };

        beamDeps = [
          bandit
          plug
          websock
        ];
      };

      xml_builder = buildMix rec {
        name = "xml_builder";
        version = "2.4.0";

        src = fetchHex {
          pkg = "xml_builder";
          version = "${version}";
          sha256 = "833e325bb997f032b5a1b740d2fd6feed3c18ca74627f9f5f30513a9ae1a232d";
        };

        beamDeps = [ ];
      };
    };
in
self
