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
      sha256 = "1i4djzrynzr4l8mqx946ad6zn7blz2r5jif58y9c0lws6bdc5h1l";
      type = "gem";
    };
    version = "1.0.2";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08i5a52b42x1q26j4rzaxp4hhwl0wzw12jbbjxjifnwi2dm57biy";
      type = "gem";
    };
    version = "1.149.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sng9iagk96r8986gsacljnw357famz5x4xa1wk9xm4cx0bmpm5i";
      type = "gem";
    };
    version = "3.48.3";
  };
  aws-sdk-firehose = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f7s1vqs1qga6jzvjgg4x4hcz1rdycwry5dcizidzffwn9sp9iy0";
      type = "gem";
    };
    version = "1.14.0";
  };
  aws-sdk-kinesis = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "005dj7m3zi8gkda5g40a0wxlx48g0w5cz4k7783g2p6c0h5wwdsb";
      type = "gem";
    };
    version = "1.13.1";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m64sb5nnpryjmjbgvr5lmlrd06wvafd0ss9i9zf3fsi39hqaicg";
      type = "gem";
    };
    version = "1.16.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bnihahz0va36jcw5wifw6ad0fdarl0lsils6h50wpvzcxzmlm2i";
      type = "gem";
    };
    version = "1.36.0";
  };
  aws-sdk-sqs = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cpmimcnjfwrqv1nmaxp4yyxmh50wg83ccihj8hiafkazg75kfx0";
      type = "gem";
    };
    version = "1.13.0";
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
      sha256 = "1kgim98b41cj0njlqv1bwvx2m6gw9n7ilwklfn9hivfg096bzl8l";
      type = "gem";
    };
    version = "4.4.2";
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
      sha256 = "1kx13w90dnmrfgwgm86h8wsmjmpv19qxvd1f6xxrdjmw0ij0vyqn";
      type = "gem";
    };
    version = "6.3.0";
  };
  elasticsearch-api = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06dji10nahhqd04igfwcqb1d521lv7gy40g7nv0mx3nnb1c6ksbm";
      type = "gem";
    };
    version = "6.3.0";
  };
  elasticsearch-transport = {
    dependencies = ["faraday" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "025c0plj3ydrykmwpwhn6vdxfgf4b7xr4gg5dzdd5ck9frvqb6mz";
      type = "gem";
    };
    version = "6.3.0";
  };
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15l9w0938c19nxmrp09n75qpmm64k12xj69h47yvxzcxcpbgnkb2";
      type = "gem";
    };
    version = "0.62.0";
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
      sha256 = "115y11r7rd4hd9gc2lngm6cas1119fas87s75x6iaykqg8hlr99l";
      type = "gem";
    };
    version = "3.4.1";
  };
  fluent-plugin-kafka = {
    dependencies = ["fluentd" "ltsv" "ruby-kafka"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "079isjc1788fbhagrn2qfrp6mcfw0b6kl6dpnrwpwv9865h75hmm";
      type = "gem";
    };
    version = "0.9.2";
  };
  fluent-plugin-kinesis = {
    dependencies = ["aws-sdk-firehose" "aws-sdk-kinesis" "fluentd" "google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14jqr13k50vs29akjpi0prcs1fdjy335prlqylvri7bc1cmfkhz3";
      type = "gem";
    };
    version = "3.0.0";
  };
  fluent-plugin-mongo = {
    dependencies = ["fluentd" "mongo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p5c7j3yx4cjrn4ljxwghrp8yh0rcdra1iafc67i92s1sl8b70dq";
      type = "gem";
    };
    version = "1.2.2";
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
      sha256 = "16zaxvf3rs5lmd933sgyrxkrws0qcd0z2ypbky45gyq8si1dpwcl";
      type = "gem";
    };
    version = "1.1.9";
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
      sha256 = "1yyv3f0g30x9dzhq74b5cq8z0wbyppw9bb6152v6yrwz25b16231";
      type = "gem";
    };
    version = "1.2.3";
  };
  fluentd = {
    dependencies = ["cool.io" "dig_rb" "http_parser.rb" "msgpack" "serverengine" "sigdump" "strptime" "tzinfo" "tzinfo-data" "yajl-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ppdfa03gzv97px7xhdx5nnzc15g8l7yp10jw87qyl5cp62kpx3c";
      type = "gem";
    };
    version = "1.4.2";
  };
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04988m3hmllg4sl4syjb35x0wzsg7rj1nmvhx3d9ihml22w76gb2";
      type = "gem";
    };
    version = "3.7.1";
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
      sha256 = "0zs8v59d77wlx4yylyh0lglsj8sp9jrq11yqngdgn95avfhxjw0s";
      type = "gem";
    };
    version = "1.2.9";
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
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08q64b5br692dd3v0a9wq9q5dvycc6kmiqmjbdxkxbfizggsvx6l";
      type = "gem";
    };
    version = "3.0.3";
  };
  ruby-kafka = {
    dependencies = ["digest-crc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b5i6vazw9s26nwifwsbd95sl35l5krh3yp4z2zpp6lpp6al36db";
      type = "gem";
    };
    version = "0.7.6";
  };
  serverengine = {
    dependencies = ["sigdump"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01978684zvab2pbg7r8vm53n8m2h99pc9iqm1wy9gy67y1nxvz13";
      type = "gem";
    };
    version = "2.1.0";
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
      sha256 = "1105fp27d527k7rrq1yx1ikbzf1sra046ndayxikkjvay9ql61jz";
      type = "gem";
    };
    version = "1.2019.1";
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