{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    argon2_elixir = buildMix rec {
      name = "argon2_elixir";
      version = "3.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0wyxj4197jnz4z38611f00ym5n3w7hv06l4l3dfid4h2xvhfm3y0";
      };

      beamDeps = [ comeonin elixir_make ];
    };

    base62 = buildMix rec {
      name = "base62";
      version = "1.2.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1fvpygkdmd7l737lv7svir8n1vhk0m094i8ygwcvx9gam2ykc4yl";
      };

      beamDeps = [ custom_base ];
    };

    bbcode_pleroma = buildMix rec {
      name = "bbcode_pleroma";
      version = "0.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1hyixcxhcf2j2gyavmmnvfslnl6z60dz1qa9xysfspws85s1118r";
      };

      beamDeps = [ nimble_parsec ];
    };

    bcrypt_elixir = buildMix rec {
      name = "bcrypt_elixir";
      version = "3.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1kwnzcjf6v4af12nzw5b2fksk1m1fvbxvhclczy1wpb4zdgbjss8";
      };

      beamDeps = [ comeonin elixir_make ];
    };

    benchee = buildMix rec {
      name = "benchee";
      version = "1.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "14vdbvmkkqhcqvilq1w8zl895f4hpbv7fw2q5c0ml5h3a1a7v9bx";
      };

      beamDeps = [ deep_merge statistex ];
    };

    bunt = buildMix rec {
      name = "bunt";
      version = "0.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19bp6xh052ql3ha0v3r8999cvja5d2p6cph02mxphfaj4jsbyc53";
      };

      beamDeps = [];
    };

    cachex = buildMix rec {
      name = "cachex";
      version = "3.6.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1qp2r1f4hvpybhgi547p33ci7bh2w6xn6jl9il68xg4370vlxwpb";
      };

      beamDeps = [ eternal jumper sleeplocks unsafe ];
    };

    calendar = buildMix rec {
      name = "calendar";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0vqa1zpzsdgr6i3yx8j9b6qscvgrbvzn43p5bqm930hcja0ra3lr";
      };

      beamDeps = [ tzdata ];
    };

    castore = buildMix rec {
      name = "castore";
      version = "1.0.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "02rrljx2f6zhmiwqwyk7al0gdf66qpx4jm59sqg1cnyiylgb02k8";
      };

      beamDeps = [];
    };

    certifi = buildRebar3 rec {
      name = "certifi";
      version = "2.9.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0ha6vmf5p3xlbf5w1msa89frhvfk535rnyfybz9wdmh6vdms8v96";
      };

      beamDeps = [];
    };

    combine = buildMix rec {
      name = "combine";
      version = "0.10.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "06s5y8b0snr1s5ax9v3s7rc6c8xf5vj6878d1mc7cc07j0bvq78v";
      };

      beamDeps = [];
    };

    comeonin = buildMix rec {
      name = "comeonin";
      version = "5.3.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1pw4rhhsh8mwj26dkbxz2niih9j8pc3qijlpcl8jh208rg1cjf1y";
      };

      beamDeps = [];
    };

    connection = buildMix rec {
      name = "connection";
      version = "1.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1746n8ba11amp1xhwzp38yfii2h051za8ndxlwdykyqqljq1wb3j";
      };

      beamDeps = [];
    };

    cors_plug = buildMix rec {
      name = "cors_plug";
      version = "3.0.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "03c3vwp4bdk3sixica4mmg0vinmx8qdz2bmbby1x6bi7ijg7ab9z";
      };

      beamDeps = [ plug ];
    };

    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.10.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0sqxqjdykxc2ai9cvkc0xjwkvr80z98wzlqlrd1z3iiw32vwrz9s";
      };

      beamDeps = [ cowlib ranch ];
    };

    cowboy_telemetry = buildRebar3 rec {
      name = "cowboy_telemetry";
      version = "0.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1pn90is3k9dq64wbijvzkqb6ldfqvwiqi7ymc8dx6ra5xv0vm63x";
      };

      beamDeps = [ cowboy telemetry ];
    };

    cowlib = buildRebar3 rec {
      name = "cowlib";
      version = "2.12.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1c4dgi8canscyjgddp22mjc69znvwy44wk3r7jrl2wvs6vv76fqn";
      };

      beamDeps = [];
    };

    credo = buildMix rec {
      name = "credo";
      version = "1.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1mv9lyw6hgjn6hlnzfbs0x2dchvwlmj8bg0a8l7iq38z7pvgqfb8";
      };

      beamDeps = [ bunt file_system jason ];
    };

    custom_base = buildMix rec {
      name = "custom_base";
      version = "0.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0qx47d4w2mxa3rr6mrxdasgk7prxqwd0y9zpjhz61jayrkx1kw4d";
      };

      beamDeps = [];
    };

    db_connection = buildMix rec {
      name = "db_connection";
      version = "2.5.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "18jsnmabdjwj3i7ml43ljzrzzvfy1a3bnbaqywgsv7nndji5nbf9";
      };

      beamDeps = [ telemetry ];
    };

    decimal = buildMix rec {
      name = "decimal";
      version = "2.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1k7z418b6cj977wswpxsk5844xrxc1smaiqsmrqpf3pdjzsfbksk";
      };

      beamDeps = [];
    };

    deep_merge = buildMix rec {
      name = "deep_merge";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0c2li2a3hxcc05nwvy4kpsal0315yk900kxyybld972b15gqww6f";
      };

      beamDeps = [];
    };

    dialyxir = buildMix rec {
      name = "dialyxir";
      version = "1.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0vv90jip2w362n3l7dkhqfdwlz97nwji535kn3fbk3dassya9ch0";
      };

      beamDeps = [ erlex ];
    };

    earmark = buildMix rec {
      name = "earmark";
      version = "1.4.39";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0h547ri1nbxyaisyx7jddg3wib7fpm3q4v914szwvv6bqf79sv0m";
      };

      beamDeps = [ earmark_parser ];
    };

    earmark_parser = buildMix rec {
      name = "earmark_parser";
      version = "1.4.33";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "13qvlqnii8g6bcz6cl330vjwaan7jy30g1app3yvjncvf8rnhlid";
      };

      beamDeps = [];
    };

    eblurhash = buildRebar3 rec {
      name = "eblurhash";
      version = "1.2.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0k040pj8hlm8mwy0ra459hk35v9gfsvvgp596nl27q2dj00cl84c";
      };

      beamDeps = [];
    };

    ecto = buildMix rec {
      name = "ecto";
      version = "3.10.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0crlrpl392pbkzl6ar4z6afna8h9d46wshky1zbr3m344d7cggj4";
      };

      beamDeps = [ decimal jason telemetry ];
    };

    ecto_enum = buildMix rec {
      name = "ecto_enum";
      version = "1.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1r2ffrr020fhfviqn21cv06sd3sp4bf1jra0xrgb3hl1f445rdcg";
      };

      beamDeps = [ ecto ecto_sql postgrex ];
    };

    ecto_psql_extras = buildMix rec {
      name = "ecto_psql_extras";
      version = "0.7.12";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0k3iczvfj7m77170falil6h49r4hih1p54m952j37q2cnw81s7aa";
      };

      beamDeps = [ ecto_sql postgrex table_rex ];
    };

    ecto_sql = buildMix rec {
      name = "ecto_sql";
      version = "3.10.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0sy5277akp828hvcg60yxhpfgj543y2z1bqy2z414pv9ppdmp8pn";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
    };

    elixir_make = buildMix rec {
      name = "elixir_make";
      version = "0.6.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "05ppvbhqi5m9zk1c4xnrki814sqhxrc7d1dpvfmwm2v7qm8xdjzm";
      };

      beamDeps = [];
    };

    erlex = buildMix rec {
      name = "erlex";
      version = "0.2.6";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0x8c1j62y748ldvlh46sxzv5514rpzm809vxn594vd7y25by5lif";
      };

      beamDeps = [];
    };

    eternal = buildMix rec {
      name = "eternal";
      version = "1.2.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "10p7m6kv2z2c16gw36wgiwnkykss4lfkmm71llxp09ipkhmy77rc";
      };

      beamDeps = [];
    };

    ex_aws = buildMix rec {
      name = "ex_aws";
      version = "2.4.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1iqxr74m7wwqbjkrzrm6xs2ri9kshabh1wpk0jw6zcd2bi43xmm7";
      };

      beamDeps = [ hackney jason mime sweet_xml telemetry ];
    };

    ex_aws_s3 = buildMix rec {
      name = "ex_aws_s3";
      version = "2.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1fsngrldq2g3i2f7y5m4d85sd7hx4jiwnfcxhs14bnalfziadpc5";
      };

      beamDeps = [ ex_aws sweet_xml ];
    };

    ex_const = buildMix rec {
      name = "ex_const";
      version = "0.2.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0rwppain0bd36krph1as0vxlxb42psc6mlkfi67jp6fc21k39zcn";
      };

      beamDeps = [];
    };

    ex_doc = buildMix rec {
      name = "ex_doc";
      version = "0.30.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1dhqi5qx2fkphia0g7x2qg6pib08wsbn4dyyg7gmxln18qh71j7v";
      };

      beamDeps = [ earmark_parser makeup_elixir makeup_erlang ];
    };

    ex_machina = buildMix rec {
      name = "ex_machina";
      version = "2.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1y2v4j1zg1ji8q8di0fxpc3z3n2jmbnc85d6hx68j4fykfisg6j1";
      };

      beamDeps = [ ecto ecto_sql ];
    };

    ex_syslogger = buildMix rec {
      name = "ex_syslogger";
      version = "2.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "17h1p3l3a3icqlkyxglw4wwqxxhjb1indas9s7nfdsb42zkjyax5";
      };

      beamDeps = [ jason syslog ];
    };

    excoveralls = buildMix rec {
      name = "excoveralls";
      version = "0.16.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0f7i5gx1rpswbqmmqv133v3lpjwpkhjb2k56fmqcy210ir367rys";
      };

      beamDeps = [ hackney jason ];
    };

    expo = buildMix rec {
      name = "expo";
      version = "0.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0iyfl4vppfhmimfqaracjza9a6y8rgia03sm28y5934cg5xbmxrg";
      };

      beamDeps = [];
    };

    fast_html = buildMix rec {
      name = "fast_html";
      version = "2.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1bpvmqw4pcx8ssgmazvqn0dm6b3g0m5rij6shy8qy5m6nhilyk06";
      };

      beamDeps = [ elixir_make nimble_pool ];
    };

    fast_sanitize = buildMix rec {
      name = "fast_sanitize";
      version = "0.2.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1qjnbs63q0d95dqhh2r9sz3zpg2y4hjy23kxsqanwf6h21njibg8";
      };

      beamDeps = [ fast_html plug ];
    };

    file_system = buildMix rec {
      name = "file_system";
      version = "0.2.10";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1p0myxmnjjds8bbg69dd6fvhk8q3n7lb78zd4qvmjajnzgdmw6a1";
      };

      beamDeps = [];
    };

    finch = buildMix rec {
      name = "finch";
      version = "0.16.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1iayffbjzb1rcy1p0wibzv6j5n7dc16ha5lhcbn5z7ji9m61fq7n";
      };

      beamDeps = [ castore mime mint nimble_options nimble_pool telemetry ];
    };

    flake_id = buildMix rec {
      name = "flake_id";
      version = "0.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "09yq3dlqqrb7v4ysblwpz1al0q5qcmryldkwq1kx5b71zn881z1i";
      };

      beamDeps = [ base62 ecto ];
    };

    floki = buildMix rec {
      name = "floki";
      version = "0.34.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0h936kfai562dh4qpcpri7jxrdmqyxaymizk9d5r55svx8748xwm";
      };

      beamDeps = [];
    };

    gen_smtp = buildRebar3 rec {
      name = "gen_smtp";
      version = "1.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0yb7541zx0x76gzk0m1m8fkl6524jhl8rxc59l6g5a5wh1b3gq2y";
      };

      beamDeps = [ ranch ];
    };

    gettext = buildMix rec {
      name = "gettext";
      version = "0.22.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1gb49f75apkgfa5ddg02x08w1i3qm31jifzicrl4m58kfx226pwk";
      };

      beamDeps = [ expo ];
    };

    hackney = buildRebar3 rec {
      name = "hackney";
      version = "1.18.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "13hja14kig5jnzcizpdghj68i88f0yd9wjdfjic9nzi98kzxmv54";
      };

      beamDeps = [ certifi idna metrics mimerl parse_trans ssl_verify_fun unicode_util_compat ];
    };

    hpax = buildMix rec {
      name = "hpax";
      version = "0.1.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04wci9ifsfyd2pbcrnpgh2aq0a8fi1lpkrzb91kz3x93b8yq91rc";
      };

      beamDeps = [];
    };

    html_entities = buildMix rec {
      name = "html_entities";
      version = "0.5.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1k7xyj0q38ms3n5hbn782pa6w1vgd6biwlxr4db6319l828a6fy5";
      };

      beamDeps = [];
    };

    http_signatures = buildMix rec {
      name = "http_signatures";
      version = "0.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "18s2b5383xl2qjijkxag4mvwk2p5kv2fw58c9ii7pk12fc08lfyc";
      };

      beamDeps = [];
    };

    httpoison = buildMix rec {
      name = "httpoison";
      version = "1.8.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "08crb48yz7r7w00pzw9gfk862g99z2ma2x6awab0rqvjd7951crb";
      };

      beamDeps = [ hackney ];
    };

    idna = buildRebar3 rec {
      name = "idna";
      version = "6.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1sjcjibl34sprpf1dgdmzfww24xlyy34lpj7mhcys4j4i6vnwdwj";
      };

      beamDeps = [ unicode_util_compat ];
    };

    inet_cidr = buildMix rec {
      name = "inet_cidr";
      version = "1.0.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1g61i08cizr99ivy050lv8fmvnwia9zmipfvlwff8jkhi40x78k4";
      };

      beamDeps = [];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "18d70i31bz11nr6vgsjn5prvhkvwqbyf3xq22ck5cnsnzp6ixc7v";
      };

      beamDeps = [ decimal ];
    };

    joken = buildMix rec {
      name = "joken";
      version = "2.6.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19xanmavc4n5zzypxyi4qd93m8l7sjqswy2ksfmm82ydf5db15as";
      };

      beamDeps = [ jose ];
    };

    jose = buildMix rec {
      name = "jose";
      version = "1.11.6";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0f4pzx8xdzjkkfjkl442w6lhajgfzsnp3dxcxrh1x72ga1swnxb2";
      };

      beamDeps = [];
    };

    jumper = buildMix rec {
      name = "jumper";
      version = "1.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0cvlbfkapkvbwaijmjq3cxg5m6yv4rh69wvss9kfj862i83mk31i";
      };

      beamDeps = [];
    };

    mail = buildMix rec {
      name = "mail";
      version = "0.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0v0i0xwhsqvdxxyacmcf25pqyda87yqkn7g49vf8gn1i485p0gaj";
      };

      beamDeps = [];
    };

    majic = buildMix rec {
      name = "majic";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "17hab8kmqc6gsiqicfgsaik0rvmakb6mbshlbxllj3b5fs7qa1br";
      };

      beamDeps = [ elixir_make mime nimble_pool plug ];
    };

    makeup = buildMix rec {
      name = "makeup";
      version = "1.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19jpprryixi452jwhws3bbks6ki3wni9kgzah3srg22a3x8fsi8a";
      };

      beamDeps = [ nimble_parsec ];
    };

    makeup_elixir = buildMix rec {
      name = "makeup_elixir";
      version = "0.16.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1ik7qw0d5xyc7dv3n33qxl49jfk92l565lbv1zc9n80vmm0s69z1";
      };

      beamDeps = [ makeup nimble_parsec ];
    };

    makeup_erlang = buildMix rec {
      name = "makeup_erlang";
      version = "0.1.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "02411riqa713wzw8in582yva6n6spi4w1ndnj8nhjvnfjg5a3xgk";
      };

      beamDeps = [ makeup ];
    };

    meck = buildRebar3 rec {
      name = "meck";
      version = "0.9.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "09jq0jrsd3dwzjlnwqjv6m9r2rijgiv57yja6jl41p2p2db4yd41";
      };

      beamDeps = [];
    };

    metrics = buildRebar3 rec {
      name = "metrics";
      version = "1.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "05lz15piphyhvvm3d1ldjyw0zsrvz50d2m5f2q3s8x2gvkfrmc39";
      };

      beamDeps = [];
    };

    mime = buildMix rec {
      name = "mime";
      version = "1.6.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19qrpnmaf3w8bblvkv6z5g82hzd10rhc7bqxvqyi88c37xhsi89i";
      };

      beamDeps = [];
    };

    mimerl = buildRebar3 rec {
      name = "mimerl";
      version = "1.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "08wkw73dy449n68ssrkz57gikfzqk3vfnf264s31jn5aa1b5hy7j";
      };

      beamDeps = [];
    };

    mint = buildMix rec {
      name = "mint";
      version = "1.5.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "07jvgmggmv6bxhkmrskdjz1xvv0a1l53fby7sammcfbwdbky2qsa";
      };

      beamDeps = [ castore hpax ];
    };

    mock = buildMix rec {
      name = "mock";
      version = "0.3.8";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "08i0zvk3wss217pjr4qczmdgxi607wcp2mfinydxf5vnr5j27a3z";
      };

      beamDeps = [ meck ];
    };

    mogrify = buildMix rec {
      name = "mogrify";
      version = "0.9.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1rii2yjswnbivmdfnxljvqw3vlpgkhiqikz8k8mmyi97vvhv3281";
      };

      beamDeps = [];
    };

    mox = buildMix rec {
      name = "mox";
      version = "1.0.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1wpyh6wp76lyx0q2cys23rpmci4gj1pqwnqvfk467xxanchlk1pr";
      };

      beamDeps = [];
    };

    nimble_options = buildMix rec {
      name = "nimble_options";
      version = "1.0.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1f7ih1rnkvph0daf4lsv4rrp6dpccksjd7rh5bhnq0r143dsh4px";
      };

      beamDeps = [];
    };

    nimble_parsec = buildMix rec {
      name = "nimble_parsec";
      version = "1.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0rxiw6jzz77v0j460wmzcprhdgn71g1hrz3mcc6djn7bnb0f70i6";
      };

      beamDeps = [];
    };

    nimble_pool = buildMix rec {
      name = "nimble_pool";
      version = "0.2.6";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0gv59waa505mz2gi956sj1aa6844c65w2dp2qh2jfgsx15am0w8w";
      };

      beamDeps = [];
    };

    oban = buildMix rec {
      name = "oban";
      version = "2.15.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1sgickk10b73pkddfhk5vhmi8vjn065wzyl41ng4iiwgljg5fjhg";
      };

      beamDeps = [ ecto_sql jason postgrex telemetry ];
    };

    open_api_spex = buildMix rec {
      name = "open_api_spex";
      version = "3.17.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1zphp59dd3l4l8279pjmhbddskimbgrr123wivycz0yahldb4p8n";
      };

      beamDeps = [ jason plug poison ];
    };

    parse_trans = buildRebar3 rec {
      name = "parse_trans";
      version = "3.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "12w8ai6b5s6b4hnvkav7hwxd846zdd74r32f84nkcmjzi1vrbk87";
      };

      beamDeps = [];
    };

    phoenix = buildMix rec {
      name = "phoenix";
      version = "1.6.16";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0fdca3h6k9plv1qvch6zyl6wbnfhp8jisvggjmmsjw7n6kzqjng1";
      };

      beamDeps = [ castore jason phoenix_pubsub phoenix_view plug plug_cowboy plug_crypto telemetry ];
    };

    phoenix_ecto = buildMix rec {
      name = "phoenix_ecto";
      version = "4.4.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0pcgrvj5lqjmsngrhl77kv0l8ik8gg7pw19v4xlhpm818vfjw93h";
      };

      beamDeps = [ ecto phoenix_html plug ];
    };

    phoenix_html = buildMix rec {
      name = "phoenix_html";
      version = "3.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1lyhagjpg4lran6431csgkvf28g50mdvh4mlsxgs21j9vmp91ldy";
      };

      beamDeps = [ plug ];
    };

    phoenix_live_dashboard = buildMix rec {
      name = "phoenix_live_dashboard";
      version = "0.7.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1dq5vj1a6fzclr3fwj7y8rg2xq3yigvgqc3aaq664fvs7h3dypqf";
      };

      beamDeps = [ ecto ecto_psql_extras mime phoenix_live_view telemetry_metrics ];
    };

    phoenix_live_view = buildMix rec {
      name = "phoenix_live_view";
      version = "0.18.18";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "052jv2kbc2nb4qs4ly4idcai6q8wyfkvv59adpg9w67kf820v0d5";
      };

      beamDeps = [ jason phoenix phoenix_html phoenix_template phoenix_view telemetry ];
    };

    phoenix_pubsub = buildMix rec {
      name = "phoenix_pubsub";
      version = "2.1.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "00p5dvizhawhqbia2cakdn4whaxsm2adq3lzfn3b137xvk0np85v";
      };

      beamDeps = [];
    };

    phoenix_swoosh = buildMix rec {
      name = "phoenix_swoosh";
      version = "1.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1fhxh4sff7b3qz2lyryzgms9d6mrhxnmlh924awid6p8a5r133g8";
      };

      beamDeps = [ finch hackney phoenix phoenix_html phoenix_view swoosh ];
    };

    phoenix_template = buildMix rec {
      name = "phoenix_template";
      version = "1.0.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0b4fbp9dhfii6njksm35z8xf4bp8lw5hr7bv0p6g6lj1i9cbdx0n";
      };

      beamDeps = [ phoenix_html ];
    };

    phoenix_view = buildMix rec {
      name = "phoenix_view";
      version = "2.0.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0vykabqxyk08gkfm45zy5dnlnzygwx6g9z4z2h7fxix51qiyfad9";
      };

      beamDeps = [ phoenix_html phoenix_template ];
    };

    plug = buildMix rec {
      name = "plug";
      version = "1.14.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04wdyv6nma74bj1m49vkm2bc5mjf8zclfg957fng8g71hw0wabw4";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_cowboy = buildMix rec {
      name = "plug_cowboy";
      version = "2.6.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04v6xc4v741dr2y38j66fmcc4xc037dnaxzkj2vih6j53yif2dny";
      };

      beamDeps = [ cowboy cowboy_telemetry plug ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "1.2.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0hnqgzc3zas7j7wycgnkkdhaji5farkqccy2n4p1gqj5ccfrlm16";
      };

      beamDeps = [];
    };

    plug_static_index_html = buildMix rec {
      name = "plug_static_index_html";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1kxm1flxw3rnsj5jj24c2p23wq1wyblbl32n4rf6046i6k7lzzbr";
      };

      beamDeps = [ plug ];
    };

    poison = buildMix rec {
      name = "poison";
      version = "5.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1z6kv2s6w5nrq20446510nys30ir0hfr8ksrlxi0rf01qlbn3p0i";
      };

      beamDeps = [ decimal ];
    };

    poolboy = buildRebar3 rec {
      name = "poolboy";
      version = "1.5.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1qq116314418jp4skxg8c6jx29fwp688a738lgaz6h2lrq29gmys";
      };

      beamDeps = [];
    };

    postgrex = buildMix rec {
      name = "postgrex";
      version = "0.17.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "036r3q250vrhj4nmyr4cc40krjgbyci18qkhppvkj7akx6liiac0";
      };

      beamDeps = [ db_connection decimal jason ];
    };

    pot = buildRebar3 rec {
      name = "pot";
      version = "1.0.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1q62ascgjgddq0l42nvysfwkxmbvh9qsd8m5dsfr2psgb9zi5zkq";
      };

      beamDeps = [];
    };

    ranch = buildRebar3 rec {
      name = "ranch";
      version = "1.8.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1rfz5ld54pkd2w25jadyznia2vb7aw9bclck21fizargd39wzys9";
      };

      beamDeps = [];
    };

    recon = buildMix rec {
      name = "recon";
      version = "2.5.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1mwr6267lwl4p7f8jfk14s4cszxwra6zgf84hkcxz8fldzs86rkc";
      };

      beamDeps = [];
    };

    remote_ip = buildMix rec {
      name = "remote_ip";
      version = "1.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0x7d086iik0h5gcwn2bvx6cjlznqxr1bznj6qlpsgmmadbvgsvv1";
      };

      beamDeps = [ combine plug ];
    };

    sleeplocks = buildRebar3 rec {
      name = "sleeplocks";
      version = "1.1.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19argym7xifhsbrp21glkgs0dz1xpd00yfhsbhqdd0dpqm4d1rcz";
      };

      beamDeps = [];
    };

    ssl_verify_fun = buildRebar3 rec {
      name = "ssl_verify_fun";
      version = "1.1.7";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1y37pj5q6gk1vrnwg1vraws9yihrv9g4133w2qq1sh1piw71jk7y";
      };

      beamDeps = [];
    };

    statistex = buildMix rec {
      name = "statistex";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "09vcm2sz2llv00cm7krkx3n5r8ra1b42zx9gfjs8l0imf3p8p7gz";
      };

      beamDeps = [];
    };

    sweet_xml = buildMix rec {
      name = "sweet_xml";
      version = "0.7.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1fpmwhqgvakvdpbwmmyh31ays3hzhnm9766xqyzp9zmkl5kwh471";
      };

      beamDeps = [];
    };

    swoosh = buildMix rec {
      name = "swoosh";
      version = "1.11.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "03rxj2jdrjg6pab05iz8myr0j9fi3d1v7z2bc3hnli9a08a0jffk";
      };

      beamDeps = [ cowboy ex_aws finch gen_smtp hackney jason mail mime plug_cowboy telemetry ];
    };

    syslog = buildRebar3 rec {
      name = "syslog";
      version = "1.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1qarnqappln4xhlr700rhnhfnfvgvv9l3y1ywdxmh83y7hvl2sjc";
      };

      beamDeps = [];
    };

    table_rex = buildMix rec {
      name = "table_rex";
      version = "3.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "141404hwnwnpspvhs112j2la8dfnvkwr0xy14ff42w6nljmj72k7";
      };

      beamDeps = [];
    };

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "1.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1mgyx9zw92g6w8fp9pblm3b0bghwxwwcbslrixq23ipzisfwxnfs";
      };

      beamDeps = [];
    };

    telemetry_metrics = buildMix rec {
      name = "telemetry_metrics";
      version = "0.6.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1iilk2n75kn9i95fdp8mpxvn3rcn3ghln7p77cijqws13j3y1sbv";
      };

      beamDeps = [ telemetry ];
    };

    telemetry_metrics_prometheus = buildMix rec {
      name = "telemetry_metrics_prometheus";
      version = "1.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "09jdrv0ik5svi77djycva7a6a8sl05vp2nr7w17s8k94ndckcfyl";
      };

      beamDeps = [ plug_cowboy telemetry_metrics_prometheus_core ];
    };

    telemetry_metrics_prometheus_core = buildMix rec {
      name = "telemetry_metrics_prometheus_core";
      version = "1.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0sd0j7arhf22ickzdfmq656258dh14kzi61p0vgra007x1zhxl8d";
      };

      beamDeps = [ telemetry telemetry_metrics ];
    };

    telemetry_poller = buildRebar3 rec {
      name = "telemetry_poller";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0vjgxkxn9ll1gc6xd8jh4b0ldmg9l7fsfg7w63d44gvcssplx8mk";
      };

      beamDeps = [ telemetry ];
    };

    tesla = buildMix rec {
      name = "tesla";
      version = "1.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04y31nq54j1wnzpi37779bzzq0sjwsh53ikvnh4n40nvpwgg0r1f";
      };

      beamDeps = [ castore finch hackney jason mime mint poison telemetry ];
    };

    timex = buildMix rec {
      name = "timex";
      version = "3.7.11";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1anijimbrb3ngdy6fdspr8c9hz6dip7nakx0gayzkfmsxzvj944b";
      };

      beamDeps = [ combine gettext tzdata ];
    };

    trailing_format_plug = buildMix rec {
      name = "trailing_format_plug";
      version = "0.0.7";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0gv9z8m1kpfs5f5zcsh9m6vr36s88x1xc6g0k6lr7sgk2m6dwkxx";
      };

      beamDeps = [ plug ];
    };

    tzdata = buildMix rec {
      name = "tzdata";
      version = "1.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "11wpm1mjla8hbkb5mssprg3gsq1v24s8m8nyk3hx5z7aaa1yr756";
      };

      beamDeps = [ hackney ];
    };

    ueberauth = buildMix rec {
      name = "ueberauth";
      version = "0.10.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1qf97azn8064ymawfm58p2bqpmrigipr4fs5xp3jb8chshqizz9y";
      };

      beamDeps = [ plug ];
    };

    unicode_util_compat = buildRebar3 rec {
      name = "unicode_util_compat";
      version = "0.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "08952lw8cjdw8w171lv8wqbrxc4rcmb3jhkrdb7n06gngpbfdvi5";
      };

      beamDeps = [];
    };

    unsafe = buildMix rec {
      name = "unsafe";
      version = "1.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1rahpgz1lsd66r7ycns1ryz2qymamz1anrlps986900lsai2jxvc";
      };

      beamDeps = [];
    };

    vex = buildMix rec {
      name = "vex";
      version = "0.9.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0zw51hj525xiiggjk9n5ciix6pdhr8fvl6z7mqgkzan8sm2gz7y6";
      };

      beamDeps = [];
    };

    web_push_encryption = buildMix rec {
      name = "web_push_encryption";
      version = "0.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "18p2f1gqkg209vf3nychjxy7xpxhgiwyhn4halvr7yr2fvjv50jg";
      };

      beamDeps = [ httpoison jose ];
    };

    websockex = buildMix rec {
      name = "websockex";
      version = "0.4.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1r2kmi2pcmdzvgbd08ci9avy0g5p2lhx80jn736a98w55c3ygwlm";
      };

      beamDeps = [];
    };
  };
in self

