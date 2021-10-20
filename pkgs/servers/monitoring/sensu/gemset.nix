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
  amq-protocol = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rpn9vgh7y037aqhhp04smihzr73vp5i5g6xlqlha10wy3q0wp7x";
      type = "gem";
    };
    version = "2.0.1";
  };
  amqp = {
    dependencies = ["amq-protocol" "eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kbrqnpjgj9v0722p3n5rw589l4g26ry8mcghwc5yr20ggkpdaz9";
      type = "gem";
    };
    version = "1.6.0";
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
  aws-sdk = {
    dependencies = ["aws-sdk-resources"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mx4x4lxd584c9bsip68hfrw4lw5q04slx0w1a57yy2mlkcaz811";
      type = "gem";
    };
    version = "2.11.264";
  };
  aws-sdk-core = {
    dependencies = ["aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kjmflddmq5y2y5677z7y2fin6pxa7my5cq39dzc7hmwl7favjxj";
      type = "gem";
    };
    version = "2.11.264";
  };
  aws-sdk-resources = {
    dependencies = ["aws-sdk-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1blw7kazv1a5kpkk6sy0mhhbfkb38f93sp2mpxbhbbr6n08hq4q3";
      type = "gem";
    };
    version = "2.11.264";
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
  cause = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0digirxqlwdg79mkbn70yc7i9i1qnclm2wjbrc47kqv6236bpj00";
      type = "gem";
    };
    version = "0.1";
  };
  childprocess = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lv7axi1fhascm9njxh3lx1rbrnsm8wgvib0g7j26v4h1fcphqg0";
      type = "gem";
    };
    version = "0.5.8";
  };
  cookiejar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q0kmbks9l3hl0wdq744hzy97ssq9dvlzywyqv9k9y1p3qc9va2a";
      type = "gem";
    };
    version = "0.3.3";
  };
  dentaku = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11z4cw4lspx3rgmmd2hd4l1iikk6p17icxwn7xym92v1j825zpnr";
      type = "gem";
    };
    version = "2.0.9";
  };
  domain_name = {
    dependencies = ["unf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0abdlwb64ns7ssmiqhdwgl27ly40x2l27l8hs8hn0z4kb3zd2x3v";
      type = "gem";
    };
    version = "0.5.20180417";
  };
  em-http-request = {
    dependencies = ["addressable" "cookiejar" "em-socksify" "eventmachine" "http_parser.rb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13rxmbi0fv91n4sg300v3i9iiwd0jxv0i6xd0sp81dx3jlx7kasx";
      type = "gem";
    };
    version = "1.1.5";
  };
  em-http-server = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y8l4gymy9dzjjchjav90ck6has2i2zdjihlhcyrg3jgq6kjzyq5";
      type = "gem";
    };
    version = "0.1.8";
  };
  em-socksify = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rk43ywaanfrd8180d98287xv2pxyl7llj291cwy87g1s735d5nk";
      type = "gem";
    };
    version = "0.3.2";
  };
  em-worker = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z4jx9z2q5hxvdvik4yp0ahwfk69qsmdnyp72ln22p3qlkq2z5wk";
      type = "gem";
    };
    version = "0.0.2";
  };
  eventmachine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c2dl10pi6a30kcvx2s6p2v1wb4kbm48iv38kmz2ff600nirhpb8";
      type = "gem";
    };
    version = "1.9.21";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
      type = "gem";
    };
    version = "1.0.3";
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
  influxdb = {
    dependencies = ["cause" "json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jikl3iylbffsdmb4vr09ysqvpwxk133y6m9ylwcd0931ngsf0ks";
      type = "gem";
    };
    version = "0.3.13";
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
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qmj7fypgb9vag723w1a49qihxrcf5shzars106ynw2zk352gbv5";
      type = "gem";
    };
    version = "1.8.6";
  };
  jsonpath = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gwhrd7xlysq537yy8ma69jc83lblwiccajl5zvyqpnwyjjc93df";
      type = "gem";
    };
    version = "0.5.8";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fjxy1jm52ixpnv3vg9ld9pr9f35gy0jp66i1njhqjvmnvq0iwwk";
      type = "gem";
    };
    version = "3.2.2";
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m00pg19cm47n1qlcxgl91ajh2yq0fszvn1vy8fy0s1jkrp9fw4a";
      type = "gem";
    };
    version = "3.2019.0331";
  };
  mixlib-cli = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0647msh7kp7lzyf6m72g6snpirvhimjm22qb8xgv9pdhbcrmcccp";
      type = "gem";
    };
    version = "1.7.0";
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
  netrc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  oj = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "147whmq8h2n04chskl3v4a132xhz5i6kk6vhnz83jwng4vihin5f";
      type = "gem";
    };
    version = "2.18.1";
  };
  parse-cron = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02fj9i21brm88nb91ikxwxbwv9y7mb7jsz6yydh82rifwq7357hg";
      type = "gem";
    };
    version = "0.1.4";
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
  rest-client = {
    dependencies = ["http-cookie" "mime-types" "netrc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hzcs2r7b5bjkf2x2z3n8z6082maz0j8vqjiciwgg3hzb63f958j";
      type = "gem";
    };
    version = "2.0.2";
  };
  sensu = {
    dependencies = ["em-http-request" "em-http-server" "eventmachine" "parse-cron" "sensu-extension" "sensu-extensions" "sensu-json" "sensu-logger" "sensu-redis" "sensu-settings" "sensu-spawn" "sensu-transport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wmwck53i207axhqm2r6dz8d7arww3mzd8pjx7m79svyj998hzjc";
      type = "gem";
    };
    version = "1.7.0";
  };
  sensu-extension = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bpizp4n01rv72cryjjlrbfxxj3csish3mkxjzdy4inpi5j5h1dw";
      type = "gem";
    };
    version = "1.5.2";
  };
  sensu-extensions = {
    dependencies = ["sensu-extension" "sensu-extensions-check-dependencies" "sensu-extensions-debug" "sensu-extensions-deregistration" "sensu-extensions-json" "sensu-extensions-occurrences" "sensu-extensions-only-check-output" "sensu-extensions-ruby-hash" "sensu-json" "sensu-logger" "sensu-settings"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1313g6x3qwldk44p3v46sm3w1hz0pc89nslcwdw3v2j78a99a62y";
      type = "gem";
    };
    version = "1.11.0";
  };
  sensu-extensions-check-dependencies = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hc4kz7k983f6fk27ikg5drvxm4a85qf1k07hqssfyk3k75jyj1r";
      type = "gem";
    };
    version = "1.1.0";
  };
  sensu-extensions-debug = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11abdgn2kkkbvxq4692yg6a27qnxz4349gfiq7d35biy7vrw34lp";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-extensions-deregistration = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rarsd7vjflvzgs3hm6z3ypfp3rbzq2723wc0rqxnkpahzdrwr6c";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-extensions-json = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wnbn9sycdqdh9m0fhszaqkv0jijs3fkdbvcv8kdspx6irbv3m6g";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-extensions-occurrences = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lx5wsbblfs0rvkxfg09bsz0g2mwmckrhga7idnarsnm8m565v1v";
      type = "gem";
    };
    version = "1.2.0";
  };
  sensu-extensions-only-check-output = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ds2i8wd4ji9ifig2zzr4jpxinvk5dm7j10pvaqy4snykxa3rqh3";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-extensions-ruby-hash = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xyrj3gbmslbivcd5qcmyclgapn7qf7f5jwfvfpw53bxzib0h7s3";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-json = {
    dependencies = ["oj"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08zlxg5j3bhs72cc7wcllp026jbif0xiw6ib1cgawndlpsfl9fgx";
      type = "gem";
    };
    version = "2.1.1";
  };
  sensu-logger = {
    dependencies = ["eventmachine" "sensu-json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jpw4kz36ilaknrzb3rbkhpbgv93w2d668z2cv395dq30d4d3iwm";
      type = "gem";
    };
    version = "1.2.2";
  };
  sensu-plugin = {
    dependencies = ["json" "mixlib-cli"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x4zka4zia2wk3gp0sr4m4lzsf0m7s4a3gcgs936n2mgzsbcaa86";
      type = "gem";
    };
    version = "1.4.7";
  };
  sensu-plugins-disk-checks = {
    dependencies = ["sensu-plugin" "sys-filesystem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q4f23ccvl6d0k26xph2fskk5pv2mmdrclr00m358m880sgkhyg1";
      type = "gem";
    };
    version = "4.0.1";
  };
  sensu-plugins-http = {
    dependencies = ["aws-sdk" "rest-client" "sensu-plugin"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bjvg6vr0fy106bp50n6dfwbqf7k0z7ynrm17am7ggfbhzy7wi06";
      type = "gem";
    };
    version = "2.11.0";
  };
  sensu-plugins-influxdb = {
    dependencies = ["dentaku" "influxdb" "jsonpath" "sensu-plugin"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rx0zfvv7c60vaqdwbpl5c3csg5zrrjy1jdl8saigpla133vbgxd";
      type = "gem";
    };
    version = "1.4.0";
  };
  sensu-plugins-logs = {
    dependencies = ["sensu-plugin"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17shj4msc8bzqgqi5waw649hzzgl8q87z6flmpg0msnmv4r2h1cf";
      type = "gem";
    };
    version = "1.3.2";
  };
  sensu-plugins-systemd = {
    dependencies = ["sensu-plugin"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f0hdp2cvzs5wby2fkjg48siyjgdi83hf11ld1by2l0cn4s9ir24";
      type = "gem";
    };
    version = "0.1.0";
  };
  sensu-redis = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0widfmmj1h9ca2kk14wy1sqmlkq40linp89a73s3ghngnzri0xyk";
      type = "gem";
    };
    version = "2.4.0";
  };
  sensu-settings = {
    dependencies = ["parse-cron" "sensu-json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cdlyhga9fj5hmchpb40fw9nh24qhax9djnqcxlj1fywyccycj69";
      type = "gem";
    };
    version = "10.15.0";
  };
  sensu-spawn = {
    dependencies = ["childprocess" "em-worker" "eventmachine" "ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17yc8ivjpjbvig9r7yl6991d6ma0kcq75fbpz6i856ljvcr3lmd5";
      type = "gem";
    };
    version = "2.5.0";
  };
  sensu-transport = {
    dependencies = ["amq-protocol" "amqp" "eventmachine" "sensu-redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x6vyfmg1jm1srf7xa5aka73by7qwcmry2rx8kq8phwa4g0v4mzr";
      type = "gem";
    };
    version = "8.2.0";
  };
  sys-filesystem = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10didky52nfapmybj6ipda18i8fcwf8bs9bbfbk5i7v1shzd36rf";
      type = "gem";
    };
    version = "1.1.7";
  };
  unf = {
    dependencies = ["unf_ext"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ll6w64ibh81qwvjx19h8nj7mngxgffg7aigjx11klvf5k2g4nxf";
      type = "gem";
    };
    version = "0.0.7.6";
  };
}
