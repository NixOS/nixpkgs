{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    argon2_elixir = buildMix rec {
      name = "argon2_elixir";
<<<<<<< HEAD
      version = "3.1.0";
=======
      version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0wyxj4197jnz4z38611f00ym5n3w7hv06l4l3dfid4h2xvhfm3y0";
=======
        sha256 = "0mywrvzzm76glvajzxrdg6ka49xby30fpk9zl4dxamzm18kknxcb";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "3.0.1";
=======
      version = "2.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1kwnzcjf6v4af12nzw5b2fksk1m1fvbxvhclczy1wpb4zdgbjss8";
=======
        sha256 = "0ybjs37fyn45x31lzhxic4kd4jmzwcwkgy4spwayykbn8rgjs622";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "1.0.3";
=======
      version = "0.1.22";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "02rrljx2f6zhmiwqwyk7al0gdf66qpx4jm59sqg1cnyiylgb02k8";
=======
        sha256 = "1b1cl89fzkykimxwgm8mwb9wmxcrd8qk8hfc83pa2npb8zgpcxf1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
=======
    concurrent_limiter = buildMix rec {
      name = "concurrent_limiter";
      version = "0.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1sqnb987qwwy4ip7kxh9g7vv5wz61fpv3pbnxpbv9yy073r8z5jk";
      };

      beamDeps = [ telemetry ];
    };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "3.0.3";
=======
      version = "2.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "03c3vwp4bdk3sixica4mmg0vinmx8qdz2bmbby1x6bi7ijg7ab9z";
=======
        sha256 = "1sls8rns2k48qrga0ngysbn9aknapmn3xfn28by1gqbcir0y2jpf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [ plug ];
    };

    cowboy = buildErlangMk rec {
      name = "cowboy";
<<<<<<< HEAD
      version = "2.10.0";
=======
      version = "2.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0sqxqjdykxc2ai9cvkc0xjwkvr80z98wzlqlrd1z3iiw32vwrz9s";
=======
        sha256 = "1phv0a1zbgk7imfgcm0dlacm7hbjcdygb0pqmx4s26jf9f9rywic";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [ cowlib ranch ];
    };

    cowboy_telemetry = buildRebar3 rec {
      name = "cowboy_telemetry";
<<<<<<< HEAD
      version = "0.4.0";
=======
      version = "0.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1pn90is3k9dq64wbijvzkqb6ldfqvwiqi7ymc8dx6ra5xv0vm63x";
=======
        sha256 = "1bzhcdq12p837cii2jgvzjyrffiwgm5bsb1pra2an3hkcqrzsvis";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [ cowboy telemetry ];
    };

    cowlib = buildRebar3 rec {
      name = "cowlib";
<<<<<<< HEAD
      version = "2.12.1";
=======
      version = "2.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1c4dgi8canscyjgddp22mjc69znvwy44wk3r7jrl2wvs6vv76fqn";
=======
        sha256 = "1ac6pj3x4vdbsa8hvmbzpdfc4k0v1p102jbd39snai8wnah9sgib";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [];
    };

<<<<<<< HEAD
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

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "2.5.0";
=======
      version = "2.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "18jsnmabdjwj3i7ml43ljzrzzvfy1a3bnbaqywgsv7nndji5nbf9";
      };

      beamDeps = [ telemetry ];
