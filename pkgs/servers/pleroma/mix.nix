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
        pkg = "${name}";
        version = "${version}";
        sha256 = "1f0vmjjyyz8klhdb3k8zrcxpidhfy6706327nmisnbnc1ci8rc8i";
      };

      beamDeps = [];
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

    base64url = buildRebar3 rec {
      name = "base64url";
      version = "0.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1yf1m1587vd9l6w4x5b36g4kxrxqfpwbqk2l4mkqinzmwch9pc7s";
      };

      beamDeps = [];
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
      version = "2.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0s9psinz913l690xbcrl21m23zwinw4r2ypjgg7ybl3f9wfxd09c";
      };

      beamDeps = [ comeonin elixir_make ];
    };

    benchee = buildMix rec {
      name = "benchee";
      version = "1.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1nxd6blgmalb1qm9n11yaq24din2grc3pnnfsx6wkiz9hzkqmm9s";
      };

      beamDeps = [ deep_merge ];
    };

    bunt = buildMix rec {
      name = "bunt";
      version = "0.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0lw3v9kwbbcy1v6ygziiky887gffwwmxvyg4r1v0zm71kzhcgxbs";
      };

      beamDeps = [];
    };

    cachex = buildMix rec {
      name = "cachex";
      version = "3.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "189irin4xkbnj6b3ih1h5fvli1xq6m1sz1xiyqryyk71vphmw3nr";
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
      version = "0.1.10";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0r96zwva2g6q59vyar8swaka0vxx27xfpf17xar2ss25rgh190x4";
      };

      beamDeps = [];
    };

    certifi = buildRebar3 rec {
      name = "certifi";
      version = "2.8.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1slp20z2fgcq9p2bbdp1gj218kjqpx5jsa95sq40nq7qqv0yziva";
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
      version = "5.3.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "012zr4s7b5bipng6yszqxkqr1lcv7imf8gyvxad56jachh1396fh";
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
      version = "2.0.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1sls8rns2k48qrga0ngysbn9aknapmn3xfn28by1gqbcir0y2jpf";
      };

      beamDeps = [ plug ];
    };

    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.9.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1phv0a1zbgk7imfgcm0dlacm7hbjcdygb0pqmx4s26jf9f9rywic";
      };

      beamDeps = [ cowlib ranch ];
    };

    cowboy_telemetry = buildRebar3 rec {
      name = "cowboy_telemetry";
      version = "0.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1bzhcdq12p837cii2jgvzjyrffiwgm5bsb1pra2an3hkcqrzsvis";
      };

      beamDeps = [ cowboy telemetry ];
    };

    cowlib = buildRebar3 rec {
      name = "cowlib";
      version = "2.11.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1ac6pj3x4vdbsa8hvmbzpdfc4k0v1p102jbd39snai8wnah9sgib";
      };

      beamDeps = [];
    };

    credo = buildMix rec {
      name = "credo";
      version = "1.5.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1pj7h9fk3i3rhxs65z8d64nwbnddhqj0dwy9bn2nm5cif2mj71nx";
      };

      beamDeps = [ bunt file_system jason ];
    };

    crontab = buildMix rec {
      name = "crontab";
      version = "1.1.8";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1gkb7ps38j789acj8dw2q7jnhhw43idyvh36fb3i52yjkhli7ra8";
      };

      beamDeps = [ ecto ];
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
      version = "2.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1j6psw0dxq1175b6zcqpm6vavv4n6sv72ji57l8b6qczmlhnqhdd";
      };

      beamDeps = [ connection telemetry ];
    };

    decimal = buildMix rec {
      name = "decimal";
      version = "2.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0xzm8hfhn8q02rmg8cpgs68n5jz61wvqg7bxww9i1a6yanf6wril";
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

    earmark = buildMix rec {
      name = "earmark";
      version = "1.4.15";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1vlrk5zmx1v5jnkkmchxwns8yy1kclzkcz0g6xpmiwy9bfw0j4iv";
      };

      beamDeps = [ earmark_parser ];
    };

    earmark_parser = buildMix rec {
      name = "earmark_parser";
      version = "1.4.13";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1fhlh9bnph5nqdhy7w69xzb7lra1b3v16mk4yb947bx0ydmc40nn";
      };

      beamDeps = [];
    };

    eblurhash = buildRebar3 rec {
      name = "eblurhash";
      version = "1.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "07dmkbyafpxffh8ar6af4riqfxiqc547rias7i73gpgx16fqhsrf";
      };

      beamDeps = [];
    };

    ecto = buildMix rec {
      name = "ecto";
      version = "3.6.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0kl893yi9jxzxnpd5gafivzazn96z2q24y04lfw8dyg60kxnvbgg";
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

    ecto_sql = buildMix rec {
      name = "ecto_sql";
      version = "3.6.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0syv5wjdkywaxx9mmps0x9sdawqp3nnakbnf7av3ksj2yzkdgjay";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
    };

    eimp = buildRebar3 rec {
      name = "eimp";
      version = "1.0.14";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1dl3xdfd42y389fc3sbssva163jgpy48pni2kqnvjy9027rk64ah";
      };

      beamDeps = [ p1_utils ];
    };

    elixir_make = buildMix rec {
      name = "elixir_make";
      version = "0.6.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1na8agkks1hrwq1lxfj4yd96bvfcs4hk7mbra9z6lli2vanrxr03";
      };

      beamDeps = [];
    };

    esshd = buildMix rec {
      name = "esshd";
      version = "0.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "10cryiv674p2mn9gvncl9j3rzgv0523chz9q6sm91lq960g38gnp";
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

    ex2ms = buildMix rec {
      name = "ex2ms";
      version = "1.5.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "13vh9yrs60cifqxzw52n6xxdp174w704vm1ks45k4avrzla763b7";
      };

      beamDeps = [];
    };

    ex_aws = buildMix rec {
      name = "ex_aws";
      version = "2.1.9";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "040dmj94xg3wnk9wplm0myr2q12zad4w1xz1zc0n01y90dkpfv1y";
      };

      beamDeps = [ hackney jason sweet_xml ];
    };

    ex_aws_s3 = buildMix rec {
      name = "ex_aws_s3";
      version = "2.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1g91dd4jfmqp9ds8ji5kqlgcm2bk6ajci3mpi0grxqki6dhmq5qm";
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
      version = "0.24.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1nmpdxydbc1khcayab98gfv7km2qrqmgp1s64kjdkf11x3cy2d71";
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
      version = "1.5.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "16c376cvw0bcjz8a6gs3nhmg037i894gl5kgxi8jdinv6r0sp7xb";
      };

      beamDeps = [ poison syslog ];
    };

    excoveralls = buildMix rec {
      name = "excoveralls";
      version = "0.12.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1nnsr9dv7mybcxx3y5p2gqzyy3p479w21c55vvsq6hi6dihkx2jn";
      };

      beamDeps = [ hackney jason ];
    };

    fast_html = buildMix rec {
      name = "fast_html";
      version = "2.0.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1sk1fwib6x5isb3sy8g5i6gw0n6pfqrza12r89gas0pw3ma9vd1v";
      };

      beamDeps = [ elixir_make nimble_pool ];
    };

    fast_sanitize = buildMix rec {
      name = "fast_sanitize";
      version = "0.2.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0rj4x64rl7pspagp30dhw9yzal4q2c8937am1m5akbshjbdh9wk9";
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
      version = "0.30.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1f3b2wd1pmsgkl8np13pwgp57161p0wxfwnnrjzlq73x8hj3bh79";
      };

      beamDeps = [ html_entities ];
    };

    gen_smtp = buildRebar3 rec {
      name = "gen_smtp";
      version = "0.15.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "03s40l97j6z4mx6a84cbl9w94v3dvfw4f97dqx4hi61hh2l19g99";
      };

      beamDeps = [];
    };

    gen_stage = buildMix rec {
      name = "gen_stage";
      version = "0.14.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0xld8m2l9a7pbzmq7vp0r9mz4pkisrjpslgbjs9ikhwlkllf4lw4";
      };

      beamDeps = [];
    };

    gen_state_machine = buildMix rec {
      name = "gen_state_machine";
      version = "2.0.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1j21ih8cm0kkirjd2dh0gcxhngf5h3dvv4gqw6khj9ibww2x9b2w";
      };

      beamDeps = [];
    };

    gettext = buildMix rec {
      name = "gettext";
      version = "0.18.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1igmn69xzj5wpkblg3k9v7wa2fjc2j0cncwx0grk1pag7nqkgxgr";
      };

      beamDeps = [];
    };

    gun = buildRebar3 rec {
      name = "gun";
      version = "2.0.0-rc.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1z2lsbbpl2925z8x2ri0rhp30ccn9d08pgqd2hkxf4342jp1x7bb";
      };

      beamDeps = [ cowlib ];
    };

    hackney = buildRebar3 rec {
      name = "hackney";
      version = "1.18.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0pjwbf87nqj2ki3i076whrswh2cdhklj6cbaikdj1mq40xidmz4s";
      };

      beamDeps = [ certifi idna metrics mimerl parse_trans ssl_verify_fun unicode_util_compat ];
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

    html_sanitize_ex = buildMix rec {
      name = "html_sanitize_ex";
      version = "1.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1mhr2jnyzrqv0298m6vghnc9v2iwck11kwfhyh07gmc8v0x3kyxb";
      };

      beamDeps = [ mochiweb ];
    };

    http_signatures = buildMix rec {
      name = "http_signatures";
      version = "0.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "097q5jffswcaav40i8dhlds6hgdhsz53yd3fz8w7vl9z3rrv79zq";
      };

      beamDeps = [];
    };

    httpoison = buildMix rec {
      name = "httpoison";
      version = "1.8.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0fiwkdrbj7mmz449skp7laz2jdwsqn3svddncmicd46gk2m9w218";
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
      version = "1.2.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0y91s7q8zlfqd037c1mhqdhrvrf60l4ax7lzya1y33h5y3sji8hq";
      };

      beamDeps = [ decimal ];
    };

    joken = buildMix rec {
      name = "joken";
      version = "2.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "07mwnzzb9slhzqjmd0nbs4dyjkbb3v06km82mhvdbi8fkjkn7cjp";
      };

      beamDeps = [ jose ];
    };

    jose = buildMix rec {
      name = "jose";
      version = "1.11.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1i8szzpmiqc7xdv0lp38ng9fild7c5182b4pzkx4qbydnfgnr3q7";
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

    libring = buildMix rec {
      name = "libring";
      version = "1.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "10bvf64jkviyyyff12hlhq4p2439gphyvmya8z85m0c6x1gg1shz";
      };

      beamDeps = [];
    };

    linkify = buildMix rec {
      name = "linkify";
      version = "0.5.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0i7r9z49sdxs7nrnh2igmwzzmq9ih4fm02a046klmnps49z8q4m3";
      };

      beamDeps = [];
    };

    makeup = buildMix rec {
      name = "makeup";
      version = "1.0.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1a9cp9zp85yfybhdxapi9haa1yykzq91bw8abmk0qp1z5p05i8fg";
      };

      beamDeps = [ nimble_parsec ];
    };

    makeup_elixir = buildMix rec {
      name = "makeup_elixir";
      version = "0.14.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04fyrd0fcyfvv4i3ngm3gbykhfrp9z6l2p1bhgg9xv7ah0d8nhzj";
      };

      beamDeps = [ makeup ];
    };

    makeup_erlang = buildMix rec {
      name = "makeup_erlang";
      version = "0.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1fvw0zr7vqd94vlj62xbqh0yrih1f7wwnmlj62rz0klax44hhk8p";
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

    mochiweb = buildRebar3 rec {
      name = "mochiweb";
      version = "2.18.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "16j8cfn3hq0g474xc5xl8nk2v46hwvwpfwi9rkzavnsbaqg2ngmr";
      };

      beamDeps = [];
    };

    mock = buildMix rec {
      name = "mock";
      version = "0.3.7";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0p3yrx049fdw88kjidngd2lkwqkkyck5r51ng2dxj7z41539m92d";
      };

      beamDeps = [ meck ];
    };

    mogrify = buildMix rec {
      name = "mogrify";
      version = "0.7.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1hwry2498qflc4g7fdwmxmzb2l0gr5c814ggzddwjsxsgwrrxmsh";
      };

      beamDeps = [];
    };

    mox = buildMix rec {
      name = "mox";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1pzlqq9y4i9i7d0dm8ah2c5a7y2h9649gkz9hfqamnmbnwh0l6r0";
      };

      beamDeps = [];
    };

    nimble_parsec = buildMix rec {
      name = "nimble_parsec";
      version = "0.5.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1cx9p22kkywkg40yqy9xswy4ighdw7i8cc9x1481pzy1d620n12w";
      };

      beamDeps = [];
    };

    nimble_pool = buildMix rec {
      name = "nimble_pool";
      version = "0.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1ygkr9ddzd3msif7hkqd75q27zlryhm9zww3191z7p0dcam1wfil";
      };

      beamDeps = [];
    };

    oban = buildMix rec {
      name = "oban";
      version = "2.3.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1prgpp7v03lgkia63j60jz3ds479ymm4991f882iizaq8x1s0367";
      };

      beamDeps = [ ecto_sql jason postgrex telemetry ];
    };

    open_api_spex = buildMix rec {
      name = "open_api_spex";
      version = "3.10.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0rc7q857b8zb9vc4c699arjihca353rzm3bfjc31z0ib7pg2pfrd";
      };

      beamDeps = [ jason plug poison ];
    };

    p1_utils = buildRebar3 rec {
      name = "p1_utils";
      version = "1.0.18";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "120znzz0yw1994nk6v28zql9plgapqpv51n9g6qm6md1f4x7gj0z";
      };

      beamDeps = [];
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

    pbkdf2_elixir = buildMix rec {
      name = "pbkdf2_elixir";
      version = "1.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "07s862m4y74fyv9gwdhrhx04rvpfrwgqkjlyy51b9w1h8r50md6k";
      };

      beamDeps = [ comeonin ];
    };

    phoenix = buildMix rec {
      name = "phoenix";
      version = "1.5.9";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0za2fpplmdq3axwng8736h6vz9wzlifhxy8apcgjy0bwlqhcwjvy";
      };

      beamDeps = [ jason phoenix_html phoenix_pubsub plug plug_cowboy plug_crypto telemetry ];
    };

    phoenix_ecto = buildMix rec {
      name = "phoenix_ecto";
      version = "4.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1h23fy3pylaszh3l2zafq1a7fjwlwb3yw7dy09p0mb4wi6p1p2j7";
      };

      beamDeps = [ ecto phoenix_html plug ];
    };

    phoenix_html = buildMix rec {
      name = "phoenix_html";
      version = "2.14.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "03z8r285znlg25yi47d4l59s7jq58y4dnhvbxgp16npkzykrgmpg";
      };

      beamDeps = [ plug ];
    };

    phoenix_pubsub = buildMix rec {
      name = "phoenix_pubsub";
      version = "2.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0wgpa19l6xar0k2m117iz2kq3cw433llp07sqswpf5969y698bf5";
      };

      beamDeps = [];
    };

    phoenix_swoosh = buildMix rec {
      name = "phoenix_swoosh";
      version = "0.3.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1k81cvhbzbc3czvin45j1rqagzp7drk3s0rp2xa5clz06bm0qm2a";
      };

      beamDeps = [ hackney phoenix phoenix_html swoosh ];
    };

    plug = buildMix rec {
      name = "plug";
      version = "1.10.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1874ixvvjklg0hnxr6d990qzarvvfxhd4s35c5bfqbixwwzj67md";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_cowboy = buildMix rec {
      name = "plug_cowboy";
      version = "2.5.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "06p7rmx01fknkf0frvjjaqs3qsz6066aa41qyd378n72lljqjb2v";
      };

      beamDeps = [ cowboy cowboy_telemetry plug telemetry ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "1.2.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1nxnxj62iv4yvm4771jbxpj3l4brn2crz053y12s998lv5x1qqw7";
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
      version = "3.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1kng8xadrs03i77irxvdk9vfncrqzncmgxc5gc8y8gkknw76dj7y";
      };

      beamDeps = [];
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
      version = "0.15.9";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1vmd63vxwz8knid424b0rbp200vj7q7rz3xp98yj5cjc7q81j1v1";
      };

      beamDeps = [ connection db_connection decimal jason ];
    };

    pot = buildRebar3 rec {
      name = "pot";
      version = "1.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0vgvpiwiy1gm2npfm3qdybwvg39jllw13aig8ll1bn9icnbzb1zd";
      };

      beamDeps = [];
    };

    prometheus = buildMix rec {
      name = "prometheus";
      version = "4.8.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1dgwd8wxw2cifwmsmjvkbgr1n686n125ssm4b0vxngh70dqy3hhg";
      };

      beamDeps = [];
    };

    prometheus_ecto = buildMix rec {
      name = "prometheus_ecto";
      version = "1.4.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "10pd5cmm6m62xwlfp7al8yj62zn181rjizc1v9zb64zrfygjhrld";
      };

      beamDeps = [ ecto prometheus_ex ];
    };

    prometheus_phoenix = buildMix rec {
      name = "prometheus_phoenix";
      version = "1.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0xccdidbzffgy2mpy18p017ijcgav2kv47b0v9ixklz9qi541lf4";
      };

      beamDeps = [ phoenix prometheus_ex ];
    };

    prometheus_plugs = buildMix rec {
      name = "prometheus_plugs";
      version = "1.1.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0ybazh6r52vjpf14gjcphsavl3ggk9iapc0rr9wnv4yb7i4acwq2";
      };

      beamDeps = [ accept plug prometheus_ex ];
    };

    quack = buildMix rec {
      name = "quack";
      version = "0.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0hr5ppds4a9vih14hzs3lfj07r5069w8ifr7022fn4j18jkvydnp";
      };

      beamDeps = [ poison tesla ];
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
      version = "2.5.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0j26nin8h3zzypppkdxsjiwgjc8jm8n73b6cikvdh8h1snvcc8ap";
      };

      beamDeps = [];
    };

    sleeplocks = buildRebar3 rec {
      name = "sleeplocks";
      version = "1.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1q823i5bisc83pyssgrqkggyxiasm7b8dygzj2r943adzyp3gvl4";
      };

      beamDeps = [];
    };

    ssl_verify_fun = buildRebar3 rec {
      name = "ssl_verify_fun";
      version = "1.1.6";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1026l1z1jh25z8bfrhaw0ryk5gprhrpnirq877zqhg253x3x5c5x";
      };

      beamDeps = [];
    };

    sweet_xml = buildMix rec {
      name = "sweet_xml";
      version = "0.7.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "sha256-aJTmihIPRUU02ZBF6jMl93QOpxJgvDFfguKXMdVwpug=";
      };

      beamDeps = [];
    };

    swoosh = buildMix rec {
      name = "swoosh";
      version = "1.3.11";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1bqkp41sh4h0q5yjmk0ywf5x979rwxshz16gp619jks5vd4a1qpi";
      };

      beamDeps = [ cowboy gen_smtp hackney jason mime plug_cowboy ];
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

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "0.4.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0hc0fr2bh97wah9ycpm7hb5jdqr5hnl1s3b2ibbbx9gxbwvbhwpb";
      };

      beamDeps = [];
    };

    tesla = buildMix rec {
      name = "tesla";
      version = "1.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "06i0rshkm1byzgsphbr3al4hns7bcrpl1rxy8lwlp31cj8sxxxcm";
      };

      beamDeps = [ castore gun hackney jason mime poison telemetry ];
    };

    timex = buildMix rec {
      name = "timex";
      version = "3.7.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1r3l50p8f8mxgghh079v1y5g02kzqr15ijbi7mkfzwl0lvf0hmm1";
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
      version = "1.0.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0nia83zpk0pb4jkpvhkmmgw8i5p6kd6cf776q6aj0pcym6i9llam";
      };

      beamDeps = [ hackney ];
    };

    ueberauth = buildMix rec {
      name = "ueberauth";
      version = "0.6.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0q0vz7vlbw66a32d7yij3p5l4a59bi0sygiynn8na38ll7c97hmg";
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
  };
in self
