{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fvchp2rhp2rmigx7qglf69xvjqvzq7x0g49naliw29r2bz656sy";
      type = "gem";
    };
    version = "2.7.0";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "100g77a5ixg4p5zwq77f28n2pdkk0y481f7v83qrlmnj22318qq6";
      type = "gem";
    };
    version = "1.0.3";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dr16ryn9514qfdf9zrv06f7gb7gih960b82arkv868nfj4470jx";
      type = "gem";
    };
    version = "1.207.0";
  };
  aws-sdk-cloudwatchlogs = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10vracvnmihazs34nlmar813qdigk34afij66182hjcciby0as6x";
      type = "gem";
    };
    version = "1.25.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vb49n1ydz1m2l0qhc7gp0rvc7fa7qxczf582kyv7nsfn2k2z9s4";
      type = "gem";
    };
    version = "3.65.1";
  };
  aws-sdk-firehose = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s2rksdk3iv9jvcnyvnpvmh35vbs0ppan9iw4zq6fg87y44j9i74";
      type = "gem";
    };
    version = "1.20.0";
  };
  aws-sdk-kinesis = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w2azv19xi1jmp4dsqjh8af1xdyw4ajd1l5abmx3wpwd8zngxvlp";
      type = "gem";
    };
    version = "1.19.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14blvvfz67rhffi4ahby50jiip5f0hm85mcxlx6y93g0cfrnxh3m";
      type = "gem";
    };
    version = "1.24.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14iv2wqvvbiz0gdms21i9n6rh8390r1yg4zcf8pzzfplbqfwqw4w";
      type = "gem";
    };
    version = "1.48.0";
  };
  aws-sdk-sqs = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pszp0bcgiqn4iskb6xv5j2n540h1k9glz2w85vq5iml1casq769";
      type = "gem";
    };
    version = "1.22.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dfc8i5cxjwlvi4b665lbpbwvks8a6wfy3vfmwr3pjdmxwdmc2cs";
      type = "gem";
    };
    version = "1.1.0";
  };
  bson = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gxdavhccppnfbmh2cx0qxv6b6rzr5s00dsigazw808dhb34yyg7";
      type = "gem";
    };
    version = "4.5.0";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x07r23s7836cpp5z9yrlbpljcxpax14yw4fy4bnp6crhr6x24an";
      type = "gem";
    };
    version = "1.1.5";
  };
  "cool.io" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l836z3qgrl5829q48qaz1zngqqxy2k0l61swqm0amhyfcgfbz1m";
      type = "gem";
    };
    version = "1.5.4";
  };
  dig_rb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12dbb1pl2vr9z7yy2zsbsjaj4hw89y56wll6kd8422mylmcw7bx4";
      type = "gem";
    };
    version = "1.0.1";
  };
  digest-crc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08q8p0fk51aa6dwhy2xmjaj76arcq9nn22gyia162jmqpccfx50l";
      type = "gem";
    };
    version = "0.4.1";
  };
  elasticsearch = {
    dependencies = ["elasticsearch-api" "elasticsearch-transport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r4gpskjgg8blk7ws9g1p3d5n8bjrggyzxg2v3q40036rjp3fp1h";
      type = "gem";
    };
    version = "7.3.0";
  };
  elasticsearch-api = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jyd03ylyvv975iail13cwlkg4h9yknhpm1kcq1dpvmbjqy7q6bz";
      type = "gem";
    };
    version = "7.3.0";
  };
  elasticsearch-transport = {
    dependencies = ["faraday" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dqm819iqkhbny5lwkf8mh83fmffpwbscal9vmfdw4g9mf08yfnf";
      type = "gem";
    };
    version = "7.3.0";
  };
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05qmrx7l8abpbvp0z01fdpc731c4k6akk67l424vdp5dywhachpr";
      type = "gem";
    };
    version = "0.66.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s72m05jvzc1pd6cw1i289chas399q0a14xrwg4rvkdwy7bgzrh0";
      type = "gem";
    };
    version = "0.15.4";
  };
  fluent-config-regexp-type = {
    dependencies = ["fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hk0vxcmlbid7n6piyv3x83j5gyiz7in397l9x3c6nh69wicy7gm";
      type = "gem";
    };
    version = "1.0.0";
  };
  fluent-plugin-cloudwatch-logs = {
    dependencies = ["aws-sdk-cloudwatchlogs" "fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "046nx56zgb3l29r5v1s79zhhxsb18fwz2d8v6n6cgbv8i13xhl0l";
      type = "gem";
    };
    version = "0.7.4";
  };
  fluent-plugin-elasticsearch = {
    dependencies = ["elasticsearch" "excon" "fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19nrhgx8mh59lpcv2jf3gb031x4zan93j9fswzjzvyjh4rlfpbmn";
      type = "gem";
    };
    version = "3.5.5";
  };
  fluent-plugin-kafka = {
    dependencies = ["fluentd" "ltsv" "ruby-kafka"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1km7gjcx2icwj2s2svbmrhwb1gmpk85zfa8pivm04wzc8f6vjhy2";
      type = "gem";
    };
    version = "0.11.1";
  };
  fluent-plugin-kinesis = {
    dependencies = ["aws-sdk-firehose" "aws-sdk-kinesis" "fluentd" "google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j0qs09g53xsvbxpdlylwm3h2v8rvr3xpn0kwy63cjnpdf012m8f";
      type = "gem";
    };
    version = "3.1.0";
  };
  fluent-plugin-mongo = {
    dependencies = ["fluentd" "mongo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "108gxrgbn0ib70n7gvdlx8xr1i0jdh1cb2n4m4m24ihyfb8i6vli";
      type = "gem";
    };
    version = "1.3.0";
  };
  fluent-plugin-record-reformer = {
    dependencies = ["fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gwfrfyi9is4l9q4ih3c4l3c9qvyh00jnd2qajdpdh5xjj2m7akn";
      type = "gem";
    };
    version = "0.9.1";
  };
  fluent-plugin-rewrite-tag-filter = {
    dependencies = ["fluent-config-regexp-type" "fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kf8p1s02pwhkks82kmkkbfbf4qlhhqiczqah4w0dnp86wp6xyw5";
      type = "gem";
    };
    version = "2.2.0";
  };
  fluent-plugin-s3 = {
    dependencies = ["aws-sdk-s3" "aws-sdk-sqs" "fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "093fs43bixd0lmjfpkk1fl24asa1w8kacqrm82lbfx4cq4dg4fif";
      type = "gem";
    };
    version = "1.1.11";
  };
  fluent-plugin-webhdfs = {
    dependencies = ["fluentd" "webhdfs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mhy321gxb59yk0rsawnqf3kfx33ncdlnpmn4rdfzgi0v8ya0fp4";
      type = "gem";
    };
    version = "1.2.4";
  };
  fluentd = {
    dependencies = ["cool.io" "dig_rb" "http_parser.rb" "msgpack" "serverengine" "sigdump" "strptime" "tzinfo" "tzinfo-data" "yajl-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pyjd31z95l819n9sbl6bl5bvjmyi39is0p2i0im3v0r9ydgyf27";
      type = "gem";
    };
    version = "1.7.0";
  };
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb7v00zya00jddl7cpraz27xi3jsdjn31mm672byqwzdyghpfka";
      type = "gem";
    };
    version = "3.9.1";
  };
  "http_parser.rb" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
      type = "gem";
    };
    version = "0.6.0";
  };
  jmespath = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d4wac0dcd1jf6kc57891glih9w57552zgqswgy74d1xhgnk0ngf";
      type = "gem";
    };
    version = "1.4.0";
  };
  ltsv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wrjvc5079zhpn62k1yflrf7js6vaysrg1qwggf7bj2zi0p5rhys";
      type = "gem";
    };
    version = "0.1.2";
  };
  mongo = {
    dependencies = ["bson"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k0f1826hixqfqgsc9g6rdqrzr5pzy46hszmk6869pmvm638jah1";
      type = "gem";
    };
    version = "2.6.4";
  };
  msgpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qr2mkm2i3m76zarvy7qgjl9596hmvjrg7x6w42vx8cfsbf5p0y1";
      type = "gem";
    };
    version = "1.3.1";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  multipart-post = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zgw9zlwh2a6i1yvhhc4a84ry1hv824d6g2iw2chs3k5aylpmpfj";
      type = "gem";
    };
    version = "2.1.1";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xnfv2j2bqgdpg2yq9i2rxby0w2sc9h5iyjkpaas2xknwrgmhdb0";
      type = "gem";
    };
    version = "4.0.1";
  };
  ruby-kafka = {
    dependencies = ["digest-crc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m50s1xabvgq36k9jx2qj8bd8ivvkxa6fs2czi22jxhzqsl3xlvc";
      type = "gem";
    };
    version = "0.7.10";
  };
  serverengine = {
    dependencies = ["sigdump"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10y535621y0kyn40bkcnl01zrsf3z4abf4mdl8m3fdcmj30mazlw";
      type = "gem";
    };
    version = "2.1.1";
  };
  sigdump = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mqf06iw7rymv54y7rgbmfi6ppddgjjmxzi3hrw658n1amp1gwhb";
      type = "gem";
    };
    version = "0.2.4";
  };
  strptime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yj5wwa7wbhgi7w8d9ihpzpf99niw956fhyxddhayj09fgmdcxd8";
      type = "gem";
    };
    version = "0.2.3";
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jp9f5120az6q84w5w19nnn6g6yl2whc1cbcnnv4xryw9q8vqbkb";
      type = "gem";
    };
    version = "2.0.0";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m507in0d7vlfgasxpkz3y1a44zp532k9qlqcaz90ay939sz9h5q";
      type = "gem";
    };
    version = "1.2019.2";
  };
  webhdfs = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gs6xb9dz9bp5xc38yplfy48jcgj7jrj0zg0vgi7ydkxnkzkhbf2";
      type = "gem";
    };
    version = "0.8.0";
  };
  yajl-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16v0w5749qjp13xhjgr2gcsvjv6mf35br7iqwycix1n2h7kfcckf";
      type = "gem";
    };
    version = "1.4.1";
  };
}
