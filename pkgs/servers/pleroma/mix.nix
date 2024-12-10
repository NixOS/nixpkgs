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
      accept = buildRebar3 rec {
        name = "accept";
        version = "0.3.5";

        src = fetchHex {
          pkg = "accept";
          version = "${version}";
          sha256 = "11b18c220bcc2eab63b5470c038ef10eb6783bcb1fcdb11aa4137defa5ac1bb8";
        };

        beamDeps = [ ];
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

        beamDeps = [
          comeonin
          elixir_make
        ];
      };

      benchee = buildMix rec {
        name = "benchee";
        version = "1.1.0";

        src = fetchHex {
          pkg = "benchee";
          version = "${version}";
          sha256 = "7da57d545003165a012b587077f6ba90b89210fd88074ce3c60ce239eb5e6d93";
        };

        beamDeps = [
          deep_merge
          statistex
        ];
      };

      bunt = buildMix rec {
        name = "bunt";
        version = "0.2.1";

        src = fetchHex {
          pkg = "bunt";
          version = "${version}";
          sha256 = "a330bfb4245239787b15005e66ae6845c9cd524a288f0d141c148b02603777a5";
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

        beamDeps = [ ];
      };

      certifi = buildRebar3 rec {
        name = "certifi";
        version = "2.9.0";

        src = fetchHex {
          pkg = "certifi";
          version = "${version}";
          sha256 = "266da46bdb06d6c6d35fde799bcb28d36d985d424ad7c08b5bb48f5b5cdd4641";
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
        version = "5.3.3";

        src = fetchHex {
          pkg = "comeonin";
          version = "${version}";
          sha256 = "3e38c9c2cb080828116597ca8807bb482618a315bfafd98c90bc22a821cc84df";
        };

        beamDeps = [ ];
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

        beamDeps = [ ];
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

        beamDeps = [ ];
      };

      cowboy = buildErlangMk rec {
        name = "cowboy";
        version = "2.10.0";

        src = fetchHex {
          pkg = "cowboy";
          version = "${version}";
          sha256 = "3afdccb7183cc6f143cb14d3cf51fa00e53db9ec80cdcd525482f5e99bc41d6b";
        };

        beamDeps = [
          cowlib
          ranch
        ];
      };

      cowboy_telemetry = buildRebar3 rec {
        name = "cowboy_telemetry";
        version = "0.4.0";

        src = fetchHex {
          pkg = "cowboy_telemetry";
          version = "${version}";
          sha256 = "7d98bac1ee4565d31b62d59f8823dfd8356a169e7fcbb83831b8a5397404c9de";
        };

        beamDeps = [
          cowboy
          telemetry
        ];
      };

      cowlib = buildRebar3 rec {
        name = "cowlib";
        version = "2.12.1";

        src = fetchHex {
          pkg = "cowlib";
          version = "${version}";
          sha256 = "163b73f6367a7341b33c794c4e88e7dbfe6498ac42dcd69ef44c5bc5507c8db0";
        };

        beamDeps = [ ];
      };

      credo = buildMix rec {
        name = "credo";
        version = "1.7.0";

        src = fetchHex {
          pkg = "credo";
          version = "${version}";
          sha256 = "6839fcf63d1f0d1c0f450abc8564a57c43d644077ab96f2934563e68b8a769d7";
        };

        beamDeps = [
          bunt
          file_system
          jason
        ];
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

        beamDeps = [ ];
      };

      db_connection = buildMix rec {
        name = "db_connection";
        version = "2.5.0";

        src = fetchHex {
          pkg = "db_connection";
          version = "${version}";
          sha256 = "c92d5ba26cd69ead1ff7582dbb860adeedfff39774105a4f1c92cbb654b55aa2";
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

        beamDeps = [ ];
      };

      deep_merge = buildMix rec {
        name = "deep_merge";
        version = "1.0.0";

        src = fetchHex {
          pkg = "deep_merge";
          version = "${version}";
          sha256 = "ce708e5f094b9cd4e8f2be4f00d2f4250c4095be93f8cd6d018c753894885430";
        };

        beamDeps = [ ];
      };

      earmark = buildMix rec {
        name = "earmark";
        version = "1.4.22";

        src = fetchHex {
          pkg = "earmark";
          version = "${version}";
          sha256 = "1caf5145665a42fd76d5317286b0c171861fb1c04f86ab103dde76868814fdfb";
        };

        beamDeps = [ earmark_parser ];
      };

      earmark_parser = buildMix rec {
        name = "earmark_parser";
        version = "1.4.32";

        src = fetchHex {
          pkg = "earmark_parser";
          version = "${version}";
          sha256 = "b8b0dd77d60373e77a3d7e8afa598f325e49e8663a51bcc2b88ef41838cca755";
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
        version = "3.10.2";

        src = fetchHex {
          pkg = "ecto";
          version = "${version}";
          sha256 = "6a895778f0d7648a4b34b486af59a1c8009041fbdf2b17f1ac215eb829c60235";
        };

        beamDeps = [
          decimal
          jason
          telemetry
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

      ecto_psql_extras = buildMix rec {
        name = "ecto_psql_extras";
        version = "0.7.11";

        src = fetchHex {
          pkg = "ecto_psql_extras";
          version = "${version}";
          sha256 = "def61f1f92d4f40d51c80bbae2157212d6c0a459eb604be446e47369cbd40b23";
        };

        beamDeps = [
          ecto_sql
          postgrex
          table_rex
        ];
      };

      ecto_sql = buildMix rec {
        name = "ecto_sql";
        version = "3.10.1";

        src = fetchHex {
          pkg = "ecto_sql";
          version = "${version}";
          sha256 = "f6a25bdbbd695f12c8171eaff0851fa4c8e72eec1e98c7364402dda9ce11c56b";
        };

        beamDeps = [
          db_connection
          ecto
          postgrex
          telemetry
        ];
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
        version = "0.6.3";

        src = fetchHex {
          pkg = "elixir_make";
          version = "${version}";
          sha256 = "f5cbd651c5678bcaabdbb7857658ee106b12509cd976c2c2fca99688e1daf716";
        };

        beamDeps = [ ];
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

        beamDeps = [ ];
      };

      ex_aws = buildMix rec {
        name = "ex_aws";
        version = "2.1.9";

        src = fetchHex {
          pkg = "ex_aws";
          version = "${version}";
          sha256 = "3e6c776703c9076001fbe1f7c049535f042cb2afa0d2cbd3b47cbc4e92ac0d10";
        };

        beamDeps = [
          hackney
          jason
          sweet_xml
        ];
      };

      ex_aws_s3 = buildMix rec {
        name = "ex_aws_s3";
        version = "2.4.0";

        src = fetchHex {
          pkg = "ex_aws_s3";
          version = "${version}";
          sha256 = "85dda6e27754d94582869d39cba3241d9ea60b6aa4167f9c88e309dc687e56bb";
        };

        beamDeps = [
          ex_aws
          sweet_xml
        ];
      };

      ex_const = buildMix rec {
        name = "ex_const";
        version = "0.2.4";

        src = fetchHex {
          pkg = "ex_const";
          version = "${version}";
          sha256 = "96fd346610cc992b8f896ed26a98be82ac4efb065a0578f334a32d60a3ba9767";
        };

        beamDeps = [ ];
      };

      ex_doc = buildMix rec {
        name = "ex_doc";
        version = "0.29.4";

        src = fetchHex {
          pkg = "ex_doc";
          version = "${version}";
          sha256 = "2c6699a737ae46cb61e4ed012af931b57b699643b24dabe2400a8168414bc4f5";
        };

        beamDeps = [
          earmark_parser
          makeup_elixir
          makeup_erlang
        ];
      };

      ex_machina = buildMix rec {
        name = "ex_machina";
        version = "2.7.0";

        src = fetchHex {
          pkg = "ex_machina";
          version = "${version}";
          sha256 = "419aa7a39bde11894c87a615c4ecaa52d8f107bbdd81d810465186f783245bf8";
        };

        beamDeps = [
          ecto
          ecto_sql
        ];
      };

      ex_syslogger = buildMix rec {
        name = "ex_syslogger";
        version = "1.5.2";

        src = fetchHex {
          pkg = "ex_syslogger";
          version = "${version}";
          sha256 = "ab9fab4136dbc62651ec6f16fa4842f10cf02ab4433fa3d0976c01be99398399";
        };

        beamDeps = [
          poison
          syslog
        ];
      };

      expo = buildMix rec {
        name = "expo";
        version = "0.4.1";

        src = fetchHex {
          pkg = "expo";
          version = "${version}";
          sha256 = "2ff7ba7a798c8c543c12550fa0e2cbc81b95d4974c65855d8d15ba7b37a1ce47";
        };

        beamDeps = [ ];
      };

      fast_html = buildMix rec {
        name = "fast_html";
        version = "2.0.5";

        src = fetchHex {
          pkg = "fast_html";
          version = "${version}";
          sha256 = "605f4f4829443c14127694ebabb681778712ceecb4470ec32aa31012330e6506";
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

      file_system = buildMix rec {
        name = "file_system";
        version = "0.2.10";

        src = fetchHex {
          pkg = "file_system";
          version = "${version}";
          sha256 = "41195edbfb562a593726eda3b3e8b103a309b733ad25f3d642ba49696bf715dc";
        };

        beamDeps = [ ];
      };

      finch = buildMix rec {
        name = "finch";
        version = "0.10.2";

        src = fetchHex {
          pkg = "finch";
          version = "${version}";
          sha256 = "dd8b11b282072cec2ef30852283949c248bd5d2820c88d8acc89402b81db7550";
        };

        beamDeps = [
          castore
          mint
          nimble_options
          nimble_pool
          telemetry
        ];
      };

      flake_id = buildMix rec {
        name = "flake_id";
        version = "0.1.0";

        src = fetchHex {
          pkg = "flake_id";
          version = "${version}";
          sha256 = "31fc8090fde1acd267c07c36ea7365b8604055f897d3a53dd967658c691bd827";
        };

        beamDeps = [
          base62
          ecto
        ];
      };

      floki = buildMix rec {
        name = "floki";
        version = "0.34.3";

        src = fetchHex {
          pkg = "floki";
          version = "${version}";
          sha256 = "9577440eea5b97924b4bf3c7ea55f7b8b6dce589f9b28b096cc294a8dc342341";
        };

        beamDeps = [ ];
      };

      gen_smtp = buildRebar3 rec {
        name = "gen_smtp";
        version = "0.15.0";

        src = fetchHex {
          pkg = "gen_smtp";
          version = "${version}";
          sha256 = "29bd14a88030980849c7ed2447b8db6d6c9278a28b11a44cafe41b791205440f";
        };

        beamDeps = [ ];
      };

      gettext = buildMix rec {
        name = "gettext";
        version = "0.22.2";

        src = fetchHex {
          pkg = "gettext";
          version = "${version}";
          sha256 = "8a2d389673aea82d7eae387e6a2ccc12660610080ae7beb19452cfdc1ec30f60";
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
        version = "1.18.1";

        src = fetchHex {
          pkg = "hackney";
          version = "${version}";
          sha256 = "a4ecdaff44297e9b5894ae499e9a070ea1888c84afdd1fd9b7b2bc384950128e";
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

      hpax = buildMix rec {
        name = "hpax";
        version = "0.1.2";

        src = fetchHex {
          pkg = "hpax";
          version = "${version}";
          sha256 = "2c87843d5a23f5f16748ebe77969880e29809580efdaccd615cd3bed628a8c13";
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
        version = "0.1.1";

        src = fetchHex {
          pkg = "http_signatures";
          version = "${version}";
          sha256 = "cc3b8a007322cc7b624c0c15eec49ee58ac977254ff529a3c482f681465942a3";
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
        version = "1.0.4";

        src = fetchHex {
          pkg = "inet_cidr";
          version = "${version}";
          sha256 = "64a2d30189704ae41ca7dbdd587f5291db5d1dda1414e0774c29ffc81088c1bc";
        };

        beamDeps = [ ];
      };

      jason = buildMix rec {
        name = "jason";
        version = "1.4.0";

        src = fetchHex {
          pkg = "jason";
          version = "${version}";
          sha256 = "79a3791085b2a0f743ca04cec0f7be26443738779d09302e01318f97bdb82121";
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
        version = "1.11.5";

        src = fetchHex {
          pkg = "jose";
          version = "${version}";
          sha256 = "dcd3b215bafe02ea7c5b23dafd3eb8062a5cd8f2d904fd9caa323d37034ab384";
        };

        beamDeps = [ ];
      };

      jumper = buildMix rec {
        name = "jumper";
        version = "1.0.1";

        src = fetchHex {
          pkg = "jumper";
          version = "${version}";
          sha256 = "318c59078ac220e966d27af3646026db9b5a5e6703cb2aa3e26bcfaba65b7433";
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

      majic = buildMix rec {
        name = "majic";
        version = "1.0.0";

        src = fetchHex {
          pkg = "majic";
          version = "${version}";
          sha256 = "7905858f76650d49695f14ea55cd9aaaee0c6654fa391671d4cf305c275a0a9e";
        };

        beamDeps = [
          elixir_make
          mime
          nimble_pool
          plug
        ];
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
        version = "1.6.0";

        src = fetchHex {
          pkg = "mime";
          version = "${version}";
          sha256 = "31a1a8613f8321143dde1dafc36006a17d28d02bdfecb9e95a880fa7aabd19a7";
        };

        beamDeps = [ ];
      };

      mimerl = buildRebar3 rec {
        name = "mimerl";
        version = "1.2.0";

        src = fetchHex {
          pkg = "mimerl";
          version = "${version}";
          sha256 = "f278585650aa581986264638ebf698f8bb19df297f66ad91b18910dfc6e19323";
        };

        beamDeps = [ ];
      };

      mint = buildMix rec {
        name = "mint";
        version = "1.5.1";

        src = fetchHex {
          pkg = "mint";
          version = "${version}";
          sha256 = "4a63e1e76a7c3956abd2c72f370a0d0aecddc3976dea5c27eccbecfa5e7d5b1e";
        };

        beamDeps = [
          castore
          hpax
        ];
      };

      mochiweb = buildRebar3 rec {
        name = "mochiweb";
        version = "2.18.0";

        src = fetchHex {
          pkg = "mochiweb";
          version = "${version}";
          sha256 = "16j8cfn3hq0g474xc5xl8nk2v46hwvwpfwi9rkzavnsbaqg2ngmr";
        };

        beamDeps = [ ];
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

        beamDeps = [ ];
      };

      mox = buildMix rec {
        name = "mox";
        version = "1.0.2";

        src = fetchHex {
          pkg = "mox";
          version = "${version}";
          sha256 = "f9864921b3aaf763c8741b5b8e6f908f44566f1e427b2630e89e9a73b981fef2";
        };

        beamDeps = [ ];
      };

      nimble_options = buildMix rec {
        name = "nimble_options";
        version = "0.4.0";

        src = fetchHex {
          pkg = "nimble_options";
          version = "${version}";
          sha256 = "e6701c1af326a11eea9634a3b1c62b475339ace9456c1a23ec3bc9a847bca02d";
        };

        beamDeps = [ ];
      };

      nimble_parsec = buildMix rec {
        name = "nimble_parsec";
        version = "0.6.0";

        src = fetchHex {
          pkg = "nimble_parsec";
          version = "${version}";
          sha256 = "27eac315a94909d4dc68bc07a4a83e06c8379237c5ea528a9acff4ca1c873c52";
        };

        beamDeps = [ ];
      };

      nimble_pool = buildMix rec {
        name = "nimble_pool";
        version = "0.2.6";

        src = fetchHex {
          pkg = "nimble_pool";
          version = "${version}";
          sha256 = "1c715055095d3f2705c4e236c18b618420a35490da94149ff8b580a2144f653f";
        };

        beamDeps = [ ];
      };

      oban = buildMix rec {
        name = "oban";
        version = "2.13.6";

        src = fetchHex {
          pkg = "oban";
          version = "${version}";
          sha256 = "3c1c5eb16f377b3cbbf2ea14be24d20e3d91285af9d1ac86260b7c2af5464887";
        };

        beamDeps = [
          ecto_sql
          jason
          postgrex
          telemetry
        ];
      };

      open_api_spex = buildMix rec {
        name = "open_api_spex";
        version = "3.17.3";

        src = fetchHex {
          pkg = "open_api_spex";
          version = "${version}";
          sha256 = "165db21a85ca83cffc8e7c8890f35b354eddda8255de7404a2848ed652b9f0fe";
        };

        beamDeps = [
          jason
          plug
          poison
        ];
      };

      parse_trans = buildRebar3 rec {
        name = "parse_trans";
        version = "3.3.1";

        src = fetchHex {
          pkg = "parse_trans";
          version = "${version}";
          sha256 = "07cd9577885f56362d414e8c4c4e6bdf10d43a8767abb92d24cbe8b24c54888b";
        };

        beamDeps = [ ];
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
        version = "1.6.16";

        src = fetchHex {
          pkg = "phoenix";
          version = "${version}";
          sha256 = "e15989ff34f670a96b95ef6d1d25bad0d9c50df5df40b671d8f4a669e050ac39";
        };

        beamDeps = [
          castore
          jason
          phoenix_pubsub
          phoenix_view
          plug
          plug_cowboy
          plug_crypto
          telemetry
        ];
      };

      phoenix_ecto = buildMix rec {
        name = "phoenix_ecto";
        version = "4.4.2";

        src = fetchHex {
          pkg = "phoenix_ecto";
          version = "${version}";
          sha256 = "70242edd4601d50b69273b057ecf7b684644c19ee750989fd555625ae4ce8f5d";
        };

        beamDeps = [
          ecto
          phoenix_html
          plug
        ];
      };

      phoenix_html = buildMix rec {
        name = "phoenix_html";
        version = "3.3.1";

        src = fetchHex {
          pkg = "phoenix_html";
          version = "${version}";
          sha256 = "bed1906edd4906a15fd7b412b85b05e521e1f67c9a85418c55999277e553d0d3";
        };

        beamDeps = [ plug ];
      };

      phoenix_live_dashboard = buildMix rec {
        name = "phoenix_live_dashboard";
        version = "0.6.5";

        src = fetchHex {
          pkg = "phoenix_live_dashboard";
          version = "${version}";
          sha256 = "ef4fa50dd78364409039c99cf6f98ab5209b4c5f8796c17f4db118324f0db852";
        };

        beamDeps = [
          ecto
          ecto_psql_extras
          mime
          phoenix_live_view
          telemetry_metrics
        ];
      };

      phoenix_live_reload = buildMix rec {
        name = "phoenix_live_reload";
        version = "1.3.3";

        src = fetchHex {
          pkg = "phoenix_live_reload";
          version = "${version}";
          sha256 = "766796676e5f558dbae5d1bdb066849673e956005e3730dfd5affd7a6da4abac";
        };

        beamDeps = [
          file_system
          phoenix
        ];
      };

      phoenix_live_view = buildMix rec {
        name = "phoenix_live_view";
        version = "0.17.14";

        src = fetchHex {
          pkg = "phoenix_live_view";
          version = "${version}";
          sha256 = "afeb6ba43ce329a6f7fc1c9acdfc6d3039995345f025febb7f409a92f6faebd3";
        };

        beamDeps = [
          jason
          phoenix
          phoenix_html
          telemetry
        ];
      };

      phoenix_pubsub = buildMix rec {
        name = "phoenix_pubsub";
        version = "2.1.3";

        src = fetchHex {
          pkg = "phoenix_pubsub";
          version = "${version}";
          sha256 = "bba06bc1dcfd8cb086759f0edc94a8ba2bc8896d5331a1e2c2902bf8e36ee502";
        };

        beamDeps = [ ];
      };

      phoenix_swoosh = buildMix rec {
        name = "phoenix_swoosh";
        version = "1.2.0";

        src = fetchHex {
          pkg = "phoenix_swoosh";
          version = "${version}";
          sha256 = "e88d117251e89a16b92222415a6d87b99a96747ddf674fc5c7631de734811dba";
        };

        beamDeps = [
          finch
          hackney
          phoenix
          phoenix_html
          phoenix_view
          swoosh
        ];
      };

      phoenix_template = buildMix rec {
        name = "phoenix_template";
        version = "1.0.1";

        src = fetchHex {
          pkg = "phoenix_template";
          version = "${version}";
          sha256 = "157dc078f6226334c91cb32c1865bf3911686f8bcd6bcff86736f6253e6993ee";
        };

        beamDeps = [ phoenix_html ];
      };

      phoenix_view = buildMix rec {
        name = "phoenix_view";
        version = "2.0.2";

        src = fetchHex {
          pkg = "phoenix_view";
          version = "${version}";
          sha256 = "a929e7230ea5c7ee0e149ffcf44ce7cf7f4b6d2bfe1752dd7c084cdff152d36f";
        };

        beamDeps = [
          phoenix_html
          phoenix_template
        ];
      };

      plug = buildMix rec {
        name = "plug";
        version = "1.14.2";

        src = fetchHex {
          pkg = "plug";
          version = "${version}";
          sha256 = "842fc50187e13cf4ac3b253d47d9474ed6c296a8732752835ce4a86acdf68d13";
        };

        beamDeps = [
          mime
          plug_crypto
          telemetry
        ];
      };

      plug_cowboy = buildMix rec {
        name = "plug_cowboy";
        version = "2.6.1";

        src = fetchHex {
          pkg = "plug_cowboy";
          version = "${version}";
          sha256 = "de36e1a21f451a18b790f37765db198075c25875c64834bcc82d90b309eb6613";
        };

        beamDeps = [
          cowboy
          cowboy_telemetry
          plug
        ];
      };

      plug_crypto = buildMix rec {
        name = "plug_crypto";
        version = "1.2.5";

        src = fetchHex {
          pkg = "plug_crypto";
          version = "${version}";
          sha256 = "26549a1d6345e2172eb1c233866756ae44a9609bd33ee6f99147ab3fd87fd842";
        };

        beamDeps = [ ];
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
        version = "0.17.1";

        src = fetchHex {
          pkg = "postgrex";
          version = "${version}";
          sha256 = "14b057b488e73be2beee508fb1955d8db90d6485c6466428fe9ccf1d6692a555";
        };

        beamDeps = [
          db_connection
          decimal
          jason
        ];
      };

      pot = buildRebar3 rec {
        name = "pot";
        version = "1.0.2";

        src = fetchHex {
          pkg = "pot";
          version = "${version}";
          sha256 = "78fe127f5a4f5f919d6ea5a2a671827bd53eb9d37e5b4128c0ad3df99856c2e0";
        };

        beamDeps = [ ];
      };

      prom_ex = buildMix rec {
        name = "prom_ex";
        version = "1.7.1";

        src = fetchHex {
          pkg = "prom_ex";
          version = "${version}";
          sha256 = "4c978872b88a929833925a0f4d0561824804c671fdd04581e765509ed0a6ed08";
        };

        beamDeps = [
          ecto
          finch
          jason
          oban
          phoenix
          phoenix_live_view
          plug
          plug_cowboy
          telemetry
          telemetry_metrics
          telemetry_metrics_prometheus_core
          telemetry_poller
        ];
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

        beamDeps = [
          ecto
          prometheus_ex
        ];
      };

      prometheus_phoenix = buildMix rec {
        name = "prometheus_phoenix";
        version = "1.3.0";

        src = fetchHex {
          pkg = "prometheus_phoenix";
          version = "${version}";
          sha256 = "c4d1404ac4e9d3d963da601db2a7d8ea31194f0017057fabf0cfb9bf5a6c8c75";
        };

        beamDeps = [
          phoenix
          prometheus_ex
        ];
      };

      prometheus_plugs = buildMix rec {
        name = "prometheus_plugs";
        version = "1.1.5";

        src = fetchHex {
          pkg = "prometheus_plugs";
          version = "${version}";
          sha256 = "0273a6483ccb936d79ca19b0ab629aef0dba958697c94782bb728b920dfc6a79";
        };

        beamDeps = [
          accept
          plug
          prometheus_ex
        ];
      };

      quantile_estimator = buildRebar3 rec {
        name = "quantile_estimator";
        version = "0.2.1";

        src = fetchHex {
          pkg = "quantile_estimator";
          version = "${version}";
          sha256 = "282a8a323ca2a845c9e6f787d166348f776c1d4a41ede63046d72d422e3da946";
        };

        beamDeps = [ ];
      };

      ranch = buildRebar3 rec {
        name = "ranch";
        version = "1.8.0";

        src = fetchHex {
          pkg = "ranch";
          version = "${version}";
          sha256 = "49fbcfd3682fab1f5d109351b61257676da1a2fdbe295904176d5e521a2ddfe5";
        };

        beamDeps = [ ];
      };

      recon = buildMix rec {
        name = "recon";
        version = "2.5.3";

        src = fetchHex {
          pkg = "recon";
          version = "${version}";
          sha256 = "6c6683f46fd4a1dfd98404b9f78dcabc7fcd8826613a89dcb984727a8c3099d7";
        };

        beamDeps = [ ];
      };

      sleeplocks = buildRebar3 rec {
        name = "sleeplocks";
        version = "1.1.2";

        src = fetchHex {
          pkg = "sleeplocks";
          version = "${version}";
          sha256 = "9fe5d048c5b781d6305c1a3a0f40bb3dfc06f49bf40571f3d2d0c57eaa7f59a5";
        };

        beamDeps = [ ];
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

      statistex = buildMix rec {
        name = "statistex";
        version = "1.0.0";

        src = fetchHex {
          pkg = "statistex";
          version = "${version}";
          sha256 = "ff9d8bee7035028ab4742ff52fc80a2aa35cece833cf5319009b52f1b5a86c27";
        };

        beamDeps = [ ];
      };

      sweet_xml = buildMix rec {
        name = "sweet_xml";
        version = "0.7.3";

        src = fetchHex {
          pkg = "sweet_xml";
          version = "${version}";
          sha256 = "e110c867a1b3fe74bfc7dd9893aa851f0eed5518d0d7cad76d7baafd30e4f5ba";
        };

        beamDeps = [ ];
      };

      swoosh = buildMix rec {
        name = "swoosh";
        version = "1.10.3";

        src = fetchHex {
          pkg = "swoosh";
          version = "${version}";
          sha256 = "8b7167d93047bac6e1a1c367bf7d899cf2e4fea0592ee04a70673548ef6091b9";
        };

        beamDeps = [
          cowboy
          ex_aws
          finch
          gen_smtp
          hackney
          jason
          mime
          plug_cowboy
          telemetry
        ];
      };

      syslog = buildRebar3 rec {
        name = "syslog";
        version = "1.1.0";

        src = fetchHex {
          pkg = "syslog";
          version = "${version}";
          sha256 = "4c6a41373c7e20587be33ef841d3de6f3beba08519809329ecc4d27b15b659e1";
        };

        beamDeps = [ ];
      };

      table_rex = buildMix rec {
        name = "table_rex";
        version = "3.1.1";

        src = fetchHex {
          pkg = "table_rex";
          version = "${version}";
          sha256 = "678a23aba4d670419c23c17790f9dcd635a4a89022040df7d5d772cb21012490";
        };

        beamDeps = [ ];
      };

      telemetry = buildRebar3 rec {
        name = "telemetry";
        version = "1.0.0";

        src = fetchHex {
          pkg = "telemetry";
          version = "${version}";
          sha256 = "73bc09fa59b4a0284efb4624335583c528e07ec9ae76aca96ea0673850aec57a";
        };

        beamDeps = [ ];
      };

      telemetry_metrics = buildMix rec {
        name = "telemetry_metrics";
        version = "0.6.1";

        src = fetchHex {
          pkg = "telemetry_metrics";
          version = "${version}";
          sha256 = "7be9e0871c41732c233be71e4be11b96e56177bf15dde64a8ac9ce72ac9834c6";
        };

        beamDeps = [ telemetry ];
      };

      telemetry_metrics_prometheus_core = buildMix rec {
        name = "telemetry_metrics_prometheus_core";
        version = "1.0.2";

        src = fetchHex {
          pkg = "telemetry_metrics_prometheus_core";
          version = "${version}";
          sha256 = "48351a0d56f80e38c997b44232b1043e0a081670d16766eee920e6254175b730";
        };

        beamDeps = [
          telemetry
          telemetry_metrics
        ];
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
        version = "1.4.4";

        src = fetchHex {
          pkg = "tesla";
          version = "${version}";
          sha256 = "d5503a49f9dec1b287567ea8712d085947e247cb11b06bc54adb05bfde466457";
        };

        beamDeps = [
          castore
          finch
          gun
          hackney
          jason
          mime
          mint
          poison
          telemetry
        ];
      };

      timex = buildMix rec {
        name = "timex";
        version = "3.7.7";

        src = fetchHex {
          pkg = "timex";
          version = "${version}";
          sha256 = "0ec4b09f25fe311321f9fc04144a7e3affe48eb29481d7a5583849b6c4dfa0a7";
        };

        beamDeps = [
          combine
          gettext
          tzdata
        ];
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
        version = "0.10.5";

        src = fetchHex {
          pkg = "ueberauth";
          version = "${version}";
          sha256 = "3efd1f31d490a125c7ed453b926f7c31d78b97b8a854c755f5c40064bf3ac9e1";
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

        beamDeps = [ ];
      };

      unsafe = buildMix rec {
        name = "unsafe";
        version = "1.0.1";

        src = fetchHex {
          pkg = "unsafe";
          version = "${version}";
          sha256 = "6c7729a2d214806450d29766abc2afaa7a2cbecf415be64f36a6691afebb50e5";
        };

        beamDeps = [ ];
      };

      web_push_encryption = buildMix rec {
        name = "web_push_encryption";
        version = "0.3.1";

        src = fetchHex {
          pkg = "web_push_encryption";
          version = "${version}";
          sha256 = "4f82b2e57622fb9337559058e8797cb0df7e7c9790793bdc4e40bc895f70e2a2";
        };

        beamDeps = [
          httpoison
          jose
        ];
      };

      websockex = buildMix rec {
        name = "websockex";
        version = "0.4.3";

        src = fetchHex {
          pkg = "websockex";
          version = "${version}";
          sha256 = "95f2e7072b85a3a4cc385602d42115b73ce0b74a9121d0d6dbbf557645ac53e4";
        };

        beamDeps = [ ];
      };
    };
in
self
