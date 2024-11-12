{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    accept = buildRebar3 rec {
      name = "accept";
      version = "0.3.5";

      src = fetchHex {
        pkg = "accept";
        version = "${version}";
        sha256 = "11b18c220bcc2eab63b5470c038ef10eb6783bcb1fcdb11aa4137defa5ac1bb8";
      };

      beamDeps = [];
    };

    bandit = buildMix rec {
      name = "bandit";
      version = "1.5.5";

      src = fetchHex {
        pkg = "bandit";
        version = "${version}";
        sha256 = "f21579a29ea4bc08440343b2b5f16f7cddf2fea5725d31b72cf973ec729079e1";
      };

      beamDeps = [ hpax plug telemetry thousand_island websock ];
    };

    base62 = buildMix rec {
      name = "base62";
      version = "1.2.2";

      src = fetchHex {
        pkg = "base62";
        version = "${version}";
        sha256 = "d41336bda8eaa5be197f1e4592400513ee60518e5b9f4dcf38f4b4dae6f377bb";
      };

      beamDeps = [ custom_base ];
    };

    bbcode_pleroma = buildMix rec {
      name = "bbcode_pleroma";
      version = "0.2.0";

      src = fetchHex {
        pkg = "bbcode_pleroma";
        version = "${version}";
        sha256 = "19851074419a5fedb4ef49e1f01b30df504bb5dbb6d6adfc135238063bebd1c3";
      };

      beamDeps = [ nimble_parsec ];
    };

    bcrypt_elixir = buildMix rec {
      name = "bcrypt_elixir";
      version = "2.3.1";

      src = fetchHex {
        pkg = "bcrypt_elixir";
        version = "${version}";
        sha256 = "42182d5f46764def15bf9af83739e3bf4ad22661b1c34fc3e88558efced07279";
      };

      beamDeps = [ comeonin elixir_make ];
    };

    benchee = buildMix rec {
      name = "benchee";
      version = "1.3.0";

      src = fetchHex {
        pkg = "benchee";
        version = "${version}";
        sha256 = "34f4294068c11b2bd2ebf2c59aac9c7da26ffa0068afdf3419f1b176e16c5f81";
      };

      beamDeps = [ deep_merge statistex ];
    };

    blurhash = buildMix rec {
      name = "blurhash";
      version = "0.1.0";

      src = fetchHex {
        pkg = "rinpatch_blurhash";
        version = "${version}";
        sha256 = "19911a5dcbb0acb9710169a72f702bce6cb048822b12de566ccd82b2cc42b907";
      };

      beamDeps = [ mogrify ];
    };

    bunt = buildMix rec {
      name = "bunt";
      version = "1.0.0";

      src = fetchHex {
        pkg = "bunt";
        version = "${version}";
        sha256 = "dc5f86aa08a5f6fa6b8096f0735c4e76d54ae5c9fa2c143e5a1fc7c1cd9bb6b5";
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

    calendar = buildMix rec {
      name = "calendar";
      version = "1.0.0";

      src = fetchHex {
        pkg = "calendar";
        version = "${version}";
        sha256 = "990e9581920c82912a5ee50e62ff5ef96da6b15949a2ee4734f935fdef0f0a6f";
      };

      beamDeps = [ tzdata ];
    };

    castore = buildMix rec {
      name = "castore";
      version = "0.1.22";

      src = fetchHex {
        pkg = "castore";
        version = "${version}";
        sha256 = "c17576df47eb5aa1ee40cc4134316a99f5cad3e215d5c77b8dd3cfef12a22cac";
      };

      beamDeps = [];
    };

    cc_precompiler = buildMix rec {
      name = "cc_precompiler";
      version = "0.1.9";

      src = fetchHex {
        pkg = "cc_precompiler";
        version = "${version}";
        sha256 = "9dcab3d0f3038621f1601f13539e7a9ee99843862e66ad62827b0c42b2f58a54";
      };

      beamDeps = [ elixir_make ];
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

    concurrent_limiter = buildMix rec {
      name = "concurrent_limiter";
      version = "0.1.1";

      src = fetchHex {
        pkg = "concurrent_limiter";
        version = "${version}";
        sha256 = "53968ff238c0fbb4d7ed76ddb1af0be6f3b2f77909f6796e249e737c505a16eb";
      };

      beamDeps = [ telemetry ];
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
      version = "2.0.3";

      src = fetchHex {
        pkg = "cors_plug";
        version = "${version}";
        sha256 = "ee4ae1418e6ce117fc42c2ba3e6cbdca4e95ecd2fe59a05ec6884ca16d469aea";
      };

      beamDeps = [ plug ];
    };

    covertool = buildRebar3 rec {
      name = "covertool";
      version = "2.0.6";

      src = fetchHex {
        pkg = "covertool";
        version = "${version}";
        sha256 = "5db3fcd82180d8ea4ad857d4d1ab21a8d31b5aee0d60d2f6c0f9e25a411d1e21";
      };

      beamDeps = [];
    };

    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.12.0";

      src = fetchHex {
        pkg = "cowboy";
        version = "${version}";
        sha256 = "8a7abe6d183372ceb21caa2709bec928ab2b72e18a3911aa1771639bef82651e";
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
      version = "2.13.0";

      src = fetchHex {
        pkg = "cowlib";
        version = "${version}";
        sha256 = "e1e1284dc3fc030a64b1ad0d8382ae7e99da46c3246b815318a4b848873800a4";
      };

      beamDeps = [];
    };

    credo = buildMix rec {
      name = "credo";
      version = "1.7.3";

      src = fetchHex {
        pkg = "credo";
        version = "${version}";
        sha256 = "35ea675a094c934c22fb1dca3696f3c31f2728ae6ef5a53b5d648c11180a4535";
      };

      beamDeps = [ bunt file_system jason ];
    };

    crontab = buildMix rec {
      name = "crontab";
      version = "1.1.8";

      src = fetchHex {
        pkg = "crontab";
        version = "${version}";
        sha256 = "1gkb7ps38j789acj8dw2q7jnhhw43idyvh36fb3i52yjkhli7ra8";
      };

      beamDeps = [ ecto ];
    };

    custom_base = buildMix rec {
      name = "custom_base";
      version = "0.2.1";

      src = fetchHex {
        pkg = "custom_base";
        version = "${version}";
        sha256 = "8df019facc5ec9603e94f7270f1ac73ddf339f56ade76a721eaa57c1493ba463";
      };

      beamDeps = [];
    };

    db_connection = buildMix rec {
      name = "db_connection";
      version = "2.7.0";

      src = fetchHex {
        pkg = "db_connection";
        version = "${version}";
        sha256 = "dcf08f31b2701f857dfc787fbad78223d61a32204f217f15e881dd93e4bdd3ff";
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

    deep_merge = buildMix rec {
      name = "deep_merge";
      version = "1.0.0";

      src = fetchHex {
        pkg = "deep_merge";
        version = "${version}";
        sha256 = "ce708e5f094b9cd4e8f2be4f00d2f4250c4095be93f8cd6d018c753894885430";
      };

      beamDeps = [];
    };

    dialyxir = buildMix rec {
      name = "dialyxir";
      version = "1.4.3";

      src = fetchHex {
        pkg = "dialyxir";
        version = "${version}";
        sha256 = "bf2cfb75cd5c5006bec30141b131663299c661a864ec7fbbc72dfa557487a986";
      };

      beamDeps = [ erlex ];
    };

    earmark = buildMix rec {
      name = "earmark";
      version = "1.4.46";

      src = fetchHex {
        pkg = "earmark";
        version = "${version}";
        sha256 = "798d86db3d79964e759ddc0c077d5eb254968ed426399fbf5a62de2b5ff8910a";
      };

      beamDeps = [];
    };

    earmark_parser = buildMix rec {
      name = "earmark_parser";
      version = "1.4.39";

      src = fetchHex {
        pkg = "earmark_parser";
        version = "${version}";
        sha256 = "06553a88d1f1846da9ef066b87b57c6f605552cfbe40d20bd8d59cc6bde41944";
      };

      beamDeps = [];
    };

    ecto = buildMix rec {
      name = "ecto";
      version = "3.11.2";

      src = fetchHex {
        pkg = "ecto";
        version = "${version}";
        sha256 = "3c38bca2c6f8d8023f2145326cc8a80100c3ffe4dcbd9842ff867f7fc6156c65";
      };

      beamDeps = [ decimal jason telemetry ];
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

    ecto_psql_extras = buildMix rec {
      name = "ecto_psql_extras";
      version = "0.7.15";

      src = fetchHex {
        pkg = "ecto_psql_extras";
        version = "${version}";
        sha256 = "b6127f3a5c6fc3d84895e4768cc7c199f22b48b67d6c99b13fbf4a374e73f039";
      };

      beamDeps = [ ecto_sql postgrex table_rex ];
    };

    ecto_sql = buildMix rec {
      name = "ecto_sql";
      version = "3.11.3";

      src = fetchHex {
        pkg = "ecto_sql";
        version = "${version}";
        sha256 = "e5f36e3d736b99c7fee3e631333b8394ade4bafe9d96d35669fca2d81c2be928";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
    };

    eimp = buildRebar3 rec {
      name = "eimp";
      version = "1.0.14";

      src = fetchHex {
        pkg = "eimp";
        version = "${version}";
        sha256 = "501133f3112079b92d9e22da8b88bf4f0e13d4d67ae9c15c42c30bd25ceb83b6";
      };

      beamDeps = [ p1_utils ];
    };

    elixir_make = buildMix rec {
      name = "elixir_make";
      version = "0.7.8";

      src = fetchHex {
        pkg = "elixir_make";
        version = "${version}";
        sha256 = "7a71945b913d37ea89b06966e1342c85cfe549b15e6d6d081e8081c493062c07";
      };

      beamDeps = [ castore certifi ];
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

    esbuild = buildMix rec {
      name = "esbuild";
      version = "0.5.0";

      src = fetchHex {
        pkg = "esbuild";
        version = "${version}";
        sha256 = "f183a0b332d963c4cfaf585477695ea59eef9a6f2204fdd0efa00e099694ffe5";
      };

      beamDeps = [ castore ];
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

    ex_aws = buildMix rec {
      name = "ex_aws";
      version = "2.1.9";

      src = fetchHex {
        pkg = "ex_aws";
        version = "${version}";
        sha256 = "3e6c776703c9076001fbe1f7c049535f042cb2afa0d2cbd3b47cbc4e92ac0d10";
      };

      beamDeps = [ hackney jason sweet_xml ];
    };

    ex_aws_s3 = buildMix rec {
      name = "ex_aws_s3";
      version = "2.5.3";

      src = fetchHex {
        pkg = "ex_aws_s3";
        version = "${version}";
        sha256 = "4f09dd372cc386550e484808c5ac5027766c8d0cd8271ccc578b82ee6ef4f3b8";
      };

      beamDeps = [ ex_aws sweet_xml ];
    };

    ex_const = buildMix rec {
      name = "ex_const";
      version = "0.2.4";

      src = fetchHex {
        pkg = "ex_const";
        version = "${version}";
        sha256 = "96fd346610cc992b8f896ed26a98be82ac4efb065a0578f334a32d60a3ba9767";
      };

      beamDeps = [];
    };

    ex_doc = buildMix rec {
      name = "ex_doc";
      version = "0.31.1";

      src = fetchHex {
        pkg = "ex_doc";
        version = "${version}";
        sha256 = "3178c3a407c557d8343479e1ff117a96fd31bafe52a039079593fb0524ef61b0";
      };

      beamDeps = [ earmark_parser makeup_elixir makeup_erlang ];
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

    ex_syslogger = buildMix rec {
      name = "ex_syslogger";
      version = "1.5.2";

      src = fetchHex {
        pkg = "ex_syslogger";
        version = "${version}";
        sha256 = "ab9fab4136dbc62651ec6f16fa4842f10cf02ab4433fa3d0976c01be99398399";
      };

      beamDeps = [ poison syslog ];
    };

    exile = buildMix rec {
      name = "exile";
      version = "0.10.0";

      src = fetchHex {
        pkg = "exile";
        version = "${version}";
        sha256 = "c62ee8fee565b5ac4a898d0dcd58d2b04fb5eec1655af1ddcc9eb582c6732c33";
      };

      beamDeps = [ elixir_make ];
    };

    expo = buildMix rec {
      name = "expo";
      version = "0.5.1";

      src = fetchHex {
        pkg = "expo";
        version = "${version}";
        sha256 = "68a4233b0658a3d12ee00d27d37d856b1ba48607e7ce20fd376958d0ba6ce92b";
      };

      beamDeps = [];
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

    finch = buildMix rec {
      name = "finch";
      version = "0.18.0";

      src = fetchHex {
        pkg = "finch";
        version = "${version}";
        sha256 = "69f5045b042e531e53edc2574f15e25e735b522c37e2ddb766e15b979e03aa65";
      };

      beamDeps = [ castore mime mint nimble_options nimble_pool telemetry ];
    };

    flake_id = buildMix rec {
      name = "flake_id";
      version = "0.1.0";

      src = fetchHex {
        pkg = "flake_id";
        version = "${version}";
        sha256 = "31fc8090fde1acd267c07c36ea7365b8604055f897d3a53dd967658c691bd827";
      };

      beamDeps = [ base62 ecto ];
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
      version = "0.15.0";

      src = fetchHex {
        pkg = "gen_smtp";
        version = "${version}";
        sha256 = "29bd14a88030980849c7ed2447b8db6d6c9278a28b11a44cafe41b791205440f";
      };

      beamDeps = [];
    };

    gettext = buildMix rec {
      name = "gettext";
      version = "0.24.0";

      src = fetchHex {
        pkg = "gettext";
        version = "${version}";
        sha256 = "bdf75cdfcbe9e4622dd18e034b227d77dd17f0f133853a1c73b97b3d6c770e8b";
      };

      beamDeps = [ expo ];
    };

    gun = buildRebar3 rec {
      name = "gun";
      version = "2.0.1";

      src = fetchHex {
        pkg = "gun";
        version = "${version}";
        sha256 = "a10bc8d6096b9502205022334f719cc9a08d9adcfbfc0dbee9ef31b56274a20b";
      };

      beamDeps = [ cowlib ];
    };

    hackney = buildRebar3 rec {
      name = "hackney";
      version = "1.18.2";

      src = fetchHex {
        pkg = "hackney";
        version = "${version}";
        sha256 = "af94d5c9f97857db257090a4a10e5426ecb6f4918aa5cc666798566ae14b65fd";
      };

      beamDeps = [ certifi idna metrics mimerl parse_trans ssl_verify_fun unicode_util_compat ];
    };

    hpax = buildMix rec {
      name = "hpax";
      version = "0.2.0";

      src = fetchHex {
        pkg = "hpax";
        version = "${version}";
        sha256 = "bea06558cdae85bed075e6c036993d43cd54d447f76d8190a8db0dc5893fa2f1";
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
      version = "0.1.2";

      src = fetchHex {
        pkg = "http_signatures";
        version = "${version}";
        sha256 = "f08aa9ac121829dae109d608d83c84b940ef2f183ae50f2dd1e9a8bc619d8be7";
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
      version = "1.0.8";

      src = fetchHex {
        pkg = "inet_cidr";
        version = "${version}";
        sha256 = "d5b26da66603bb56c933c65214c72152f0de9a6ea53618b56d63302a68f6a90e";
      };

      beamDeps = [];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.4.3";

      src = fetchHex {
        pkg = "jason";
        version = "${version}";
        sha256 = "9a90e868927f7c777689baa16d86f4d0e086d968db5c05d917ccff6d443e58a3";
      };

      beamDeps = [ decimal ];
    };

    joken = buildMix rec {
      name = "joken";
      version = "2.6.0";

      src = fetchHex {
        pkg = "joken";
        version = "${version}";
        sha256 = "5a95b05a71cd0b54abd35378aeb1d487a23a52c324fa7efdffc512b655b5aaa7";
      };

      beamDeps = [ jose ];
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

    logger_backends = buildMix rec {
      name = "logger_backends";
      version = "1.0.0";

      src = fetchHex {
        pkg = "logger_backends";
        version = "${version}";
        sha256 = "1faceb3e7ec3ef66a8f5746c5afd020e63996df6fd4eb8cdb789e5665ae6c9ce";
      };

      beamDeps = [];
    };

    majic = buildMix rec {
      name = "majic";
      version = "1.0.0";

      src = fetchHex {
        pkg = "majic";
        version = "${version}";
        sha256 = "7905858f76650d49695f14ea55cd9aaaee0c6654fa391671d4cf305c275a0a9e";
      };

      beamDeps = [ elixir_make mime nimble_pool plug ];
    };

    makeup = buildMix rec {
      name = "makeup";
      version = "1.0.5";

      src = fetchHex {
        pkg = "makeup";
        version = "${version}";
        sha256 = "cfa158c02d3f5c0c665d0af11512fed3fba0144cf1aadee0f2ce17747fba2ca9";
      };

      beamDeps = [ nimble_parsec ];
    };

    makeup_elixir = buildMix rec {
      name = "makeup_elixir";
      version = "0.14.1";

      src = fetchHex {
        pkg = "makeup_elixir";
        version = "${version}";
        sha256 = "f2438b1a80eaec9ede832b5c41cd4f373b38fd7aa33e3b22d9db79e640cbde11";
      };

      beamDeps = [ makeup ];
    };

    makeup_erlang = buildMix rec {
      name = "makeup_erlang";
      version = "0.1.3";

      src = fetchHex {
        pkg = "makeup_erlang";
        version = "${version}";
        sha256 = "b78dc853d2e670ff6390b605d807263bf606da3c82be37f9d7f68635bd886fc9";
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
      version = "1.6.0";

      src = fetchHex {
        pkg = "mime";
        version = "${version}";
        sha256 = "31a1a8613f8321143dde1dafc36006a17d28d02bdfecb9e95a880fa7aabd19a7";
      };

      beamDeps = [];
    };

    mimerl = buildRebar3 rec {
      name = "mimerl";
      version = "1.3.0";

      src = fetchHex {
        pkg = "mimerl";
        version = "${version}";
        sha256 = "a1e15a50d1887217de95f0b9b0793e32853f7c258a5cd227650889b38839fe9d";
      };

      beamDeps = [];
    };

    mint = buildMix rec {
      name = "mint";
      version = "1.6.1";

      src = fetchHex {
        pkg = "mint";
        version = "${version}";
        sha256 = "4fc518dcc191d02f433393a72a7ba3f6f94b101d094cb6bf532ea54c89423780";
      };

      beamDeps = [ castore hpax ];
    };

    mochiweb = buildRebar3 rec {
      name = "mochiweb";
      version = "2.18.0";

      src = fetchHex {
        pkg = "mochiweb";
        version = "${version}";
        sha256 = "16j8cfn3hq0g474xc5xl8nk2v46hwvwpfwi9rkzavnsbaqg2ngmr";
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
      version = "0.8.0";

      src = fetchHex {
        pkg = "mogrify";
        version = "${version}";
        sha256 = "2278d245f07056ea3b586e98801e933695147066fa4cf563f552c1b4f0ff8ad9";
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

    nimble_options = buildMix rec {
      name = "nimble_options";
      version = "1.1.1";

      src = fetchHex {
        pkg = "nimble_options";
        version = "${version}";
        sha256 = "821b2470ca9442c4b6984882fe9bb0389371b8ddec4d45a9504f00a66f650b44";
      };

      beamDeps = [];
    };

    nimble_parsec = buildMix rec {
      name = "nimble_parsec";
      version = "0.6.0";

      src = fetchHex {
        pkg = "nimble_parsec";
        version = "${version}";
        sha256 = "27eac315a94909d4dc68bc07a4a83e06c8379237c5ea528a9acff4ca1c873c52";
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

    oban = buildMix rec {
      name = "oban";
      version = "2.17.12";

      src = fetchHex {
        pkg = "oban";
        version = "${version}";
        sha256 = "7a647d6cd6bb300073db17faabce22d80ae135da3baf3180a064fa7c4fa046e3";
      };

      beamDeps = [ ecto_sql jason postgrex telemetry ];
    };

    oban_live_dashboard = buildMix rec {
      name = "oban_live_dashboard";
      version = "0.1.1";

      src = fetchHex {
        pkg = "oban_live_dashboard";
        version = "${version}";
        sha256 = "16dc4ce9c9a95aa2e655e35ed4e675652994a8def61731a18af85e230e1caa63";
      };

      beamDeps = [ oban phoenix_live_dashboard ];
    };

    octo_fetch = buildMix rec {
      name = "octo_fetch";
      version = "0.4.0";

      src = fetchHex {
        pkg = "octo_fetch";
        version = "${version}";
        sha256 = "cf8be6f40cd519d7000bb4e84adcf661c32e59369ca2827c4e20042eda7a7fc6";
      };

      beamDeps = [ castore ssl_verify_fun ];
    };

    open_api_spex = buildMix rec {
      name = "open_api_spex";
      version = "3.18.2";

      src = fetchHex {
        pkg = "open_api_spex";
        version = "${version}";
        sha256 = "aa3e6dcfc0ad6a02596b2172662da21c9dd848dac145ea9e603f54e3d81b8d2b";
      };

      beamDeps = [ jason plug poison ];
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

    pbkdf2_elixir = buildMix rec {
      name = "pbkdf2_elixir";
      version = "1.2.1";

      src = fetchHex {
        pkg = "pbkdf2_elixir";
        version = "${version}";
        sha256 = "d3b40a4a4630f0b442f19eca891fcfeeee4c40871936fed2f68e1c4faa30481f";
      };

      beamDeps = [ comeonin ];
    };

    phoenix = buildMix rec {
      name = "phoenix";
      version = "1.7.14";

      src = fetchHex {
        pkg = "phoenix";
        version = "${version}";
        sha256 = "c7859bc56cc5dfef19ecfc240775dae358cbaa530231118a9e014df392ace61a";
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
      version = "3.3.4";

      src = fetchHex {
        pkg = "phoenix_html";
        version = "${version}";
        sha256 = "0249d3abec3714aff3415e7ee3d9786cb325be3151e6c4b3021502c585bf53fb";
      };

      beamDeps = [ plug ];
    };

    phoenix_live_dashboard = buildMix rec {
      name = "phoenix_live_dashboard";
      version = "0.8.3";

      src = fetchHex {
        pkg = "phoenix_live_dashboard";
        version = "${version}";
        sha256 = "f9470a0a8bae4f56430a23d42f977b5a6205fdba6559d76f932b876bfaec652d";
      };

      beamDeps = [ ecto ecto_psql_extras mime phoenix_live_view telemetry_metrics ];
    };

    phoenix_live_reload = buildMix rec {
      name = "phoenix_live_reload";
      version = "1.3.3";

      src = fetchHex {
        pkg = "phoenix_live_reload";
        version = "${version}";
        sha256 = "766796676e5f558dbae5d1bdb066849673e956005e3730dfd5affd7a6da4abac";
      };

      beamDeps = [ file_system phoenix ];
    };

    phoenix_live_view = buildMix rec {
      name = "phoenix_live_view";
      version = "0.19.5";

      src = fetchHex {
        pkg = "phoenix_live_view";
        version = "${version}";
        sha256 = "b2eaa0dd3cfb9bd7fb949b88217df9f25aed915e986a28ad5c8a0d054e7ca9d3";
      };

      beamDeps = [ jason phoenix phoenix_html phoenix_template phoenix_view telemetry ];
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
      version = "1.2.1";

      src = fetchHex {
        pkg = "phoenix_swoosh";
        version = "${version}";
        sha256 = "4000eeba3f9d7d1a6bf56d2bd56733d5cadf41a7f0d8ffe5bb67e7d667e204a2";
      };

      beamDeps = [ finch hackney phoenix phoenix_html phoenix_view swoosh ];
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

      beamDeps = [ phoenix_html phoenix_template ];
    };

    plug = buildMix rec {
      name = "plug";
      version = "1.16.1";

      src = fetchHex {
        pkg = "plug";
        version = "${version}";
        sha256 = "a13ff6b9006b03d7e33874945b2755253841b238c34071ed85b0e86057f8cddc";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_cowboy = buildMix rec {
      name = "plug_cowboy";
      version = "2.7.1";

      src = fetchHex {
        pkg = "plug_cowboy";
        version = "${version}";
        sha256 = "02dbd5f9ab571b864ae39418db7811618506256f6d13b4a45037e5fe78dc5de3";
      };

      beamDeps = [ cowboy cowboy_telemetry plug ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "2.1.0";

      src = fetchHex {
        pkg = "plug_crypto";
        version = "${version}";
        sha256 = "131216a4b030b8f8ce0f26038bc4421ae60e4bb95c5cf5395e1421437824c4fa";
      };

      beamDeps = [];
    };

    plug_static_index_html = buildMix rec {
      name = "plug_static_index_html";
      version = "1.0.0";

      src = fetchHex {
        pkg = "plug_static_index_html";
        version = "${version}";
        sha256 = "79fd4fcf34d110605c26560cbae8f23c603ec4158c08298bd4360fdea90bb5cf";
      };

      beamDeps = [ plug ];
    };

    poison = buildMix rec {
      name = "poison";
      version = "3.1.0";

      src = fetchHex {
        pkg = "poison";
        version = "${version}";
        sha256 = "fec8660eb7733ee4117b85f55799fd3833eb769a6df71ccf8903e8dc5447cfce";
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
      version = "0.17.5";

      src = fetchHex {
        pkg = "postgrex";
        version = "${version}";
        sha256 = "50b8b11afbb2c4095a3ba675b4f055c416d0f3d7de6633a595fc131a828a67eb";
      };

      beamDeps = [ db_connection decimal jason ];
    };

    pot = buildRebar3 rec {
      name = "pot";
      version = "1.0.2";

      src = fetchHex {
        pkg = "pot";
        version = "${version}";
        sha256 = "78fe127f5a4f5f919d6ea5a2a671827bd53eb9d37e5b4128c0ad3df99856c2e0";
      };

      beamDeps = [];
    };

    prom_ex = buildMix rec {
      name = "prom_ex";
      version = "1.9.0";

      src = fetchHex {
        pkg = "prom_ex";
        version = "${version}";
        sha256 = "01f3d4f69ec93068219e686cc65e58a29c42bea5429a8ff4e2121f19db178ee6";
      };

      beamDeps = [ ecto finch jason oban octo_fetch phoenix phoenix_live_view plug plug_cowboy telemetry telemetry_metrics telemetry_metrics_prometheus_core telemetry_poller ];
    };

    prometheus = buildMix rec {
      name = "prometheus";
      version = "4.10.0";

      src = fetchHex {
        pkg = "prometheus";
        version = "${version}";
        sha256 = "2a99bb6dce85e238c7236fde6b0064f9834dc420ddbd962aac4ea2a3c3d59384";
      };

      beamDeps = [ quantile_estimator ];
    };

    prometheus_ecto = buildMix rec {
      name = "prometheus_ecto";
      version = "1.4.3";

      src = fetchHex {
        pkg = "prometheus_ecto";
        version = "${version}";
        sha256 = "8d66289f77f913b37eda81fd287340c17e61a447549deb28efc254532b2bed82";
      };

      beamDeps = [ ecto prometheus_ex ];
    };

    prometheus_plugs = buildMix rec {
      name = "prometheus_plugs";
      version = "1.1.5";

      src = fetchHex {
        pkg = "prometheus_plugs";
        version = "${version}";
        sha256 = "0273a6483ccb936d79ca19b0ab629aef0dba958697c94782bb728b920dfc6a79";
      };

      beamDeps = [ accept plug prometheus_ex ];
    };

    quantile_estimator = buildRebar3 rec {
      name = "quantile_estimator";
      version = "0.2.1";

      src = fetchHex {
        pkg = "quantile_estimator";
        version = "${version}";
        sha256 = "282a8a323ca2a845c9e6f787d166348f776c1d4a41ede63046d72d422e3da946";
      };

      beamDeps = [];
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

    recon = buildMix rec {
      name = "recon";
      version = "2.5.4";

      src = fetchHex {
        pkg = "recon";
        version = "${version}";
        sha256 = "e9ab01ac7fc8572e41eb59385efeb3fb0ff5bf02103816535bacaedf327d0263";
      };

      beamDeps = [];
    };

    rustler = buildMix rec {
      name = "rustler";
      version = "0.30.0";

      src = fetchHex {
        pkg = "rustler";
        version = "${version}";
        sha256 = "9ef1abb6a7dda35c47cfc649e6a5a61663af6cf842a55814a554a84607dee389";
      };

      beamDeps = [ jason toml ];
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

    statistex = buildMix rec {
      name = "statistex";
      version = "1.0.0";

      src = fetchHex {
        pkg = "statistex";
        version = "${version}";
        sha256 = "ff9d8bee7035028ab4742ff52fc80a2aa35cece833cf5319009b52f1b5a86c27";
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
      version = "1.16.9";

      src = fetchHex {
        pkg = "swoosh";
        version = "${version}";
        sha256 = "878b1a7a6c10ebbf725a3349363f48f79c5e3d792eb621643b0d276a38acc0a6";
      };

      beamDeps = [ bandit cowboy ex_aws finch gen_smtp hackney jason mime plug plug_cowboy telemetry ];
    };

    syslog = buildRebar3 rec {
      name = "syslog";
      version = "1.1.0";

      src = fetchHex {
        pkg = "syslog";
        version = "${version}";
        sha256 = "4c6a41373c7e20587be33ef841d3de6f3beba08519809329ecc4d27b15b659e1";
      };

      beamDeps = [];
    };

    table_rex = buildMix rec {
      name = "table_rex";
      version = "4.0.0";

      src = fetchHex {
        pkg = "table_rex";
        version = "${version}";
        sha256 = "c35c4d5612ca49ebb0344ea10387da4d2afe278387d4019e4d8111e815df8f55";
      };

      beamDeps = [];
    };

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "1.0.0";

      src = fetchHex {
        pkg = "telemetry";
        version = "${version}";
        sha256 = "73bc09fa59b4a0284efb4624335583c528e07ec9ae76aca96ea0673850aec57a";
      };

      beamDeps = [];
    };

    telemetry_metrics = buildMix rec {
      name = "telemetry_metrics";
      version = "0.6.2";

      src = fetchHex {
        pkg = "telemetry_metrics";
        version = "${version}";
        sha256 = "9b43db0dc33863930b9ef9d27137e78974756f5f198cae18409970ed6fa5b561";
      };

      beamDeps = [ telemetry ];
    };

    telemetry_metrics_prometheus_core = buildMix rec {
      name = "telemetry_metrics_prometheus_core";
      version = "1.2.0";

      src = fetchHex {
        pkg = "telemetry_metrics_prometheus_core";
        version = "${version}";
        sha256 = "9cba950e1c4733468efbe3f821841f34ac05d28e7af7798622f88ecdbbe63ea3";
      };

      beamDeps = [ telemetry telemetry_metrics ];
    };

    telemetry_poller = buildRebar3 rec {
      name = "telemetry_poller";
      version = "1.0.0";

      src = fetchHex {
        pkg = "telemetry_poller";
        version = "${version}";
        sha256 = "b3a24eafd66c3f42da30fc3ca7dda1e9d546c12250a2d60d7b81d264fbec4f6e";
      };

      beamDeps = [ telemetry ];
    };

    tesla = buildMix rec {
      name = "tesla";
      version = "1.11.0";

      src = fetchHex {
        pkg = "tesla";
        version = "${version}";
        sha256 = "b83ab5d4c2d202e1ea2b7e17a49f788d49a699513d7c4f08f2aef2c281be69db";
      };

      beamDeps = [ castore finch gun hackney jason mime mint poison telemetry ];
    };

    thousand_island = buildMix rec {
      name = "thousand_island";
      version = "1.3.5";

      src = fetchHex {
        pkg = "thousand_island";
        version = "${version}";
        sha256 = "2be6954916fdfe4756af3239fb6b6d75d0b8063b5df03ba76fd8a4c87849e180";
      };

      beamDeps = [ telemetry ];
    };

    timex = buildMix rec {
      name = "timex";
      version = "3.7.7";

      src = fetchHex {
        pkg = "timex";
        version = "${version}";
        sha256 = "0ec4b09f25fe311321f9fc04144a7e3affe48eb29481d7a5583849b6c4dfa0a7";
      };

      beamDeps = [ combine gettext tzdata ];
    };

    toml = buildMix rec {
      name = "toml";
      version = "0.7.0";

      src = fetchHex {
        pkg = "toml";
        version = "${version}";
        sha256 = "0690246a2478c1defd100b0c9b89b4ea280a22be9a7b313a8a058a2408a2fa70";
      };

      beamDeps = [];
    };

    trailing_format_plug = buildMix rec {
      name = "trailing_format_plug";
      version = "0.0.7";

      src = fetchHex {
        pkg = "trailing_format_plug";
        version = "${version}";
        sha256 = "bd4fde4c15f3e993a999e019d64347489b91b7a9096af68b2bdadd192afa693f";
      };

      beamDeps = [ plug ];
    };

    tzdata = buildMix rec {
      name = "tzdata";
      version = "1.0.5";

      src = fetchHex {
        pkg = "tzdata";
        version = "${version}";
        sha256 = "55519aa2a99e5d2095c1e61cc74c9be69688f8ab75c27da724eb8279ff402a5a";
      };

      beamDeps = [ hackney ];
    };

    ueberauth = buildMix rec {
      name = "ueberauth";
      version = "0.10.7";

      src = fetchHex {
        pkg = "ueberauth";
        version = "${version}";
        sha256 = "0bccf73e2ffd6337971340832947ba232877aa8122dba4c95be9f729c8987377";
      };

      beamDeps = [ plug ];
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

    vix = buildMix rec {
      name = "vix";
      version = "0.26.0";

      src = fetchHex {
        pkg = "vix";
        version = "${version}";
        sha256 = "71b0a79ae7f199cacfc8e679b0e4ba25ee47dc02e182c5b9097efb29fbe14efd";
      };

      beamDeps = [ castore cc_precompiler elixir_make ];
    };

    web_push_encryption = buildMix rec {
      name = "web_push_encryption";
      version = "0.3.1";

      src = fetchHex {
        pkg = "web_push_encryption";
        version = "${version}";
        sha256 = "4f82b2e57622fb9337559058e8797cb0df7e7c9790793bdc4e40bc895f70e2a2";
      };

      beamDeps = [ httpoison jose ];
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
      version = "0.5.6";

      src = fetchHex {
        pkg = "websock_adapter";
        version = "${version}";
        sha256 = "e04378d26b0af627817ae84c92083b7e97aca3121196679b73c73b99d0d133ea";
      };

      beamDeps = [ bandit plug plug_cowboy websock ];
    };

    websockex = buildMix rec {
      name = "websockex";
      version = "0.4.3";

      src = fetchHex {
        pkg = "websockex";
        version = "${version}";
        sha256 = "95f2e7072b85a3a4cc385602d42115b73ce0b74a9121d0d6dbbf557645ac53e4";
      };

      beamDeps = [];
    };
  };
in self

