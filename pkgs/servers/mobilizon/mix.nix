{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    absinthe = buildMix rec {
      name = "absinthe";
      version = "1.7.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "05n33srckncg3f50nxzx3r05n8axiwb2c4p91snr8qm2vj5a7a92";
      };

      beamDeps = [ dataloader decimal nimble_parsec telemetry ];
    };

    absinthe_phoenix = buildMix rec {
      name = "absinthe_phoenix";
      version = "2.0.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "139gnamfbba5hyk1fx1zf8vfr0j17fd9q0vxxp9cf39qbj91hsfk";
      };

      beamDeps = [ absinthe absinthe_plug decimal phoenix phoenix_html phoenix_pubsub ];
    };

    absinthe_plug = buildMix rec {
      name = "absinthe_plug";
      version = "1.5.8";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0nkfk5gqbg8yvlysgxfcak7y4lsy8q2jfyqyhql5hwvvciv43c5v";
      };

      beamDeps = [ absinthe plug ];
    };

    argon2_elixir = buildMix rec {
      name = "argon2_elixir";
      version = "3.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "142n65kcfsci052d0f7rzqzz0gg4xq7hgj7lzjsk0i9r2y1bf4x8";
      };

      beamDeps = [ comeonin elixir_make ];
    };

    atomex = buildMix rec {
      name = "atomex";
      version = "0.5.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0gxb379zfx5qk0ljxvy225iplxfvxbgfx470h8wm1f6abwdqjj32";
      };

      beamDeps = [ xml_builder ];
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
      version = "2.12.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "077z80ijg0nfyslgdfl72c2wcfl76c7i1gmlrm040m9fy9fxhs7f";
      };

      beamDeps = [];
    };

    cldr_utils = buildMix rec {
      name = "cldr_utils";
      version = "2.24.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "101p43y2x6z6rd4ga5hr372z5y34rn3mm3j6pk84kf5m642k080q";
      };

      beamDeps = [ castore certifi decimal ];
    };

    codepagex = buildMix rec {
      name = "codepagex";
      version = "0.1.6";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0ndxsmalk70wqig1zzgl95g6mp2fb992y1l4y3nq3qnxjw84c88m";
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
      version = "5.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1wgsa5p4lfs9v8chky6as0w7a6j8n0545f5pasfrj08dwnlr6qvr";
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

    credo_code_climate = buildMix rec {
      name = "credo_code_climate";
      version = "0.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1ji1d2qidnlz80pc3ql2ghwvhf1851c4fq0xh8ly5x2nh3irylkm";
      };

      beamDeps = [ credo jason ];
    };

    dataloader = buildMix rec {
      name = "dataloader";
      version = "2.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1w7ygm885fidf8i5q89ya1mg800dy0zqig6djpiidqkcny0igmh9";
      };

      beamDeps = [ ecto telemetry ];
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

    dialyxir = buildMix rec {
      name = "dialyxir";
      version = "1.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "00cqwhd1wabwds44jz94rvvr8z8cp12884d3lp69fqkrszb9bdw4";
      };

      beamDeps = [ erlex ];
    };

    digital_token = buildMix rec {
      name = "digital_token";
      version = "0.6.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1lf4vp5bdjz4hmm6zb0knqz8qm4jn3fwma540a5i46n6wwkdcm94";
      };

      beamDeps = [ cldr_utils jason ];
    };

    doctor = buildMix rec {
      name = "doctor";
      version = "0.21.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1q748x232m665qik23mb1rywp9267i0gmvfy9jr4wy3rm8fq69x2";
      };

      beamDeps = [ decimal ];
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

    ecto_autoslug_field = buildMix rec {
      name = "ecto_autoslug_field";
      version = "3.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1zyr5zlsi8zwc4q8gkhw324h43a46k4k558nbi5y4qsjh0addpdn";
      };

      beamDeps = [ ecto slugify ];
    };

    ecto_dev_logger = buildMix rec {
      name = "ecto_dev_logger";
      version = "0.9.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1mf2068xqzv7dns2xyzl57cgm6hhbbdggvlni08cgz749a5wk2rf";
      };

      beamDeps = [ ecto jason ];
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

    ecto_shortuuid = buildMix rec {
      name = "ecto_shortuuid";
      version = "0.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0rgvivrvl504jgfh2yqgcd74ar3q1qbxxwzngrd2zsbbx1qknbmr";
      };

      beamDeps = [ ecto shortuuid ];
    };

    ecto_sql = buildMix rec {
      name = "ecto_sql";
      version = "3.10.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "01whmapzs08xzachra73lhb0d8f7mvysz29qbqivjz55pkg1ih38";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
    };

    elixir_feed_parser = buildMix rec {
      name = "elixir_feed_parser";
      version = "2.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "13x2rgckh41zkgbwg63wb7lvyy5xmn7vqq3i7nvy6virggz64g1d";
      };

      beamDeps = [ timex ];
    };

    elixir_make = buildMix rec {
      name = "elixir_make";
      version = "0.7.7";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0v3y9i3bif14486dliwn9arwd0pcp4nv24gjwnxm5b8gjpzrzhav";
      };

      beamDeps = [ castore ];
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

    erlport = buildRebar3 rec {
      name = "erlport";
      version = "0.11.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1r7f0j12gnx65p6c86w035rjlzp1sa52ghyip0lx6j1rmz63dccf";
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

    ex_cldr = buildMix rec {
      name = "ex_cldr";
      version = "2.37.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1fljryh921whv90v6m1aax2rabybark3nw11cv76lwc0a0fpnin8";
      };

      beamDeps = [ cldr_utils decimal gettext jason nimble_parsec ];
    };

    ex_cldr_calendars = buildMix rec {
      name = "ex_cldr_calendars";
      version = "1.22.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0s812jkj4hf5274gp568syk3xp2d9228wwkn7gwjx2rix3cqqh77";
      };

      beamDeps = [ ex_cldr_numbers ex_doc jason ];
    };

    ex_cldr_currencies = buildMix rec {
      name = "ex_cldr_currencies";
      version = "2.15.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1y3g1q0g7ygcajqzqh9kb1y3kchbarkrf89nssi7fs66jrik2885";
      };

      beamDeps = [ ex_cldr jason ];
    };

    ex_cldr_dates_times = buildMix rec {
      name = "ex_cldr_dates_times";
      version = "2.14.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "155z81x9z0wwd4l32rbq2pc64rp6kmdz35vsvz1fqskgah08nnpq";
      };

      beamDeps = [ ex_cldr_calendars ex_cldr_numbers jason ];
    };

    ex_cldr_languages = buildMix rec {
      name = "ex_cldr_languages";
      version = "0.3.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0yj4rj4r0wdzhrwkg1xdg1x28d1pp3kk8fr45n3v9d5pfbpizyr2";
      };

      beamDeps = [ ex_cldr jason ];
    };

    ex_cldr_numbers = buildMix rec {
      name = "ex_cldr_numbers";
      version = "2.32.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0jjh9a5w5ybvzpxpvia3kgig50h259yjgfbbhnsmcnv0p0k3ri08";
      };

      beamDeps = [ decimal digital_token ex_cldr ex_cldr_currencies jason ];
    };

    ex_cldr_plugs = buildMix rec {
      name = "ex_cldr_plugs";
      version = "1.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1zwbhpj9cxr2bl16cn5539hslj8gqi0q0xmfky27qjm17ra9i6k9";
      };

      beamDeps = [ ex_cldr gettext jason plug ];
    };

    ex_doc = buildMix rec {
      name = "ex_doc";
      version = "0.30.6";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "17qhflrr5mrbavcw7pg6xabib270k2a3sagr4z3q5r7lmkfz4j5x";
      };

      beamDeps = [ earmark_parser makeup_elixir makeup_erlang ];
    };

    ex_ical = buildMix rec {
      name = "ex_ical";
      version = "0.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1yxyflmkvmglks7whmbz944kyq6qljjpki666dk9w9g058xlfxnv";
      };

      beamDeps = [ timex ];
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

    ex_optimizer = buildMix rec {
      name = "ex_optimizer";
      version = "0.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "11i2npj15w3a91lxdpf9ll7lpdv99zf7y9bg5yz6d2ympicw1xg6";
      };

      beamDeps = [ file_info ];
    };

    ex_unit_notifier = buildMix rec {
      name = "ex_unit_notifier";
      version = "1.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0rf3b2cb4fqsg0hgas9axr8p5p471ainzc788ky65ng8c9hgvzsm";
      };

      beamDeps = [];
    };

    excoveralls = buildMix rec {
      name = "excoveralls";
      version = "0.17.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1q2sk1kha63hyp03wf3m9r30aqikh241jjns2h7wd11yjpd6zg4m";
      };

      beamDeps = [ castore jason ];
    };

    exgravatar = buildMix rec {
      name = "exgravatar";
      version = "2.0.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1q80jcrnagivsjr9mz0z9h4bwlf0xyyx6ijl7szd74c9ppwqz8dc";
      };

      beamDeps = [];
    };

    expo = buildMix rec {
      name = "expo";
      version = "0.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0idzpg3bc9ady0lqrkxs6y0x9daffjsapppfm9cf0vf545h56b62";
      };

      beamDeps = [];
    };

    export = buildMix rec {
      name = "export";
      version = "0.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "07q2l7f9yr3bd3xqc5q1qa9qrhnjzc9xnjrg6lj1hgq5yi7l99rx";
      };

      beamDeps = [ erlport ];
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

    file_info = buildMix rec {
      name = "file_info";
      version = "0.0.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19c14xv0xzbl3m6y5p7dlxn8sfqi9bff8pv722837ff8q80svrsh";
      };

      beamDeps = [ mimetype_parser ];
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

    geo = buildMix rec {
      name = "geo";
      version = "3.5.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "175mqwzdn4jkwxkklc3k97pbnc4mxjfsw49cld92nh0lyb2zsp66";
      };

      beamDeps = [ jason ];
    };

    geo_postgis = buildMix rec {
      name = "geo_postgis";
      version = "3.4.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1p7pdwrfbg244n50lhv27xbkmvgfi47y71nwbggzj5v469j36zc2";
      };

      beamDeps = [ geo jason postgrex ];
    };

    geohax = buildMix rec {
      name = "geohax";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0912z8fn86r7sxgbvhmzfqvbxc96v5awklhmqrkwnfi10pwz4gl9";
      };

      beamDeps = [];
    };

    geolix = buildMix rec {
      name = "geolix";
      version = "2.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1pq1qcjaqsnnvsbgzzbfdj290n9mkp808cj45kppvfyhircbyhl7";
      };

      beamDeps = [];
    };

    geolix_adapter_mmdb2 = buildMix rec {
      name = "geolix_adapter_mmdb2";
      version = "0.6.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "16r6q2qmgdpj5pvb36s3rgfd1qm6rnzp8szqzp7i18z8x8prdzq6";
      };

      beamDeps = [ geolix mmdb2_decoder ];
    };

    gettext = buildMix rec {
      name = "gettext";
      version = "0.20.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0ggb458h60ch3inndqp9xhbailhb0jkq3xnp85sa94sy8dvv20qw";
      };

      beamDeps = [];
    };

    guardian = buildMix rec {
      name = "guardian";
      version = "2.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1hvl8ajr49f8lv2b79dbi33bn016kl2dchmd2vczl28vrbwl3qmv";
      };

      beamDeps = [ jose plug ];
    };

    guardian_db = buildMix rec {
      name = "guardian_db";
      version = "2.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0w0d9bwsiz7hw9i7b3v8gpjsvblzhbkcnnpxlzrrbhwjmi1xbrzq";
      };

      beamDeps = [ ecto ecto_sql guardian postgrex ];
    };

    guardian_phoenix = buildMix rec {
      name = "guardian_phoenix";
      version = "2.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1350z7sk4m8n2wxllnjm07gzpm8ybm3811i23wijn68mcwj3kx11";
      };

      beamDeps = [ guardian phoenix ];
    };

    hackney = buildRebar3 rec {
      name = "hackney";
      version = "1.18.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1zb59ghnlmlqcxkcr9caj7sbdv16ah7a394hf0jxnmvqz74xb55g";
      };

      beamDeps = [ certifi idna metrics mimerl parse_trans ssl_verify_fun unicode_util_compat ];
    };

    hammer = buildMix rec {
      name = "hammer";
      version = "6.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0mxsd2psl3qddgflq17r5hc432hd15ccvayyj8ihfv9aard42zml";
      };

      beamDeps = [ poolboy ];
    };

    haversine = buildMix rec {
      name = "haversine";
      version = "0.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0q3hc16zd5pvz9xvhk5692v1fkk3fg42cw536yaaa65wjpl4ip2l";
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

    ip_reserved = buildMix rec {
      name = "ip_reserved";
      version = "0.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1zm4820yvdashvz14p9jhv2bwc1hshvyym1zx84yzjhiwavd5z2m";
      };

      beamDeps = [ inet_cidr ];
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
      version = "1.0.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1qb5y4i88d7nxar69an171m9fqpb6rpy4w42q2rimq11j1084xwv";
      };

      beamDeps = [];
    };

    junit_formatter = buildMix rec {
      name = "junit_formatter";
      version = "3.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0ax79m9fn7asbfjk523vvawnvbn2nbhgvnm6j6xdh5ac9fzca7vn";
      };

      beamDeps = [];
    };

    linkify = buildMix rec {
      name = "linkify";
      version = "0.5.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0xw14ls480jzha9fx4lxd40dff4xx82w1h87dr82az6lfw9mmwry";
      };

      beamDeps = [];
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
      version = "2.0.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0p50h0ki8ay5sraiqxiajgwy1829bvyagj65bj9wjny4cnin83fs";
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

    mimetype_parser = buildMix rec {
      name = "mimetype_parser";
      version = "0.1.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0lm8yzcmg17nhvr4p4dbmamb280a9dzqx4rwv66ffz40cz2q13vx";
      };

      beamDeps = [];
    };

    mix_test_watch = buildMix rec {
      name = "mix_test_watch";
      version = "1.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1bmswsjcngjj4rsp67wzhi4p69n32lp8j8qp09kk8lzf9nsn48pq";
      };

      beamDeps = [ file_system ];
    };

    mmdb2_decoder = buildMix rec {
      name = "mmdb2_decoder";
      version = "3.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "17amvw553l6drkaszc5xpf8rcz4fwzpm8kwl5mw29j7si3rz0sii";
      };

      beamDeps = [];
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

    nimble_csv = buildMix rec {
      name = "nimble_csv";
      version = "1.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0amij6y3pgkpazhjr3madrn9c9lv6malq11ln1w82562zhbq2qnh";
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

    oauth2 = buildMix rec {
      name = "oauth2";
      version = "2.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0h9bps7gq7bac5gc3q0cgpsj46qnchpqbv5hzsnd2z9hnf2pzh4a";
      };

      beamDeps = [ tesla ];
    };

    oauther = buildMix rec {
      name = "oauther";
      version = "1.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0kn0msy3z0rx7l4pp8zc5r7yhvmwa3sscr08gfi2rivmm278isvq";
      };

      beamDeps = [];
    };

    oban = buildMix rec {
      name = "oban";
      version = "2.15.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1707222miq6di3605cqyfcgdy6i0wlb3326z928kxcgzvwgn3kjz";
      };

      beamDeps = [ ecto_sql jason postgrex telemetry ];
    };

    paasaa = buildMix rec {
      name = "paasaa";
      version = "0.6.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0blzqack3i8w1f0hjqjgsybqjazcyf54dv3anbnk225c3g1dybbk";
      };

      beamDeps = [];
    };

    parse_trans = buildRebar3 rec {
      name = "parse_trans";
      version = "3.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "16p4c2xjrvz16kzpr9pmcvi6nxq6rwckqi9fp0ksibaxwxn402k2";
      };

      beamDeps = [];
    };

    phoenix = buildMix rec {
      name = "phoenix";
      version = "1.7.7";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "119h8lcvarlm7xrlrb301wgrd3plwwmbvl3f3dckfpjy75ff2rl9";
      };

      beamDeps = [ castore jason phoenix_pubsub phoenix_template phoenix_view plug plug_cowboy plug_crypto telemetry websock_adapter ];
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
      version = "3.3.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "07d1x5nyk9qahqhyc7785774cyfwm07nnjr8kpxj073wcs7azba4";
      };

      beamDeps = [ plug ];
    };

    phoenix_live_reload = buildMix rec {
      name = "phoenix_live_reload";
      version = "1.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1aqm6sxy4ijd5gi8lmjmcaxal1smg2smibjlzrkq9w6xwwsbizwv";
      };

      beamDeps = [ file_system phoenix ];
    };

    phoenix_live_view = buildMix rec {
      name = "phoenix_live_view";
      version = "0.19.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1lx9gi70a3cabjnjhslqbs8ysnpjz5yj324vjkxxg6zv7kfs1smj";
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

      beamDeps = [ hackney phoenix phoenix_html phoenix_view swoosh ];
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
      version = "0.17.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1389zgxvv90nzz0nwb7l5l4gyg2hldmyg2s4h5xcmzd46mlz8v4l";
      };

      beamDeps = [ db_connection decimal jason ];
    };

    progress_bar = buildMix rec {
      name = "progress_bar";
      version = "3.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1dzj622nf3drhswlvqia3b19j4wfclindi1d3b4yqjmjbarc50b9";
      };

      beamDeps = [ decimal ];
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

    replug = buildMix rec {
      name = "replug";
      version = "0.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0q7sikahnvmr8jw9ziklh2am73h9cilhq1j697z59s24x5bpl7zp";
      };

      beamDeps = [ plug ];
    };

    sentry = buildMix rec {
      name = "sentry";
      version = "8.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1d0sd34ckmnkx60zfqvwb7gf37cbjk166nay1x8qbs31xx0pdz7r";
      };

      beamDeps = [ hackney jason plug plug_cowboy ];
    };

    shortuuid = buildMix rec {
      name = "shortuuid";
      version = "3.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0f8dkll158j48jlynjkdrjc6vw72sv04lgxq5ii93fsca47zin6z";
      };

      beamDeps = [];
    };

    sitemapper = buildMix rec {
      name = "sitemapper";
      version = "0.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0gr23zpwih1z2hycpbxgjnlvpg721f5z8savmh87zzp9wn2adxv0";
      };

      beamDeps = [ xml_builder ];
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

    slugger = buildMix rec {
      name = "slugger";
      version = "0.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1fmgnl4ydq4ivbfk1a934vcn0d0wb24lhnvcmqg5sq0jwz8dxl10";
      };

      beamDeps = [];
    };

    slugify = buildMix rec {
      name = "slugify";
      version = "1.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0xmyv324a5prnzj20y1j1nkn18rki7cq3ri567d15csnn2z0n2fb";
      };

      beamDeps = [];
    };

    sobelow = buildMix rec {
      name = "sobelow";
      version = "0.13.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "03aawfxpxb567dxhka8737fxjy50hmggj56s55smvhszp0k90vnd";
      };

      beamDeps = [ jason ];
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

    struct_access = buildMix rec {
      name = "struct_access";
      version = "1.1.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0sjq5v0zdqx7iqs0hqa7lfqzxf4jzi8rb409aywq2q12q3f13i74";
      };

      beamDeps = [];
    };

    sweet_xml = buildMix rec {
      name = "sweet_xml";
      version = "0.7.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0rx1xgdy4y9j8isnd2gnf2hz3vc7zrafy7cm6j194326pyyv1i77";
      };

      beamDeps = [];
    };

    swoosh = buildMix rec {
      name = "swoosh";
      version = "1.11.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0h00h0ml8s6ca72ihq1bn4dj4aqldpapc7p1pg9mcbwdsvf5gvi1";
      };

      beamDeps = [ cowboy gen_smtp hackney jason mime plug_cowboy telemetry ];
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

    tesla = buildMix rec {
      name = "tesla";
      version = "1.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04y31nq54j1wnzpi37779bzzq0sjwsh53ikvnh4n40nvpwgg0r1f";
      };

      beamDeps = [ castore hackney jason mime telemetry ];
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

    tz_world = buildMix rec {
      name = "tz_world";
      version = "1.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "140kip660zbfxpckzi2y4mxg1pysvwcr2cc68viqrd4r12m6bdbq";
      };

      beamDeps = [ castore certifi geo jason ];
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

    ueberauth_cas = buildMix rec {
      name = "ueberauth_cas";
      version = "2.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "08g3kdcx2zxv963nqvwspsh1pqiiclx4hrwsm82jyz11kqmsws2h";
      };

      beamDeps = [ httpoison sweet_xml ueberauth ];
    };

    ueberauth_discord = buildMix rec {
      name = "ueberauth_discord";
      version = "0.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1d4nk3hshwj1ybr5ywz95m6qrrp0f2jcnyjbvbmdqkdv3bwqxyfn";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_facebook = buildMix rec {
      name = "ueberauth_facebook";
      version = "0.10.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1a1pjlxa86v5kbqsxb7lcggbs45pq6380zpppy5dll0wdgbfb35z";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_github = buildMix rec {
      name = "ueberauth_github";
      version = "0.8.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1iiw953l4mk087r2jrpcnyqdmgv2n8cq5947f8fsbkrjkj3v42mf";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_gitlab_strategy = buildMix rec {
      name = "ueberauth_gitlab_strategy";
      version = "0.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "07h94s9fy46mqkn4g3wd62lkpgpjfcdk1cd60myc0qxh9dwjwvp8";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_google = buildMix rec {
      name = "ueberauth_google";
      version = "0.10.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0f005491i5jbhx76p7xshcpjcgjf0afqd4c6fgh3djdcaabclqi4";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_keycloak_strategy = buildMix rec {
      name = "ueberauth_keycloak_strategy";
      version = "0.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "06r10w0azlpypjgggar1lf7h2yazn2dpyicy97zxkjyxgf9jfc60";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    ueberauth_twitter = buildMix rec {
      name = "ueberauth_twitter";
      version = "0.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0rb0n41s60b89385ggzvags3mxgbp4iv7gxympqpdyd3w6iqxjl3";
      };

      beamDeps = [ httpoison oauther ueberauth ];
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

    unplug = buildMix rec {
      name = "unplug";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0fkwkg6qm2lsvil8xdba9mmcgi5iw41w42dqhm72shdab1bshwfi";
      };

      beamDeps = [ plug ];
    };

    unsafe = buildMix rec {
      name = "unsafe";
      version = "1.0.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0xgn5mfbi4c7yv33k11mhyxz7ijjy5wlmjs4rnlh3ay3hcb271dl";
      };

      beamDeps = [];
    };

    vite_phx = buildMix rec {
      name = "vite_phx";
      version = "0.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0dn9bygcsjyxllw2cxm9iggmqjyx9i67dix2y07ljcd1jih75c88";
      };

      beamDeps = [ jason phoenix ];
    };

    websock = buildMix rec {
      name = "websock";
      version = "0.5.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0lxlp1h18595nqczfg15iy34kw5xbbab3yk6ml9cf8mcgwyla1b1";
      };

      beamDeps = [];
    };

    websock_adapter = buildMix rec {
      name = "websock_adapter";
      version = "0.5.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1azlnjpndkhz4h78fcz9p4ssf1shpfh2rqnszhiy5jsjkk3kihnj";
      };

      beamDeps = [ plug plug_cowboy websock ];
    };

    xml_builder = buildMix rec {
      name = "xml_builder";
      version = "2.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1jb29bv6hgz7z2bdw119am6z17nkg1033936h4smsmhpp4pxarlx";
      };

      beamDeps = [];
    };
  };
in self