=======
        sha256 = "04iwywfqf8k125yfvm084l1mp0bcv82mwih7xlpb7kx61xdw29y1";
      };

      beamDeps = [ connection telemetry ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    decimal = buildMix rec {
      name = "decimal";
<<<<<<< HEAD
      version = "2.1.1";
=======
      version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1k7z418b6cj977wswpxsk5844xrxc1smaiqsmrqpf3pdjzsfbksk";
=======
        sha256 = "0xzm8hfhn8q02rmg8cpgs68n5jz61wvqg7bxww9i1a6yanf6wril";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "1.3.0";
=======
      version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0vv90jip2w362n3l7dkhqfdwlz97nwji535kn3fbk3dassya9ch0";
=======
        sha256 = "0qw4zyd86fjwsav744jvz1wpdbmy9nz645xqr9s1d1bs88v221v1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [ erlex ];
    };

    earmark = buildMix rec {
      name = "earmark";
<<<<<<< HEAD
      version = "1.4.39";
=======
      version = "1.4.37";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0h547ri1nbxyaisyx7jddg3wib7fpm3q4v914szwvv6bqf79sv0m";
=======
        sha256 = "01mibj51iys1l289mk2adqs50hfbpfj643mh459nvf4dhq95wvfq";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [ earmark_parser ];
    };

    earmark_parser = buildMix rec {
      name = "earmark_parser";
<<<<<<< HEAD
      version = "1.4.33";
=======
      version = "1.4.31";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "13qvlqnii8g6bcz6cl330vjwaan7jy30g1app3yvjncvf8rnhlid";
=======
        sha256 = "0nfhxyklbz0ixkl33xqkchqgdzk948dcjikym0vz0pikw1z3cz9i";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "3.10.3";
=======
      version = "3.9.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0crlrpl392pbkzl6ar4z6afna8h9d46wshky1zbr3m344d7cggj4";
=======
        sha256 = "0k5p40cy6zxi3wm885amf78724zvb5a8chmpljzw1kdsiifi3wyl";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "0.7.12";
=======
      version = "0.7.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0k3iczvfj7m77170falil6h49r4hih1p54m952j37q2cnw81s7aa";
=======
        sha256 = "123h3s4zpk5q618rcxlfz4axj3rz3cmyk68gps8c05sg3vc8qpjh";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [ ecto_sql postgrex table_rex ];
    };

    ecto_sql = buildMix rec {
      name = "ecto_sql";
<<<<<<< HEAD
      version = "3.10.1";
=======
      version = "3.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0sy5277akp828hvcg60yxhpfgj543y2z1bqy2z414pv9ppdmp8pn";
=======
        sha256 = "0w1zplm8ndf10dwxffg60iwzvbz3hyyiy761x91cvnwg6nsfxd8y";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "2.4.4";
=======
      version = "2.1.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1iqxr74m7wwqbjkrzrm6xs2ri9kshabh1wpk0jw6zcd2bi43xmm7";
      };

      beamDeps = [ hackney jason mime sweet_xml telemetry ];
=======
        sha256 = "040dmj94xg3wnk9wplm0myr2q12zad4w1xz1zc0n01y90dkpfv1y";
      };

      beamDeps = [ hackney jason sweet_xml ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "0.30.3";
=======
      version = "0.29.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1dhqi5qx2fkphia0g7x2qg6pib08wsbn4dyyg7gmxln18qh71j7v";
=======
        sha256 = "1qdzflf1lbi5phg2vs8p3aznz0p8wmmx56qynp1ix008gdypiiix";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "2.0.0";
=======
      version = "1.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "17h1p3l3a3icqlkyxglw4wwqxxhjb1indas9s7nfdsb42zkjyax5";
      };

      beamDeps = [ jason syslog ];
=======
        sha256 = "16c376cvw0bcjz8a6gs3nhmg037i894gl5kgxi8jdinv6r0sp7xb";
      };

      beamDeps = [ poison syslog ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    excoveralls = buildMix rec {
      name = "excoveralls";
<<<<<<< HEAD
      version = "0.16.1";
=======
      version = "0.15.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0f7i5gx1rpswbqmmqv133v3lpjwpkhjb2k56fmqcy210ir367rys";
=======
        sha256 = "1rq7vqvzw7sa2r7n59bhbxbhcnjr6z44dkvq45mdb0h01kcnnhgq";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [ hackney jason ];
    };

<<<<<<< HEAD
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
=======
    fast_html = buildMix rec {
      name = "fast_html";
      version = "2.0.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1bpvmqw4pcx8ssgmazvqn0dm6b3g0m5rij6shy8qy5m6nhilyk06";
=======
        sha256 = "01k51qri44535b1hwixlxk7151vph6vapswlfq918g245544ypv0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "0.16.0";
=======
      version = "0.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1iayffbjzb1rcy1p0wibzv6j5n7dc16ha5lhcbn5z7ji9m61fq7n";
=======
        sha256 = "1pd805jyd4qbpb2md3kw443325yqynpkpyr2iixb9zf432psqnal";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "0.34.3";
=======
      version = "0.34.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0h936kfai562dh4qpcpri7jxrdmqyxaymizk9d5r55svx8748xwm";
=======
        sha256 = "1j6ilik6pviff34rrqr8456h7pp0qlash731pv36ny811w7xbf96";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [];
    };

    gen_smtp = buildRebar3 rec {
      name = "gen_smtp";
<<<<<<< HEAD
      version = "1.2.0";
=======
      version = "0.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0yb7541zx0x76gzk0m1m8fkl6524jhl8rxc59l6g5a5wh1b3gq2y";
      };

      beamDeps = [ ranch ];
=======
        sha256 = "03s40l97j6z4mx6a84cbl9w94v3dvfw4f97dqx4hi61hh2l19g99";
      };

      beamDeps = [];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    gettext = buildMix rec {
      name = "gettext";
<<<<<<< HEAD
      version = "0.22.3";
=======
      version = "0.20.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1gb49f75apkgfa5ddg02x08w1i3qm31jifzicrl4m58kfx226pwk";
      };

      beamDeps = [ expo ];
