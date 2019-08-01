{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bcm2hchn897xjhqj9zzsxf3n9xhddymj4lsclz508f4vw3av46l";
      type = "gem";
    };
    version = "2.6.0";
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
      sha256 = "12fbibkq9gp8b9az3s87zi6dcalx92aam98jmbzacw9cvafzm7af";
      type = "gem";
    };
    version = "1.193.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wir5q6qpj3lxxmzynmybsfabzgbfkk1cjyy7dkfsy5fmxcgm6qq";
      type = "gem";
    };
    version = "3.61.1";
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
      sha256 = "1871mqf6b92rcmcgc6061xx9h35dlfvj7r27q2khidb5dzp7yd33";
      type = "gem";
    };
    version = "1.46.0";
  };
  aws-sdk-sqs = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0946yrabarr5hvzxkfh6f8mvm19ivpybhd64xnsk3hlk71xc9bip";
      type = "gem";
    };
    version = "1.20.0";
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
      sha256 = "1800algjigydip0855xcfdlyl1cfbl630sl68a0y39xvpvd2fq68";
      type = "gem";
    };
    version = "7.2.1";
  };
  elasticsearch-api = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18rd6xxvdjr8h7n6ziwjkrdzxwsx0rf9vd1krz7kgi61q5897jmz";
      type = "gem";
    };
    version = "7.2.1";
  };
  elasticsearch-transport = {
    dependencies = ["faraday" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k0324sbwz292l0nj50k318k2qlznzpimj5mpg7557rkk0b7plrz";
      type = "gem";
    };
    version = "7.2.1";
  };
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mc6y6n7i0hhk7i8wwi4qjnpkm013p7z3xr994s696hk74f91a7j";
      type = "gem";
    };
    version = "0.65.0";
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
  fluent-plugin-elasticsearch = {
    dependencies = ["elasticsearch" "excon" "fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18j0q9x006gps03sh93v8nc83b9w45a6ynic8kd9x6zr2g58ynh7";
      type = "gem";
    };
    version = "3.5.3";
  };
  fluent-plugin-kafka = {
    dependencies = ["fluentd" "ltsv" "ruby-kafka"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p7xsm6v84z61hkhvg9fmrxahaid7fqdarnpvpp5qj8qnzximkyd";
      type = "gem";
    };
    version = "0.11.0";
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
  fluent-plugin-scribe = {
    dependencies = ["fluentd" "thrift"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19m37d0saknifjg8kva96pgsc7zsmdlwvwiy9gvhi2d6c7bq3q30";
      type = "gem";
    };
    version = "1.0.0";
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
      sha256 = "1h6zvb4qhhyl8hm19015ha5rbdvg9wpv3ipbyr1ab491igqln1j6";
      type = "gem";
    };
    version = "1.6.2";
  };
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b7r1y30cgm03cj0l8pr6npz4w9i1lh70ycd2w15zf2qcbi9gpng";
      type = "gem";
    };
    version = "3.9.0";
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
      sha256 = "1186lhwnxiw5ryv6dbxrsfy0fajfll2l95kf9pmca50iyiqi86zn";
      type = "gem";
    };
    version = "1.3.0";
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
      sha256 = "0g9ds2ffzljl6jjmkjffwxc1z6lh5nkqqmhhkxjk71q5ggv0rkpm";
      type = "gem";
    };
    version = "3.1.1";
  };
  ruby-kafka = {
    dependencies = ["digest-crc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10q92n67s4x80q87ibirvsaryvq4lqyna6xabl5vgnr59xrap6ym";
      type = "gem";
    };
    version = "0.7.9";
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
  thread_safe = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  thrift = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aj23ndh5n5yqcvp4c12y7vl5wvxpl66zncf6n6ax2zvb6ig44cv";
      type = "gem";
    };
    version = "0.8.0";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fjx9j327xpkkdlxwmkl3a8wqj7i4l4jwlrv3z13mg95z9wl253z";
      type = "gem";
    };
    version = "1.2.5";
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