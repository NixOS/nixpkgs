{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    absinthe = buildMix rec {
      name = "absinthe";
      version = "1.7.6";

      src = fetchHex {
        pkg = "absinthe";
        version = "${version}";
        sha256 = "e7626951ca5eec627da960615b51009f3a774765406ff02722b1d818f17e5778";
      };

      beamDeps = [ dataloader decimal nimble_parsec telemetry ];
    };

    absinthe_phoenix = buildMix rec {
      name = "absinthe_phoenix";
      version = "2.0.2";

      src = fetchHex {
        pkg = "absinthe_phoenix";
        version = "${version}";
        sha256 = "d36918925c380dc7d2ed7d039c9a3b4182ec36723f7417a68745ade5aab22f8d";
      };

      beamDeps = [ absinthe absinthe_plug decimal phoenix phoenix_html phoenix_pubsub ];
    };

    absinthe_plug = buildMix rec {
      name = "absinthe_plug";
      version = "1.5.8";

      src = fetchHex {
        pkg = "absinthe_plug";
        version = "${version}";
        sha256 = "bbb04176647b735828861e7b2705465e53e2cf54ccf5a73ddd1ebd855f996e5a";
      };

      beamDeps = [ absinthe plug ];
    };

    argon2_elixir = buildMix rec {
      name = "argon2_elixir";
      version = "4.0.0";

      src = fetchHex {
        pkg = "argon2_elixir";
        version = "${version}";
        sha256 = "f9da27cf060c9ea61b1bd47837a28d7e48a8f6fa13a745e252556c14f9132c7f";
      };

      beamDeps = [ comeonin elixir_make ];
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

    bunt = buildMix rec {
      name = "bunt";
      version = "0.2.1";

      src = fetchHex {
        pkg = "bunt";
        version = "${version}";
        sha256 = "a330bfb4245239787b15005e66ae6845c9cd524a288f0d141c148b02603777a5";
      };

      beamDeps = [];
    };

    cachex = buildMix rec {
      name = "cachex";
      version = "3.6.0";

      src = fetchHex {
        pkg = "cachex";
        version = "${version}";
        sha256 = "ebf24e373883bc8e0c8d894a63bbe102ae13d918f790121f5cfe6e485cc8e2e2";
      };

      beamDeps = [ eternal jumper sleeplocks unsafe ];
    };

    castore = buildMix rec {
      name = "castore";
      version = "1.0.4";

      src = fetchHex {
        pkg = "castore";
        version = "${version}";
        sha256 = "9418c1b8144e11656f0be99943db4caf04612e3eaecefb5dae9a2a87565584f8";
      };

      beamDeps = [];
    };

    certifi = buildRebar3 rec {
      name = "certifi";
      version = "2.12.0";

      src = fetchHex {
        pkg = "certifi";
        version = "${version}";
        sha256 = "ee68d85df22e554040cdb4be100f33873ac6051387baf6a8f6ce82272340ff1c";
      };

      beamDeps = [];
    };

    cldr_utils = buildMix rec {
      name = "cldr_utils";
      version = "2.24.2";

      src = fetchHex {
        pkg = "cldr_utils";
        version = "${version}";
        sha256 = "3362b838836a9f0fa309de09a7127e36e67310e797d556db92f71b548832c7cf";
      };

      beamDeps = [ castore certifi decimal ];
    };

    codepagex = buildMix rec {
      name = "codepagex";
      version = "0.1.6";

      src = fetchHex {
        pkg = "codepagex";
        version = "${version}";
        sha256 = "1521461097dde281edf084062f525a4edc6a5e49f4fd1f5ec41c9c4955d5bd59";
      };

      beamDeps = [];
    };

    combine = buildMix rec {
      name = "combine";
      version = "0.10.0";

      src = fetchHex {
        pkg = "combine";
        version = "${version}";
        sha256 = "1b1dbc1790073076580d0d1d64e42eae2366583e7aecd455d1215b0d16f2451b";
      };

      beamDeps = [];
    };

    comeonin = buildMix rec {
      name = "comeonin";
      version = "5.4.0";

      src = fetchHex {
        pkg = "comeonin";
        version = "${version}";
        sha256 = "796393a9e50d01999d56b7b8420ab0481a7538d0caf80919da493b4a6e51faf1";
      };

      beamDeps = [];
    };

    connection = buildMix rec {
      name = "connection";
      version = "1.1.0";

      src = fetchHex {
        pkg = "connection";
        version = "${version}";
        sha256 = "722c1eb0a418fbe91ba7bd59a47e28008a189d47e37e0e7bb85585a016b2869c";
      };

      beamDeps = [];
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

    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.10.0";

      src = fetchHex {
        pkg = "cowboy";
        version = "${version}";
        sha256 = "3afdccb7183cc6f143cb14d3cf51fa00e53db9ec80cdcd525482f5e99bc41d6b";
      };

      beamDeps = [ cowlib ranch ];
    };

    cowboy_telemetry = buildRebar3 rec {
      name = "cowboy_telemetry";
      version = "0.4.0";

      src = fetchHex {
        pkg = "cowboy_telemetry";
        version = "${version}";
        sha256 = "7d98bac1ee4565d31b62d59f8823dfd8356a169e7fcbb83831b8a5397404c9de";
      };

      beamDeps = [ cowboy telemetry ];
    };

    cowlib = buildRebar3 rec {
      name = "cowlib";
      version = "2.12.1";

      src = fetchHex {
        pkg = "cowlib";
        version = "${version}";
        sha256 = "163b73f6367a7341b33c794c4e88e7dbfe6498ac42dcd69ef44c5bc5507c8db0";
      };

      beamDeps = [];
    };

    credo = buildMix rec {
      name = "credo";
      version = "1.7.1";

      src = fetchHex {
        pkg = "credo";
        version = "${version}";
        sha256 = "e9871c6095a4c0381c89b6aa98bc6260a8ba6addccf7f6a53da8849c748a58a2";
      };

      beamDeps = [ bunt file_system jason ];
    };

    credo_code_climate = buildMix rec {
      name = "credo_code_climate";
      version = "0.1.0";

      src = fetchHex {
        pkg = "credo_code_climate";
        version = "${version}";
        sha256 = "75529fe38056f4e229821d604758282838b8397c82e2c12e409fda16b16821ca";
      };

      beamDeps = [ credo jason ];
    };

    dataloader = buildMix rec {
      name = "dataloader";
      version = "2.0.0";

      src = fetchHex {
        pkg = "dataloader";
        version = "${version}";
        sha256 = "09d61781b76ce216e395cdbc883ff00d00f46a503e215c22722dba82507dfef0";
      };

      beamDeps = [ ecto telemetry ];
    };

    db_connection = buildMix rec {
      name = "db_connection";
      version = "2.6.0";

      src = fetchHex {
        pkg = "db_connection";
        version = "${version}";
        sha256 = "c2f992d15725e721ec7fbc1189d4ecdb8afef76648c746a8e1cad35e3b8a35f3";
      };

      beamDeps = [ telemetry ];
    };

    decimal = buildMix rec {
      name = "decimal";
      version = "2.1.1";

      src = fetchHex {
        pkg = "decimal";
        version = "${version}";
        sha256 = "53cfe5f497ed0e7771ae1a475575603d77425099ba5faef9394932b35020ffcc";
      };

      beamDeps = [];
    };

    dialyxir = buildMix rec {
      name = "dialyxir";
      version = "1.4.2";

      src = fetchHex {
        pkg = "dialyxir";
        version = "${version}";
        sha256 = "516603d8067b2fd585319e4b13d3674ad4f314a5902ba8130cd97dc902ce6bbd";
      };

      beamDeps = [ erlex ];
    };

    digital_token = buildMix rec {
      name = "digital_token";
      version = "0.6.0";

      src = fetchHex {
        pkg = "digital_token";
        version = "${version}";
        sha256 = "2455d626e7c61a128b02a4a8caddb092548c3eb613ac6f6a85e4cbb6caddc4d1";
      };

      beamDeps = [ cldr_utils jason ];
    };

    doctor = buildMix rec {
      name = "doctor";
      version = "0.21.0";

      src = fetchHex {
        pkg = "doctor";
        version = "${version}";
        sha256 = "a227831daa79784eb24cdeedfa403c46a4cb7d0eab0e31232ec654314447e4e0";
      };

      beamDeps = [ decimal ];
    };

    earmark_parser = buildMix rec {
      name = "earmark_parser";
      version = "1.4.38";

      src = fetchHex {
        pkg = "earmark_parser";
        version = "${version}";
        sha256 = "2cd0907795aaef0c7e8442e376633c5b3bd6edc8dbbdc539b22f095501c1cdb6";
      };

      beamDeps = [];
    };

    eblurhash = buildRebar3 rec {
      name = "eblurhash";
      version = "1.2.2";

      src = fetchHex {
        pkg = "eblurhash";
        version = "${version}";
        sha256 = "8c20ca00904de023a835a9dcb7b7762fed32264c85a80c3cafa85288e405044c";
      };

      beamDeps = [];
    };

    ecto = buildMix rec {
      name = "ecto";
      version = "3.11.0";

      src = fetchHex {
        pkg = "ecto";
        version = "${version}";
        sha256 = "7769dad267ef967310d6e988e92d772659b11b09a0c015f101ce0fff81ce1f81";
      };

      beamDeps = [ decimal jason telemetry ];
    };

    ecto_autoslug_field = buildMix rec {
      name = "ecto_autoslug_field";
      version = "3.1.0";

      src = fetchHex {
        pkg = "ecto_autoslug_field";
        version = "${version}";
        sha256 = "b6ddd614805263e24b5c169532c934440d0289181cce873061fca3a8e92fd9ff";
      };

      beamDeps = [ ecto slugify ];
    };

    ecto_dev_logger = buildMix rec {
      name = "ecto_dev_logger";
      version = "0.9.0";

      src = fetchHex {
        pkg = "ecto_dev_logger";
        version = "${version}";
        sha256 = "2e8bc98b4ae4fcc7108896eef7da5a109afad829f4fb2eb46d677fdc9101c2d5";
      };

      beamDeps = [ ecto jason ];
    };

    ecto_enum = buildMix rec {
      name = "ecto_enum";
      version = "1.4.0";

      src = fetchHex {
        pkg = "ecto_enum";
        version = "${version}";
        sha256 = "8fb55c087181c2b15eee406519dc22578fa60dd82c088be376d0010172764ee4";
      };

      beamDeps = [ ecto ecto_sql postgrex ];
    };

    ecto_shortuuid = buildMix rec {
      name = "ecto_shortuuid";
      version = "0.2.0";

      src = fetchHex {
        pkg = "ecto_shortuuid";
        version = "${version}";
        sha256 = "b92e3b71e86be92f5a7ef6f3de170e7864454e630f7b01dd930414baf38efb65";
      };

      beamDeps = [ ecto shortuuid ];
    };

    ecto_sql = buildMix rec {
      name = "ecto_sql";
      version = "3.11.0";

      src = fetchHex {
        pkg = "ecto_sql";
        version = "${version}";
        sha256 = "77aa3677169f55c2714dda7352d563002d180eb33c0dc29cd36d39c0a1a971f5";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
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
      version = "0.7.7";

      src = fetchHex {
        pkg = "elixir_make";
        version = "${version}";
        sha256 = "5bc19fff950fad52bbe5f211b12db9ec82c6b34a9647da0c2224b8b8464c7e6c";
      };

      beamDeps = [ castore ];
    };

    erlex = buildMix rec {
      name = "erlex";
      version = "0.2.6";

      src = fetchHex {
        pkg = "erlex";
        version = "${version}";
        sha256 = "2ed2e25711feb44d52b17d2780eabf998452f6efda104877a3881c2f8c0c0c75";
      };

      beamDeps = [];
    };

    erlport = buildRebar3 rec {
      name = "erlport";
      version = "0.11.0";

      src = fetchHex {
        pkg = "erlport";
        version = "${version}";
        sha256 = "8eb136ccaf3948d329b8d1c3278ad2e17e2a7319801bc4cc2da6db278204eee4";
      };

      beamDeps = [];
    };

    eternal = buildMix rec {
      name = "eternal";
      version = "1.2.2";

      src = fetchHex {
        pkg = "eternal";
        version = "${version}";
        sha256 = "2c9fe32b9c3726703ba5e1d43a1d255a4f3f2d8f8f9bc19f094c7cb1a7a9e782";
      };

      beamDeps = [];
    };

    ex_cldr = buildMix rec {
      name = "ex_cldr";
      version = "2.37.5";

      src = fetchHex {
        pkg = "ex_cldr";
        version = "${version}";
        sha256 = "74ad5ddff791112ce4156382e171a5f5d3766af9d5c4675e0571f081fe136479";
      };

      beamDeps = [ cldr_utils decimal gettext jason nimble_parsec ];
    };

    ex_cldr_calendars = buildMix rec {
      name = "ex_cldr_calendars";
      version = "1.22.1";

      src = fetchHex {
        pkg = "ex_cldr_calendars";
        version = "${version}";
        sha256 = "e7408cd9e8318b2ef93b76728e84484ddc3ea6d7c894fbc811c54122a7140169";
      };

      beamDeps = [ ex_cldr_numbers ex_doc jason ];
    };

    ex_cldr_currencies = buildMix rec {
      name = "ex_cldr_currencies";
      version = "2.15.1";

      src = fetchHex {
        pkg = "ex_cldr_currencies";
        version = "${version}";
        sha256 = "31df8bd37688340f8819bdd770eb17d659652078d34db632b85d4a32864d6a25";
      };

      beamDeps = [ ex_cldr jason ];
    };

    ex_cldr_dates_times = buildMix rec {
      name = "ex_cldr_dates_times";
      version = "2.16.0";

      src = fetchHex {
        pkg = "ex_cldr_dates_times";
        version = "${version}";
        sha256 = "0f2f250d479cadda4e0ef3a5e3d936ae7ba1a3f1199db6791e284e86203495b1";
      };

      beamDeps = [ ex_cldr_calendars ex_cldr_numbers jason ];
    };

    ex_cldr_languages = buildMix rec {
      name = "ex_cldr_languages";
      version = "0.3.3";

      src = fetchHex {
        pkg = "ex_cldr_languages";
        version = "${version}";
        sha256 = "22fb1fef72b7b4b4872d243b34e7b83734247a78ad87377986bf719089cc447a";
      };

      beamDeps = [ ex_cldr jason ];
    };

    ex_cldr_numbers = buildMix rec {
      name = "ex_cldr_numbers";
      version = "2.32.3";

      src = fetchHex {
        pkg = "ex_cldr_numbers";
        version = "${version}";
        sha256 = "7b626ff1e59a0ec9c3c5db5ce9ca91a6995e2ab56426b71f3cbf67181ea225f5";
      };

      beamDeps = [ decimal digital_token ex_cldr ex_cldr_currencies jason ];
    };

    ex_cldr_plugs = buildMix rec {
      name = "ex_cldr_plugs";
      version = "1.3.1";

      src = fetchHex {
        pkg = "ex_cldr_plugs";
        version = "${version}";
        sha256 = "4f7b4a5fe061734cef7b62ff29118ed6ac72698cdd7bcfc97495db73611fe0fe";
      };

      beamDeps = [ ex_cldr gettext jason plug ];
    };

    ex_doc = buildMix rec {
      name = "ex_doc";
      version = "0.30.9";

      src = fetchHex {
        pkg = "ex_doc";
        version = "${version}";
        sha256 = "d7aaaf21e95dc5cddabf89063327e96867d00013963eadf2c6ad135506a8bc10";
      };

      beamDeps = [ earmark_parser makeup_elixir makeup_erlang ];
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
      version = "2.7.0";

      src = fetchHex {
        pkg = "ex_machina";
        version = "${version}";
        sha256 = "419aa7a39bde11894c87a615c4ecaa52d8f107bbdd81d810465186f783245bf8";
      };

      beamDeps = [ ecto ecto_sql ];
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
      version = "1.3.0";

      src = fetchHex {
        pkg = "ex_unit_notifier";
        version = "${version}";
        sha256 = "55fffd6062e8d962fc44e8b06fa30a87dc7251ee2a69f520781a3bb29858c365";
      };

      beamDeps = [];
    };

    excoveralls = buildMix rec {
      name = "excoveralls";
      version = "0.18.0";

      src = fetchHex {
        pkg = "excoveralls";
        version = "${version}";
        sha256 = "1109bb911f3cb583401760be49c02cbbd16aed66ea9509fc5479335d284da60b";
      };

      beamDeps = [ castore jason ];
    };

    exgravatar = buildMix rec {
      name = "exgravatar";
      version = "2.0.3";

      src = fetchHex {
        pkg = "exgravatar";
        version = "${version}";
        sha256 = "aca18ff9bd8991d3be3e5446d3bdefc051be084c1ffc9ab2d43b3e65339300e1";
      };

      beamDeps = [];
    };

    expo = buildMix rec {
      name = "expo";
      version = "0.4.1";

      src = fetchHex {
        pkg = "expo";
        version = "${version}";
        sha256 = "2ff7ba7a798c8c543c12550fa0e2cbc81b95d4974c65855d8d15ba7b37a1ce47";
      };

      beamDeps = [];
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
      version = "2.2.0";

      src = fetchHex {
        pkg = "fast_html";
        version = "${version}";
        sha256 = "064c4f23b4a6168f9187dac8984b056f2c531bb0787f559fd6a8b34b38aefbae";
      };

      beamDeps = [ elixir_make nimble_pool ];
    };

    fast_sanitize = buildMix rec {
      name = "fast_sanitize";
      version = "0.2.3";

      src = fetchHex {
        pkg = "fast_sanitize";
        version = "${version}";
        sha256 = "e8ad286d10d0386e15d67d0ee125245ebcfbc7d7290b08712ba9013c8c5e56e2";
      };

      beamDeps = [ fast_html plug ];
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
      version = "0.2.10";

      src = fetchHex {
        pkg = "file_system";
        version = "${version}";
        sha256 = "41195edbfb562a593726eda3b3e8b103a309b733ad25f3d642ba49696bf715dc";
      };

      beamDeps = [];
    };

    floki = buildMix rec {
      name = "floki";
      version = "0.35.2";

      src = fetchHex {
        pkg = "floki";
        version = "${version}";
        sha256 = "6b05289a8e9eac475f644f09c2e4ba7e19201fd002b89c28c1293e7bd16773d9";
      };

      beamDeps = [];
    };

    gen_smtp = buildRebar3 rec {
      name = "gen_smtp";
      version = "1.2.0";

      src = fetchHex {
        pkg = "gen_smtp";
        version = "${version}";
        sha256 = "5ee0375680bca8f20c4d85f58c2894441443a743355430ff33a783fe03296779";
      };

      beamDeps = [ ranch ];
    };

    geo = buildMix rec {
      name = "geo";
      version = "3.6.0";

      src = fetchHex {
        pkg = "geo";
        version = "${version}";
        sha256 = "1dbdebf617183b54bc3c8ad7a36531a9a76ada8ca93f75f573b0ae94006168da";
      };

      beamDeps = [ jason ];
    };

    geo_postgis = buildMix rec {
      name = "geo_postgis";
      version = "3.5.0";

      src = fetchHex {
        pkg = "geo_postgis";
        version = "${version}";
        sha256 = "0bebc5b00f8b11835066bd6213fbeeec03704b4a1c206920b81c1ec2201d185f";
      };

      beamDeps = [ ecto geo jason postgrex ];
    };

    geohax = buildMix rec {
      name = "geohax";
      version = "1.0.0";

      src = fetchHex {
        pkg = "geohax";
        version = "${version}";
        sha256 = "893ef2f905213acb67c615d2c955d926b1be3676bfc2bd5ed7271b641dfa2224";
      };

      beamDeps = [];
    };

    geolix = buildMix rec {
      name = "geolix";
      version = "2.0.0";

      src = fetchHex {
        pkg = "geolix";
        version = "${version}";
        sha256 = "8742bf588ed0bb7def2c443204d09d355990846c6efdff96ded66aac24c301df";
      };

      beamDeps = [];
    };

    geolix_adapter_mmdb2 = buildMix rec {
      name = "geolix_adapter_mmdb2";
      version = "0.6.0";

      src = fetchHex {
        pkg = "geolix_adapter_mmdb2";
        version = "${version}";
        sha256 = "06ff962feae8a310cffdf86b74bfcda6e2d0dccb439bb1f62df2b657b1c0269b";
      };

      beamDeps = [ geolix mmdb2_decoder ];
    };

    gettext = buildMix rec {
      name = "gettext";
      version = "0.23.1";

      src = fetchHex {
        pkg = "gettext";
        version = "${version}";
        sha256 = "19d744a36b809d810d610b57c27b934425859d158ebd56561bc41f7eeb8795db";
      };

      beamDeps = [ expo ];
    };

    guardian = buildMix rec {
      name = "guardian";
      version = "2.3.2";

      src = fetchHex {
        pkg = "guardian";
        version = "${version}";
        sha256 = "b189ff38cd46a22a8a824866a6867ca8722942347f13c33f7d23126af8821b52";
      };

      beamDeps = [ jose plug ];
    };

    guardian_db = buildMix rec {
      name = "guardian_db";
      version = "3.0.0";

      src = fetchHex {
        pkg = "guardian_db";
        version = "${version}";
        sha256 = "9c2ec4278efa34f9f1cc6ba795e552d41fdc7ffba5319d67eeb533b89392d183";
      };

      beamDeps = [ ecto ecto_sql guardian postgrex ];
    };

    guardian_phoenix = buildMix rec {
      name = "guardian_phoenix";
      version = "2.0.1";

      src = fetchHex {
        pkg = "guardian_phoenix";
        version = "${version}";
        sha256 = "21f439246715192b231f228680465d1ed5fbdf01555a4a3b17165532f5f9a08c";
      };

      beamDeps = [ guardian phoenix ];
    };

    hackney = buildRebar3 rec {
      name = "hackney";
      version = "1.20.1";

      src = fetchHex {
        pkg = "hackney";
        version = "${version}";
        sha256 = "fe9094e5f1a2a2c0a7d10918fee36bfec0ec2a979994cff8cfe8058cd9af38e3";
      };

      beamDeps = [ certifi idna metrics mimerl parse_trans ssl_verify_fun unicode_util_compat ];
    };

    hammer = buildMix rec {
      name = "hammer";
      version = "6.1.0";

      src = fetchHex {
        pkg = "hammer";
        version = "${version}";
        sha256 = "b47e415a562a6d072392deabcd58090d8a41182cf9044cdd6b0d0faaaf68ba57";
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

      beamDeps = [];
    };

    html_entities = buildMix rec {
      name = "html_entities";
      version = "0.5.2";

      src = fetchHex {
        pkg = "html_entities";
        version = "${version}";
        sha256 = "c53ba390403485615623b9531e97696f076ed415e8d8058b1dbaa28181f4fdcc";
      };

      beamDeps = [];
    };

    http_signatures = buildMix rec {
      name = "http_signatures";
      version = "0.1.1";

      src = fetchHex {
        pkg = "http_signatures";
        version = "${version}";
        sha256 = "cc3b8a007322cc7b624c0c15eec49ee58ac977254ff529a3c482f681465942a3";
      };

      beamDeps = [];
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
      version = "1.0.4";

      src = fetchHex {
        pkg = "inet_cidr";
        version = "${version}";
        sha256 = "64a2d30189704ae41ca7dbdd587f5291db5d1dda1414e0774c29ffc81088c1bc";
      };

      beamDeps = [];
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
      version = "1.4.1";

      src = fetchHex {
        pkg = "jason";
        version = "${version}";
        sha256 = "fbb01ecdfd565b56261302f7e1fcc27c4fb8f32d56eab74db621fc154604a7a1";
      };

      beamDeps = [ decimal ];
    };

    jose = buildMix rec {
      name = "jose";
      version = "1.11.6";

      src = fetchHex {
        pkg = "jose";
        version = "${version}";
        sha256 = "6275cb75504f9c1e60eeacb771adfeee4905a9e182103aa59b53fed651ff9738";
      };

      beamDeps = [];
    };

    jumper = buildMix rec {
      name = "jumper";
      version = "1.0.2";

      src = fetchHex {
        pkg = "jumper";
        version = "${version}";
        sha256 = "9b7782409021e01ab3c08270e26f36eb62976a38c1aa64b2eaf6348422f165e1";
      };

      beamDeps = [];
    };

    junit_formatter = buildMix rec {
      name = "junit_formatter";
      version = "3.3.1";

      src = fetchHex {
        pkg = "junit_formatter";
        version = "${version}";
        sha256 = "761fc5be4b4c15d8ba91a6dafde0b2c2ae6db9da7b8832a55b5a1deb524da72b";
      };

      beamDeps = [];
    };

    linkify = buildMix rec {
      name = "linkify";
      version = "0.5.3";

      src = fetchHex {
        pkg = "linkify";
        version = "${version}";
        sha256 = "3ef35a1377d47c25506e07c1c005ea9d38d700699d92ee92825f024434258177";
      };

      beamDeps = [];
    };

    makeup = buildMix rec {
      name = "makeup";
      version = "1.1.1";

      src = fetchHex {
        pkg = "makeup";
        version = "${version}";
        sha256 = "5dc62fbdd0de44de194898b6710692490be74baa02d9d108bc29f007783b0b48";
      };

      beamDeps = [ nimble_parsec ];
    };

    makeup_elixir = buildMix rec {
      name = "makeup_elixir";
      version = "0.16.1";

      src = fetchHex {
        pkg = "makeup_elixir";
        version = "${version}";
        sha256 = "e127a341ad1b209bd80f7bd1620a15693a9908ed780c3b763bccf7d200c767c6";
      };

      beamDeps = [ makeup nimble_parsec ];
    };

    makeup_erlang = buildMix rec {
      name = "makeup_erlang";
      version = "0.1.2";

      src = fetchHex {
        pkg = "makeup_erlang";
        version = "${version}";
        sha256 = "f3f5a1ca93ce6e092d92b6d9c049bcda58a3b617a8d888f8e7231c85630e8108";
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

      beamDeps = [];
    };

    metrics = buildRebar3 rec {
      name = "metrics";
      version = "1.0.1";

      src = fetchHex {
        pkg = "metrics";
        version = "${version}";
        sha256 = "69b09adddc4f74a40716ae54d140f93beb0fb8978d8636eaded0c31b6f099f16";
      };

      beamDeps = [];
    };

    mime = buildMix rec {
      name = "mime";
      version = "2.0.5";

      src = fetchHex {
        pkg = "mime";
        version = "${version}";
        sha256 = "da0d64a365c45bc9935cc5c8a7fc5e49a0e0f9932a761c55d6c52b142780a05c";
      };

      beamDeps = [];
    };

    mimerl = buildRebar3 rec {
      name = "mimerl";
      version = "1.2.0";

      src = fetchHex {
        pkg = "mimerl";
        version = "${version}";
        sha256 = "f278585650aa581986264638ebf698f8bb19df297f66ad91b18910dfc6e19323";
      };

      beamDeps = [];
    };

    mimetype_parser = buildMix rec {
      name = "mimetype_parser";
      version = "0.1.3";

      src = fetchHex {
        pkg = "mimetype_parser";
        version = "${version}";
        sha256 = "7d8f80c567807ce78cd93c938e7f4b0a20b1aaaaab914bf286f68457d9f7a852";
      };

      beamDeps = [];
    };

    mix_test_watch = buildMix rec {
      name = "mix_test_watch";
      version = "1.1.1";

      src = fetchHex {
        pkg = "mix_test_watch";
        version = "${version}";
        sha256 = "f82262b54dee533467021723892e15c3267349849f1f737526523ecba4e6baae";
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

      beamDeps = [];
    };

    mock = buildMix rec {
      name = "mock";
      version = "0.3.8";

      src = fetchHex {
        pkg = "mock";
        version = "${version}";
        sha256 = "7fa82364c97617d79bb7d15571193fc0c4fe5afd0c932cef09426b3ee6fe2022";
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

      beamDeps = [];
    };

    mox = buildMix rec {
      name = "mox";
      version = "1.1.0";

      src = fetchHex {
        pkg = "mox";
        version = "${version}";
        sha256 = "d44474c50be02d5b72131070281a5d3895c0e7a95c780e90bc0cfe712f633a13";
      };

      beamDeps = [];
    };

    nimble_csv = buildMix rec {
      name = "nimble_csv";
      version = "1.2.0";

      src = fetchHex {
        pkg = "nimble_csv";
        version = "${version}";
        sha256 = "d0628117fcc2148178b034044c55359b26966c6eaa8e2ce15777be3bbc91b12a";
      };

      beamDeps = [];
    };

    nimble_parsec = buildMix rec {
      name = "nimble_parsec";
      version = "1.4.0";

      src = fetchHex {
        pkg = "nimble_parsec";
        version = "${version}";
        sha256 = "9c565862810fb383e9838c1dd2d7d2c437b3d13b267414ba6af33e50d2d1cf28";
      };

      beamDeps = [];
    };

    nimble_pool = buildMix rec {
      name = "nimble_pool";
      version = "0.2.6";

      src = fetchHex {
        pkg = "nimble_pool";
        version = "${version}";
        sha256 = "1c715055095d3f2705c4e236c18b618420a35490da94149ff8b580a2144f653f";
      };

      beamDeps = [];
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

      beamDeps = [];
    };

    oban = buildMix rec {
      name = "oban";
      version = "2.16.3";

      src = fetchHex {
        pkg = "oban";
        version = "${version}";
        sha256 = "4d8a7fb62f63cf2f2080c78954425f5fd8916ef57196b7f79b5bc657abb2ac5f";
      };

      beamDeps = [ ecto_sql jason postgrex telemetry ];
    };

    paasaa = buildMix rec {
      name = "paasaa";
      version = "0.6.0";

      src = fetchHex {
        pkg = "paasaa";
        version = "${version}";
        sha256 = "732ddfc21bac0831edb26aec468af3ec2b8997d74f6209810b1cc53199c29f2e";
      };

      beamDeps = [];
    };

    parse_trans = buildRebar3 rec {
      name = "parse_trans";
      version = "3.4.1";

      src = fetchHex {
        pkg = "parse_trans";
        version = "${version}";
        sha256 = "620a406ce75dada827b82e453c19cf06776be266f5a67cff34e1ef2cbb60e49a";
      };

      beamDeps = [];
    };

    phoenix = buildMix rec {
      name = "phoenix";
      version = "1.7.10";

      src = fetchHex {
        pkg = "phoenix";
        version = "${version}";
        sha256 = "cf784932e010fd736d656d7fead6a584a4498efefe5b8227e9f383bf15bb79d0";
      };

      beamDeps = [ castore jason phoenix_pubsub phoenix_template phoenix_view plug plug_cowboy plug_crypto telemetry websock_adapter ];
    };

    phoenix_ecto = buildMix rec {
      name = "phoenix_ecto";
      version = "4.4.3";

      src = fetchHex {
        pkg = "phoenix_ecto";
        version = "${version}";
        sha256 = "d36c401206f3011fefd63d04e8ef626ec8791975d9d107f9a0817d426f61ac07";
      };

      beamDeps = [ ecto phoenix_html plug ];
    };

    phoenix_html = buildMix rec {
      name = "phoenix_html";
      version = "3.3.3";

      src = fetchHex {
        pkg = "phoenix_html";
        version = "${version}";
        sha256 = "923ebe6fec6e2e3b3e569dfbdc6560de932cd54b000ada0208b5f45024bdd76c";
      };

      beamDeps = [ plug ];
    };

    phoenix_live_reload = buildMix rec {
      name = "phoenix_live_reload";
      version = "1.4.1";

      src = fetchHex {
        pkg = "phoenix_live_reload";
        version = "${version}";
        sha256 = "9bffb834e7ddf08467fe54ae58b5785507aaba6255568ae22b4d46e2bb3615ab";
      };

      beamDeps = [ file_system phoenix ];
    };

    phoenix_live_view = buildMix rec {
      name = "phoenix_live_view";
      version = "0.20.1";

      src = fetchHex {
        pkg = "phoenix_live_view";
        version = "${version}";
        sha256 = "be494fd1215052729298b0e97d5c2ce8e719c00854b82cd8cf15c1cd7fcf6294";
      };

      beamDeps = [ jason phoenix phoenix_html phoenix_template phoenix_view plug telemetry ];
    };

    phoenix_pubsub = buildMix rec {
      name = "phoenix_pubsub";
      version = "2.1.3";

      src = fetchHex {
        pkg = "phoenix_pubsub";
        version = "${version}";
        sha256 = "bba06bc1dcfd8cb086759f0edc94a8ba2bc8896d5331a1e2c2902bf8e36ee502";
      };

      beamDeps = [];
    };

    phoenix_swoosh = buildMix rec {
      name = "phoenix_swoosh";
      version = "1.2.0";

      src = fetchHex {
        pkg = "phoenix_swoosh";
        version = "${version}";
        sha256 = "e88d117251e89a16b92222415a6d87b99a96747ddf674fc5c7631de734811dba";
      };

      beamDeps = [ hackney phoenix phoenix_html phoenix_view swoosh ];
    };

    phoenix_template = buildMix rec {
      name = "phoenix_template";
      version = "1.0.3";

      src = fetchHex {
        pkg = "phoenix_template";
        version = "${version}";
        sha256 = "16f4b6588a4152f3cc057b9d0c0ba7e82ee23afa65543da535313ad8d25d8e2c";
      };

      beamDeps = [ phoenix_html ];
    };

    phoenix_view = buildMix rec {
      name = "phoenix_view";
      version = "2.0.3";

      src = fetchHex {
        pkg = "phoenix_view";
        version = "${version}";
        sha256 = "cd34049af41be2c627df99cd4eaa71fc52a328c0c3d8e7d4aa28f880c30e7f64";
      };

      beamDeps = [ phoenix_html phoenix_template ];
    };

    plug = buildMix rec {
      name = "plug";
      version = "1.15.2";

      src = fetchHex {
        pkg = "plug";
        version = "${version}";
        sha256 = "02731fa0c2dcb03d8d21a1d941bdbbe99c2946c0db098eee31008e04c6283615";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_cowboy = buildMix rec {
      name = "plug_cowboy";
      version = "2.6.1";

      src = fetchHex {
        pkg = "plug_cowboy";
        version = "${version}";
        sha256 = "de36e1a21f451a18b790f37765db198075c25875c64834bcc82d90b309eb6613";
      };

      beamDeps = [ cowboy cowboy_telemetry plug ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "2.0.0";

      src = fetchHex {
        pkg = "plug_crypto";
        version = "${version}";
        sha256 = "53695bae57cc4e54566d993eb01074e4d894b65a3766f1c43e2c61a1b0f45ea9";
      };

      beamDeps = [];
    };

    poolboy = buildRebar3 rec {
      name = "poolboy";
      version = "1.5.2";

      src = fetchHex {
        pkg = "poolboy";
        version = "${version}";
        sha256 = "dad79704ce5440f3d5a3681c8590b9dc25d1a561e8f5a9c995281012860901e3";
      };

      beamDeps = [];
    };

    postgrex = buildMix rec {
      name = "postgrex";
      version = "0.17.3";

      src = fetchHex {
        pkg = "postgrex";
        version = "${version}";
        sha256 = "946cf46935a4fdca7a81448be76ba3503cff082df42c6ec1ff16a4bdfbfb098d";
      };

      beamDeps = [ db_connection decimal jason ];
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
      version = "1.8.0";

      src = fetchHex {
        pkg = "ranch";
        version = "${version}";
        sha256 = "49fbcfd3682fab1f5d109351b61257676da1a2fdbe295904176d5e521a2ddfe5";
      };

      beamDeps = [];
    };

    remote_ip = buildMix rec {
      name = "remote_ip";
      version = "1.1.0";

      src = fetchHex {
        pkg = "remote_ip";
        version = "${version}";
        sha256 = "616ffdf66aaad6a72fc546dabf42eed87e2a99e97b09cbd92b10cc180d02ed74";
      };

      beamDeps = [ combine plug ];
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
      version = "8.1.0";

      src = fetchHex {
        pkg = "sentry";
        version = "${version}";
        sha256 = "f9fc7641ef61e885510f5e5963c2948b9de1de597c63f781e9d3d6c9c8681ab4";
      };

      beamDeps = [ hackney jason plug plug_cowboy ];
    };

    shortuuid = buildMix rec {
      name = "shortuuid";
      version = "3.0.0";

      src = fetchHex {
        pkg = "shortuuid";
        version = "${version}";
        sha256 = "dfd8f80f514cbb91622cb83f4ac0d6e2f06d98cc6d4aeba94444a212289d0d39";
      };

      beamDeps = [];
    };

    sitemapper = buildMix rec {
      name = "sitemapper";
      version = "0.7.0";

      src = fetchHex {
        pkg = "sitemapper";
        version = "${version}";
        sha256 = "60f7a684e5e9fe7f10ac5b69f48b0be2bcbba995afafcb3c143fc0c8ef1f223f";
      };

      beamDeps = [ xml_builder ];
    };

    sleeplocks = buildRebar3 rec {
      name = "sleeplocks";
      version = "1.1.2";

      src = fetchHex {
        pkg = "sleeplocks";
        version = "${version}";
        sha256 = "9fe5d048c5b781d6305c1a3a0f40bb3dfc06f49bf40571f3d2d0c57eaa7f59a5";
      };

      beamDeps = [];
    };

    slugger = buildMix rec {
      name = "slugger";
      version = "0.3.0";

      src = fetchHex {
        pkg = "slugger";
        version = "${version}";
        sha256 = "20d0ded0e712605d1eae6c5b4889581c3460d92623a930ddda91e0e609b5afba";
      };

      beamDeps = [];
    };

    slugify = buildMix rec {
      name = "slugify";
      version = "1.3.1";

      src = fetchHex {
        pkg = "slugify";
        version = "${version}";
        sha256 = "cb090bbeb056b312da3125e681d98933a360a70d327820e4b7f91645c4d8be76";
      };

      beamDeps = [];
    };

    sobelow = buildMix rec {
      name = "sobelow";
      version = "0.13.0";

      src = fetchHex {
        pkg = "sobelow";
        version = "${version}";
        sha256 = "cd6e9026b85fc35d7529da14f95e85a078d9dd1907a9097b3ba6ac7ebbe34a0d";
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

      beamDeps = [];
    };

    struct_access = buildMix rec {
      name = "struct_access";
      version = "1.1.2";

      src = fetchHex {
        pkg = "struct_access";
        version = "${version}";
        sha256 = "e4c411dcc0226081b95709909551fc92b8feb1a3476108348ea7e3f6c12e586a";
      };

      beamDeps = [];
    };

    sweet_xml = buildMix rec {
      name = "sweet_xml";
      version = "0.7.4";

      src = fetchHex {
        pkg = "sweet_xml";
        version = "${version}";
        sha256 = "e7c4b0bdbf460c928234951def54fe87edf1a170f6896675443279e2dbeba167";
      };

      beamDeps = [];
    };

    swoosh = buildMix rec {
      name = "swoosh";
      version = "1.14.1";

      src = fetchHex {
        pkg = "swoosh";
        version = "${version}";
        sha256 = "87da72260b4351678f96aec61db5c2acc8a88cda2cf2c4f534eb4c9c461350c7";
      };

      beamDeps = [ cowboy gen_smtp hackney jason mime plug plug_cowboy telemetry ];
    };

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "1.2.1";

      src = fetchHex {
        pkg = "telemetry";
        version = "${version}";
        sha256 = "dad9ce9d8effc621708f99eac538ef1cbe05d6a874dd741de2e689c47feafed5";
      };

      beamDeps = [];
    };

    tesla = buildMix rec {
      name = "tesla";
      version = "1.8.0";

      src = fetchHex {
        pkg = "tesla";
        version = "${version}";
        sha256 = "10501f360cd926a309501287470372af1a6e1cbed0f43949203a4c13300bc79f";
      };

      beamDeps = [ castore hackney jason mime telemetry ];
    };

    timex = buildMix rec {
      name = "timex";
      version = "3.7.11";

      src = fetchHex {
        pkg = "timex";
        version = "${version}";
        sha256 = "8b9024f7efbabaf9bd7aa04f65cf8dcd7c9818ca5737677c7b76acbc6a94d1aa";
      };

      beamDeps = [ combine gettext tzdata ];
    };

    tls_certificate_check = buildRebar3 rec {
      name = "tls_certificate_check";
      version = "1.20.0";

      src = fetchHex {
        pkg = "tls_certificate_check";
        version = "${version}";
        sha256 = "ab57b74b1a63dc5775650699a3ec032ec0065005eff1f020818742b7312a8426";
      };

      beamDeps = [ ssl_verify_fun ];
    };

    tz_world = buildMix rec {
      name = "tz_world";
      version = "1.3.1";

      src = fetchHex {
        pkg = "tz_world";
        version = "${version}";
        sha256 = "901ed2b4a4430ecab3765244da4a19e6f19141867c2ab3753924919b87ed2224";
      };

      beamDeps = [ castore certifi geo jason ];
    };

    tzdata = buildMix rec {
      name = "tzdata";
      version = "1.1.1";

      src = fetchHex {
        pkg = "tzdata";
        version = "${version}";
        sha256 = "a69cec8352eafcd2e198dea28a34113b60fdc6cb57eb5ad65c10292a6ba89787";
      };

      beamDeps = [ hackney ];
    };

    ueberauth = buildMix rec {
      name = "ueberauth";
      version = "0.10.5";

      src = fetchHex {
        pkg = "ueberauth";
        version = "${version}";
        sha256 = "3efd1f31d490a125c7ed453b926f7c31d78b97b8a854c755f5c40064bf3ac9e1";
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

      beamDeps = [ httpoison sweet_xml ueberauth ];
    };

    ueberauth_discord = buildMix rec {
      name = "ueberauth_discord";
      version = "0.7.0";

      src = fetchHex {
        pkg = "ueberauth_discord";
        version = "${version}";
        sha256 = "d6f98ef91abb4ddceada4b7acba470e0e68c4d2de9735ff2f24172a8e19896b4";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_facebook = buildMix rec {
      name = "ueberauth_facebook";
      version = "0.10.0";

      src = fetchHex {
        pkg = "ueberauth_facebook";
        version = "${version}";
        sha256 = "bf8ce5d66b1c50da8abff77e8086c1b710bdde63f4acaef19a651ba43a9537a8";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_github = buildMix rec {
      name = "ueberauth_github";
      version = "0.8.3";

      src = fetchHex {
        pkg = "ueberauth_github";
        version = "${version}";
        sha256 = "ae0ab2879c32cfa51d7287a48219b262bfdab0b7ec6629f24160564247493cc6";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_gitlab_strategy = buildMix rec {
      name = "ueberauth_gitlab_strategy";
      version = "0.4.0";

      src = fetchHex {
        pkg = "ueberauth_gitlab_strategy";
        version = "${version}";
        sha256 = "e86e2e794bb063c07c05a6b1301b73f2be3ba9308d8f47ecc4d510ef9226091e";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_google = buildMix rec {
      name = "ueberauth_google";
      version = "0.12.1";

      src = fetchHex {
        pkg = "ueberauth_google";
        version = "${version}";
        sha256 = "7f7deacd679b2b66e3bffb68ecc77aa1b5396a0cbac2941815f253128e458c38";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_keycloak_strategy = buildMix rec {
      name = "ueberauth_keycloak_strategy";
      version = "0.4.0";

      src = fetchHex {
        pkg = "ueberauth_keycloak_strategy";
        version = "${version}";
        sha256 = "c03027937bddcbd9ff499e457f9bb05f79018fa321abf79ebcfed2af0007211b";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_twitter = buildMix rec {
      name = "ueberauth_twitter";
      version = "0.4.1";

      src = fetchHex {
        pkg = "ueberauth_twitter";
        version = "${version}";
        sha256 = "83ca8ea3e1a3f976f1adbebfb323b9ebf53af453fbbf57d0486801a303b16065";
      };

      beamDeps = [ httpoison oauther ueberauth ];
    };

    unicode_util_compat = buildRebar3 rec {
      name = "unicode_util_compat";
      version = "0.7.0";

      src = fetchHex {
        pkg = "unicode_util_compat";
        version = "${version}";
        sha256 = "25eee6d67df61960cf6a794239566599b09e17e668d3700247bc498638152521";
      };

      beamDeps = [];
    };

    unplug = buildMix rec {
      name = "unplug";
      version = "1.0.0";

      src = fetchHex {
        pkg = "unplug";
        version = "${version}";
        sha256 = "d171a85758aa412d4e85b809c203e1b1c4c76a4d6ab58e68dc9a8a8acd9b7c3a";
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

      beamDeps = [];
    };

    vite_phx = buildMix rec {
      name = "vite_phx";
      version = "0.3.1";

      src = fetchHex {
        pkg = "vite_phx";
        version = "${version}";
        sha256 = "08b1726094a131490ff0a2c7764c4cdd4b5cdf8ba9762638a5dd4bcd9e5fc936";
      };

      beamDeps = [ jason phoenix ];
    };

    websock = buildMix rec {
      name = "websock";
      version = "0.5.3";

      src = fetchHex {
        pkg = "websock";
        version = "${version}";
        sha256 = "6105453d7fac22c712ad66fab1d45abdf049868f253cf719b625151460b8b453";
      };

      beamDeps = [];
    };

    websock_adapter = buildMix rec {
      name = "websock_adapter";
      version = "0.5.5";

      src = fetchHex {
        pkg = "websock_adapter";
        version = "${version}";
        sha256 = "4b977ba4a01918acbf77045ff88de7f6972c2a009213c515a445c48f224ffce9";
      };

      beamDeps = [ plug plug_cowboy websock ];
    };

    xml_builder = buildMix rec {
      name = "xml_builder";
      version = "2.2.0";

      src = fetchHex {
        pkg = "xml_builder";
        version = "${version}";
        sha256 = "9d66d52fb917565d358166a4314078d39ef04d552904de96f8e73f68f64a62c9";
      };

      beamDeps = [];
    };
  };
in self