=======
        sha256 = "0ggb458h60ch3inndqp9xhbailhb0jkq3xnp85sa94sy8dvv20qw";
      };

      beamDeps = [];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "1.4.1";
=======
      version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "18d70i31bz11nr6vgsjn5prvhkvwqbyf3xq22ck5cnsnzp6ixc7v";
=======
        sha256 = "0891p2yrg3ri04p302cxfww3fi16pvvw1kh4r91zg85jhl87k8vr";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "1.11.6";
=======
      version = "1.11.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0f4pzx8xdzjkkfjkl442w6lhajgfzsnp3dxcxrh1x72ga1swnxb2";
=======
        sha256 = "115k981kfg9jmafgs16rybc5qah6p0zgvni3bdyfl0pyp8av5lyw";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "0.3.0";
=======
      version = "0.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0v0i0xwhsqvdxxyacmcf25pqyda87yqkn7g49vf8gn1i485p0gaj";
=======
        sha256 = "1xbbdkyar8h0pdihfnsd84j1w3vfh9sk3xkz1llxz7y6m67kjawk";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "0.16.1";
=======
      version = "0.16.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1ik7qw0d5xyc7dv3n33qxl49jfk92l565lbv1zc9n80vmm0s69z1";
=======
        sha256 = "1rrqydcq2bshs577z7jbgdnrlg7cpnzc8n48kap4c2ln2gfcpci8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [ makeup nimble_parsec ];
    };

    makeup_erlang = buildMix rec {
      name = "makeup_erlang";
<<<<<<< HEAD
      version = "0.1.2";
=======
      version = "0.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "02411riqa713wzw8in582yva6n6spi4w1ndnj8nhjvnfjg5a3xgk";
=======
        sha256 = "1fvw0zr7vqd94vlj62xbqh0yrih1f7wwnmlj62rz0klax44hhk8p";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "0.3.8";
=======
      version = "0.3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "08i0zvk3wss217pjr4qczmdgxi607wcp2mfinydxf5vnr5j27a3z";
=======
        sha256 = "0p3yrx049fdw88kjidngd2lkwqkkyck5r51ng2dxj7z41539m92d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [ meck ];
    };

    mogrify = buildMix rec {
      name = "mogrify";
<<<<<<< HEAD
      version = "0.9.3";
=======
      version = "0.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1rii2yjswnbivmdfnxljvqw3vlpgkhiqikz8k8mmyi97vvhv3281";
=======
        sha256 = "17b9dy40rq3rwn7crjggjafibxz4ys4nqq81adcf486af3yi13f1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "1.0.2";
=======
      version = "0.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1f7ih1rnkvph0daf4lsv4rrp6dpccksjd7rh5bhnq0r143dsh4px";
=======
        sha256 = "1q6wa2ljprybfb9w2zg0gbppiwsnimgw5kcvakdp3z8mp42gk9sd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [];
    };

    nimble_parsec = buildMix rec {
      name = "nimble_parsec";
<<<<<<< HEAD
      version = "1.3.1";
=======
      version = "1.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0rxiw6jzz77v0j460wmzcprhdgn71g1hrz3mcc6djn7bnb0f70i6";
=======
        sha256 = "1c3hnppmjkwnqrc9vvm72kpliav0mqyyk4cjp7vsqccikgiqkmy8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "2.15.2";
=======
      version = "2.12.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1sgickk10b73pkddfhk5vhmi8vjn065wzyl41ng4iiwgljg5fjhg";
=======
        sha256 = "0n6h8a6v9hzk6s5dhadfbrvwnx2nkl64n575ff5ph3afnz14864v";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [ ecto_sql jason postgrex telemetry ];
    };

    open_api_spex = buildMix rec {
      name = "open_api_spex";
<<<<<<< HEAD
      version = "3.17.3";
=======
      version = "3.16.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1zphp59dd3l4l8279pjmhbddskimbgrr123wivycz0yahldb4p8n";
=======
        sha256 = "1yyvvyzzi6k2l55fl4wijhrzzdjns95asxcbnikgh6hjmiwdfvzg";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "4.4.2";
=======
      version = "4.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0pcgrvj5lqjmsngrhl77kv0l8ik8gg7pw19v4xlhpm818vfjw93h";
=======
        sha256 = "1h9wnjmxns8y8dsr0r41ks66gscaqm7ivk4gsh5y07nkiralx1h9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "2.1.3";
=======
      version = "2.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "00p5dvizhawhqbia2cakdn4whaxsm2adq3lzfn3b137xvk0np85v";
=======
        sha256 = "1nfqrmbrq45if9pgk6g6vqiply2sxc40is3bfanphn7a3rnpqdl1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [];
    };

    phoenix_swoosh = buildMix rec {
      name = "phoenix_swoosh";
<<<<<<< HEAD
      version = "1.2.0";
=======
      version = "0.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1fhxh4sff7b3qz2lyryzgms9d6mrhxnmlh924awid6p8a5r133g8";
      };

      beamDeps = [ finch hackney phoenix phoenix_html phoenix_view swoosh ];
