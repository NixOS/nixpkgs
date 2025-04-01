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
      argon2_elixir = buildMix rec {
        name = "argon2_elixir";
        version = "3.2.1";

        src = fetchHex {
          pkg = "argon2_elixir";
          version = "${version}";
          sha256 = "a813b78217394530b5fcf4c8070feee43df03ffef938d044019169c766315690";
        };

        beamDeps = [
          comeonin
          elixir_make
        ];
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
        version = "3.0.1";

        src = fetchHex {
          pkg = "bcrypt_elixir";
          version = "${version}";
          sha256 = "486bb95efb645d1efc6794c1ddd776a186a9a713abf06f45708a6ce324fb96cf";
        };

        beamDeps = [
          comeonin
          elixir_make
        ];
      };

      benchee = buildMix rec {
        name = "benchee";
        version = "1.3.0";

        src = fetchHex {
          pkg = "benchee";
          version = "${version}";
          sha256 = "34f4294068c11b2bd2ebf2c59aac9c7da26ffa0068afdf3419f1b176e16c5f81";
        };

        beamDeps = [
          deep_merge
          statistex
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
        version = "1.0.6";

        src = fetchHex {
          pkg = "castore";
          version = "${version}";
          sha256 = "374c6e7ca752296be3d6780a6d5b922854ffcc74123da90f2f328996b962d33a";
        };

        beamDeps = [ ];
      };

      certifi = buildRebar3 rec {
        name = "certifi";
        version = "2.12.0";

        src = fetchHex {
          pkg = "certifi";
          version = "${version}";
          sha256 = "ee68d85df22e554040cdb4be100f33873ac6051387baf6a8f6ce82272340ff1c";
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
        version = "5.4.0";

        src = fetchHex {
          pkg = "comeonin";
          version = "${version}";
          sha256 = "796393a9e50d01999d56b7b8420ab0481a7538d0caf80919da493b4a6e51faf1";
        };

        beamDeps = [ ];
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
        version = "2.12.0";

        src = fetchHex {
          pkg = "cowboy";
          version = "${version}";
          sha256 = "8a7abe6d183372ceb21caa2709bec928ab2b72e18a3911aa1771639bef82651e";
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
        version = "2.13.0";

        src = fetchHex {
          pkg = "cowlib";
          version = "${version}";
          sha256 = "e1e1284dc3fc030a64b1ad0d8382ae7e99da46c3246b815318a4b848873800a4";
        };

        beamDeps = [ ];
      };

      credo = buildMix rec {
        name = "credo";
        version = "1.7.5";

        src = fetchHex {
          pkg = "credo";
          version = "${version}";
          sha256 = "f799e9b5cd1891577d8c773d245668aa74a2fcd15eb277f51a0131690ebfb3fd";
        };

        beamDeps = [
          bunt
          file_system
          jason
        ];
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

        beamDeps = [ ];
      };

      earmark_parser = buildMix rec {
        name = "earmark_parser";
        version = "1.4.39";

        src = fetchHex {
          pkg = "earmark_parser";
          version = "${version}";
          sha256 = "06553a88d1f1846da9ef066b87b57c6f605552cfbe40d20bd8d59cc6bde41944";
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
        version = "3.10.3";

        src = fetchHex {
          pkg = "ecto";
          version = "${version}";
          sha256 = "44bec74e2364d491d70f7e42cd0d690922659d329f6465e89feb8a34e8cd3433";
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
        version = "0.7.15";

        src = fetchHex {
          pkg = "ecto_psql_extras";
          version = "${version}";
          sha256 = "b6127f3a5c6fc3d84895e4768cc7c199f22b48b67d6c99b13fbf4a374e73f039";
        };

        beamDeps = [
          ecto_sql
          postgrex
          table_rex
        ];
      };

      ecto_sql = buildMix rec {
        name = "ecto_sql";
        version = "3.10.2";

        src = fetchHex {
          pkg = "ecto_sql";
          version = "${version}";
          sha256 = "68c018debca57cb9235e3889affdaec7a10616a4e3a80c99fa1d01fdafaa9007";
        };

        beamDeps = [
          db_connection
          ecto
          postgrex
          telemetry
        ];
      };

      elixir_make = buildMix rec {
        name = "elixir_make";
        version = "0.8.3";

        src = fetchHex {
          pkg = "elixir_make";
          version = "${version}";
          sha256 = "5c99a18571a756d4af7a4d89ca75c28ac899e6103af6f223982f09ce44942cc9";
        };

        beamDeps = [
          castore
          certifi
        ];
      };

      elixir_xml_to_map = buildMix rec {
        name = "elixir_xml_to_map";
        version = "3.1.0";

        src = fetchHex {
          pkg = "elixir_xml_to_map";
          version = "${version}";
          sha256 = "8fe5f2e75f90bab07ee2161120c2dc038ebcae8135554f5582990f1c8c21f911";
        };

        beamDeps = [ erlsom ];
      };

      erlex = buildMix rec {
        name = "erlex";
        version = "0.2.6";

        src = fetchHex {
          pkg = "erlex";
          version = "${version}";
          sha256 = "2ed2e25711feb44d52b17d2780eabf998452f6efda104877a3881c2f8c0c0c75";
        };

        beamDeps = [ ];
      };

      erlsom = buildRebar3 rec {
        name = "erlsom";
        version = "1.5.1";

        src = fetchHex {
          pkg = "erlsom";
          version = "${version}";
          sha256 = "7965485494c5844dd127656ac40f141aadfa174839ec1be1074e7edf5b4239eb";
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

      ex_aws = buildMix rec {
        name = "ex_aws";
        version = "2.5.3";

        src = fetchHex {
          pkg = "ex_aws";
          version = "${version}";
          sha256 = "67115f1d399d7ec4d191812ee565c6106cb4b1bbf19a9d4db06f265fd87da97e";
        };

        beamDeps = [
          hackney
          jason
          mime
          sweet_xml
          telemetry
        ];
      };

      ex_aws_s3 = buildMix rec {
        name = "ex_aws_s3";
        version = "2.5.3";

        src = fetchHex {
          pkg = "ex_aws_s3";
          version = "${version}";
          sha256 = "4f09dd372cc386550e484808c5ac5027766c8d0cd8271ccc578b82ee6ef4f3b8";
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
        version = "0.32.0";

        src = fetchHex {
          pkg = "ex_doc";
          version = "${version}";
          sha256 = "ed2c3e42c558f49bda3ff37e05713432006e1719a6c4a3320c7e4735787374e7";
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
        version = "2.0.0";

        src = fetchHex {
          pkg = "ex_syslogger";
          version = "${version}";
          sha256 = "a52b2fe71764e9e6ecd149ab66635812f68e39279cbeee27c52c0e35e8b8019e";
        };

        beamDeps = [
          jason
          syslog
        ];
      };

      excoveralls = buildMix rec {
        name = "excoveralls";
        version = "0.16.1";

        src = fetchHex {
          pkg = "excoveralls";
          version = "${version}";
          sha256 = "dae763468e2008cf7075a64cb1249c97cb4bc71e236c5c2b5e5cdf1cfa2bf138";
        };

        beamDeps = [
          hackney
          jason
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
        version = "2.3.0";

        src = fetchHex {
          pkg = "fast_html";
          version = "${version}";
          sha256 = "f18e3c7668f82d3ae0b15f48d48feeb257e28aa5ab1b0dbf781c7312e5da029d";
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
        version = "1.0.0";

        src = fetchHex {
          pkg = "file_system";
          version = "${version}";
          sha256 = "6752092d66aec5a10e662aefeed8ddb9531d79db0bc145bb8c40325ca1d8536d";
        };

        beamDeps = [ ];
      };

      finch = buildMix rec {
        name = "finch";
        version = "0.16.0";

        src = fetchHex {
          pkg = "finch";
          version = "${version}";
          sha256 = "f660174c4d519e5fec629016054d60edd822cdfe2b7270836739ac2f97735ec5";
        };

        beamDeps = [
          castore
          mime
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
        version = "0.36.1";

        src = fetchHex {
          pkg = "floki";
          version = "${version}";
          sha256 = "21ba57abb8204bcc70c439b423fc0dd9f0286de67dc82773a14b0200ada0995f";
        };

        beamDeps = [ ];
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

      gettext = buildMix rec {
        name = "gettext";
        version = "0.22.3";

        src = fetchHex {
          pkg = "gettext";
          version = "${version}";
          sha256 = "935f23447713954a6866f1bb28c3a878c4c011e802bcd68a726f5e558e4b64bd";
        };

        beamDeps = [ expo ];
      };

      hackney = buildRebar3 rec {
        name = "hackney";
        version = "1.20.1";

        src = fetchHex {
          pkg = "hackney";
          version = "${version}";
          sha256 = "fe9094e5f1a2a2c0a7d10918fee36bfec0ec2a979994cff8cfe8058cd9af38e3";
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

        beamDeps = [ ];
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

      joken = buildMix rec {
        name = "joken";
        version = "2.6.1";

        src = fetchHex {
          pkg = "joken";
          version = "${version}";
          sha256 = "ab26122c400b3d254ce7d86ed066d6afad27e70416df947cdcb01e13a7382e68";
        };

        beamDeps = [ jose ];
      };

      jose = buildMix rec {
        name = "jose";
        version = "1.11.9";

        src = fetchHex {
          pkg = "jose";
          version = "${version}";
          sha256 = "b5ccc3749d2e1638c26bed806259df5bc9e438797fe60dc71e9fa0716133899b";
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

      mail = buildMix rec {
        name = "mail";
        version = "0.3.1";

        src = fetchHex {
          pkg = "mail";
          version = "${version}";
          sha256 = "1db701e89865c1d5fa296b2b57b1cd587587cca8d8a1a22892b35ef5a8e352a6";
        };

        beamDeps = [ ];
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
        version = "0.16.2";

        src = fetchHex {
          pkg = "makeup_elixir";
          version = "${version}";
          sha256 = "41193978704763f6bbe6cc2758b84909e62984c7752b3784bd3c218bb341706b";
        };

        beamDeps = [
          makeup
          nimble_parsec
        ];
      };

      makeup_erlang = buildMix rec {
        name = "makeup_erlang";
        version = "0.1.5";

        src = fetchHex {
          pkg = "makeup_erlang";
          version = "${version}";
          sha256 = "94d2e986428585a21516d7d7149781480013c56e30c6a233534bedf38867a59a";
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
        version = "2.0.5";

        src = fetchHex {
          pkg = "mime";
          version = "${version}";
          sha256 = "da0d64a365c45bc9935cc5c8a7fc5e49a0e0f9932a761c55d6c52b142780a05c";
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
        version = "1.5.2";

        src = fetchHex {
          pkg = "mint";
          version = "${version}";
          sha256 = "d77d9e9ce4eb35941907f1d3df38d8f750c357865353e21d335bdcdf6d892a02";
        };

        beamDeps = [
          castore
          hpax
        ];
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
        version = "1.1.0";

        src = fetchHex {
          pkg = "mox";
          version = "${version}";
          sha256 = "d44474c50be02d5b72131070281a5d3895c0e7a95c780e90bc0cfe712f633a13";
        };

        beamDeps = [ ];
      };

      nimble_options = buildMix rec {
        name = "nimble_options";
        version = "1.1.0";

        src = fetchHex {
          pkg = "nimble_options";
          version = "${version}";
          sha256 = "8bbbb3941af3ca9acc7835f5655ea062111c9c27bcac53e004460dfd19008a99";
        };

        beamDeps = [ ];
      };

      nimble_parsec = buildMix rec {
        name = "nimble_parsec";
        version = "1.4.0";

        src = fetchHex {
          pkg = "nimble_parsec";
          version = "${version}";
          sha256 = "9c565862810fb383e9838c1dd2d7d2c437b3d13b267414ba6af33e50d2d1cf28";
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

      oban = buildMix rec {
        name = "oban";
        version = "2.17.8";

        src = fetchHex {
          pkg = "oban";
          version = "${version}";
          sha256 = "a2165bf93843b7bcb68182c82725ddd4cb43c0c3719f114e7aa3b6c99c4b6129";
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
        version = "3.18.3";

        src = fetchHex {
          pkg = "open_api_spex";
          version = "${version}";
          sha256 = "c0cfc31570199ce7e7520b494a591027da609af45f6bf9adce51e2469b1609fb";
        };

        beamDeps = [
          jason
          plug
          poison
        ];
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
        version = "1.7.12";

        src = fetchHex {
          pkg = "phoenix";
          version = "${version}";
          sha256 = "d646192fbade9f485b01bc9920c139bfdd19d0f8df3d73fd8eaf2dfbe0d2837c";
        };

        beamDeps = [
          castore
          jason
          phoenix_pubsub
          phoenix_template
          phoenix_view
          plug
          plug_cowboy
          plug_crypto
          telemetry
          websock_adapter
        ];
      };

      phoenix_ecto = buildMix rec {
        name = "phoenix_ecto";
        version = "4.5.1";

        src = fetchHex {
          pkg = "phoenix_ecto";
          version = "${version}";
          sha256 = "ebe43aa580db129e54408e719fb9659b7f9e0d52b965c5be26cdca416ecead28";
        };

        beamDeps = [
          ecto
          phoenix_html
          plug
        ];
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

      phoenix_live_dashboard = buildMix rec {
        name = "phoenix_live_dashboard";
        version = "0.7.2";

        src = fetchHex {
          pkg = "phoenix_live_dashboard";
          version = "${version}";
          sha256 = "0e5fdf063c7a3b620c566a30fcf68b7ee02e5e46fe48ee46a6ec3ba382dc05b7";
        };

        beamDeps = [
          ecto
          ecto_psql_extras
          mime
          phoenix_live_view
          telemetry_metrics
        ];
      };

      phoenix_live_view = buildMix rec {
        name = "phoenix_live_view";
        version = "0.18.18";

        src = fetchHex {
          pkg = "phoenix_live_view";
          version = "${version}";
          sha256 = "a5810d0472f3189ede6d2a95bda7f31c6113156b91784a3426cb0ab6a6d85214";
        };

        beamDeps = [
          jason
          phoenix
          phoenix_html
          phoenix_template
          phoenix_view
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
        version = "1.2.1";

        src = fetchHex {
          pkg = "phoenix_swoosh";
          version = "${version}";
          sha256 = "4000eeba3f9d7d1a6bf56d2bd56733d5cadf41a7f0d8ffe5bb67e7d667e204a2";
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
        version = "2.0.3";

        src = fetchHex {
          pkg = "phoenix_view";
          version = "${version}";
          sha256 = "cd34049af41be2c627df99cd4eaa71fc52a328c0c3d8e7d4aa28f880c30e7f64";
        };

        beamDeps = [
          phoenix_html
          phoenix_template
        ];
      };

      plug = buildMix rec {
        name = "plug";
        version = "1.15.3";

        src = fetchHex {
          pkg = "plug";
          version = "${version}";
          sha256 = "cc4365a3c010a56af402e0809208873d113e9c38c401cabd88027ef4f5c01fd2";
        };

        beamDeps = [
          mime
          plug_crypto
          telemetry
        ];
      };

      plug_cowboy = buildMix rec {
        name = "plug_cowboy";
        version = "2.7.1";

        src = fetchHex {
          pkg = "plug_cowboy";
          version = "${version}";
          sha256 = "02dbd5f9ab571b864ae39418db7811618506256f6d13b4a45037e5fe78dc5de3";
        };

        beamDeps = [
          cowboy
          cowboy_telemetry
          plug
        ];
      };

      plug_crypto = buildMix rec {
        name = "plug_crypto";
        version = "2.0.0";

        src = fetchHex {
          pkg = "plug_crypto";
          version = "${version}";
          sha256 = "53695bae57cc4e54566d993eb01074e4d894b65a3766f1c43e2c61a1b0f45ea9";
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
        version = "5.0.0";

        src = fetchHex {
          pkg = "poison";
          version = "${version}";
          sha256 = "11dc6117c501b80c62a7594f941d043982a1bd05a1184280c0d9166eb4d8d3fc";
        };

        beamDeps = [ decimal ];
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
        version = "0.17.5";

        src = fetchHex {
          pkg = "postgrex";
          version = "${version}";
          sha256 = "50b8b11afbb2c4095a3ba675b4f055c416d0f3d7de6633a595fc131a828a67eb";
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
        version = "2.5.5";

        src = fetchHex {
          pkg = "recon";
          version = "${version}";
          sha256 = "632a6f447df7ccc1a4a10bdcfce71514412b16660fe59deca0fcf0aa3c054404";
        };

        beamDeps = [ ];
      };

      remote_ip = buildMix rec {
        name = "remote_ip";
        version = "1.1.0";

        src = fetchHex {
          pkg = "remote_ip";
          version = "${version}";
          sha256 = "616ffdf66aaad6a72fc546dabf42eed87e2a99e97b09cbd92b10cc180d02ed74";
        };

        beamDeps = [
          combine
          plug
        ];
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
        version = "0.7.4";

        src = fetchHex {
          pkg = "sweet_xml";
          version = "${version}";
          sha256 = "e7c4b0bdbf460c928234951def54fe87edf1a170f6896675443279e2dbeba167";
        };

        beamDeps = [ ];
      };

      swoosh = buildMix rec {
        name = "swoosh";
        version = "1.14.4";

        src = fetchHex {
          pkg = "swoosh";
          version = "${version}";
          sha256 = "081c5a590e4ba85cc89baddf7b2beecf6c13f7f84a958f1cd969290815f0f026";
        };

        beamDeps = [
          cowboy
          ex_aws
          finch
          gen_smtp
          hackney
          jason
          mail
          mime
          plug
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
        version = "4.0.0";

        src = fetchHex {
          pkg = "table_rex";
          version = "${version}";
          sha256 = "c35c4d5612ca49ebb0344ea10387da4d2afe278387d4019e4d8111e815df8f55";
        };

        beamDeps = [ ];
      };

      telemetry = buildRebar3 rec {
        name = "telemetry";
        version = "1.2.1";

        src = fetchHex {
          pkg = "telemetry";
          version = "${version}";
          sha256 = "dad9ce9d8effc621708f99eac538ef1cbe05d6a874dd741de2e689c47feafed5";
        };

        beamDeps = [ ];
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

      telemetry_metrics_prometheus = buildMix rec {
        name = "telemetry_metrics_prometheus";
        version = "1.1.0";

        src = fetchHex {
          pkg = "telemetry_metrics_prometheus";
          version = "${version}";
          sha256 = "d43b3659b3244da44fe0275b717701542365d4519b79d9ce895b9719c1ce4d26";
        };

        beamDeps = [
          plug_cowboy
          telemetry_metrics_prometheus_core
        ];
      };

      telemetry_metrics_prometheus_core = buildMix rec {
        name = "telemetry_metrics_prometheus_core";
        version = "1.1.0";

        src = fetchHex {
          pkg = "telemetry_metrics_prometheus_core";
          version = "${version}";
          sha256 = "0dd10e7fe8070095df063798f82709b0a1224c31b8baf6278b423898d591a069";
        };

        beamDeps = [
          telemetry
          telemetry_metrics
        ];
      };

      telemetry_poller = buildRebar3 rec {
        name = "telemetry_poller";
        version = "1.1.0";

        src = fetchHex {
          pkg = "telemetry_poller";
          version = "${version}";
          sha256 = "9eb9d9cbfd81cbd7cdd24682f8711b6e2b691289a0de6826e58452f28c103c8f";
        };

        beamDeps = [ telemetry ];
      };

      tesla = buildMix rec {
        name = "tesla";
        version = "1.9.0";

        src = fetchHex {
          pkg = "tesla";
          version = "${version}";
          sha256 = "7c240c67e855f7e63e795bf16d6b3f5115a81d1f44b7fe4eadbf656bae0fef8a";
        };

        beamDeps = [
          castore
          finch
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
        version = "3.7.11";

        src = fetchHex {
          pkg = "timex";
          version = "${version}";
          sha256 = "8b9024f7efbabaf9bd7aa04f65cf8dcd7c9818ca5737677c7b76acbc6a94d1aa";
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
        version = "1.0.2";

        src = fetchHex {
          pkg = "unsafe";
          version = "${version}";
          sha256 = "b485231683c3ab01a9cd44cb4a79f152c6f3bb87358439c6f68791b85c2df675";
        };

        beamDeps = [ ];
      };

      vex = buildMix rec {
        name = "vex";
        version = "0.9.2";

        src = fetchHex {
          pkg = "vex";
          version = "${version}";
          sha256 = "76e709a9762e98c6b462dfce92e9b5dfbf712839227f2da8add6dd11549b12cb";
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
        version = "0.5.6";

        src = fetchHex {
          pkg = "websock_adapter";
          version = "${version}";
          sha256 = "e04378d26b0af627817ae84c92083b7e97aca3121196679b73c73b99d0d133ea";
        };

        beamDeps = [
          plug
          plug_cowboy
          websock
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