=======
        sha256 = "072pa2rnzkvw645f3jh15rmgsnzccbyqjx1wbsmj28138qc24w9r";
      };

      beamDeps = [ hackney phoenix phoenix_html swoosh ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };

    phoenix_template = buildMix rec {
      name = "phoenix_template";
<<<<<<< HEAD
      version = "1.0.3";
=======
      version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0b4fbp9dhfii6njksm35z8xf4bp8lw5hr7bv0p6g6lj1i9cbdx0n";
=======
        sha256 = "1vlkd4z2bxinczwcysydidpnh49rpxjihb5k3k4k8qr2yrwc0z8m";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "0.17.2";
=======
      version = "0.16.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "036r3q250vrhj4nmyr4cc40krjgbyci18qkhppvkj7akx6liiac0";
      };

      beamDeps = [ db_connection decimal jason ];
=======
        sha256 = "1s5jbwfzsdsyvlwgx3bqlfwilj2c468wi3qxq0c2d23fvhwxdspd";
      };

      beamDeps = [ connection db_connection decimal jason ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "1.1.7";
=======
      version = "1.1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1y37pj5q6gk1vrnwg1vraws9yihrv9g4133w2qq1sh1piw71jk7y";
=======
        sha256 = "1026l1z1jh25z8bfrhaw0ryk5gprhrpnirq877zqhg253x3x5c5x";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "1.11.4";
=======
      version = "1.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "03rxj2jdrjg6pab05iz8myr0j9fi3d1v7z2bc3hnli9a08a0jffk";
=======
        sha256 = "07ipsrp34s18c9zd5kglqsdc8z7gxa9aadsrklj0zf6azzrzzpvn";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "1.2.1";
=======
      version = "0.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "1mgyx9zw92g6w8fp9pblm3b0bghwxwwcbslrixq23ipzisfwxnfs";
=======
        sha256 = "0hc0fr2bh97wah9ycpm7hb5jdqr5hnl1s3b2ibbbx9gxbwvbhwpb";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      version = "1.0.0";
=======
      version = "0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "0vjgxkxn9ll1gc6xd8jh4b0ldmg9l7fsfg7w63d44gvcssplx8mk";
=======
        sha256 = "1m1zcq65yz0wp1wx7mcy2iq37cyizbzrmv0c11x6xg0hj8375asc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };

      beamDeps = [ telemetry ];
    };

    tesla = buildMix rec {
      name = "tesla";
<<<<<<< HEAD
      version = "1.7.0";
=======
      version = "1.4.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
<<<<<<< HEAD
        sha256 = "04y31nq54j1wnzpi37779bzzq0sjwsh53ikvnh4n40nvpwgg0r1f";
=======
        sha256 = "0mv48vgby1fv9b2npc0ird3y4isr10np3a3yas3v5hfyz54kll6m";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

