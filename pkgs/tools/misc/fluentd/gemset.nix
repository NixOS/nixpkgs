{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "022r3m9wdxljpbya69y2i3h9g3dhhfaqzidf95m6qjzms792jvgp";
      type = "gem";
    };
    version = "2.8.0";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pyis1nvnbjxk12a43xvgj2gv0mvp4cnkc1gzw0v1018r61399gz";
      type = "gem";
    };
    version = "1.2.0";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ns0378h8qa5vwrq7a7i0xji17japs95mddpvam351k19a79vbwh";
      type = "gem";
    };
    version = "1.540.0";
  };
  aws-sdk-cloudwatchlogs = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "075qkjzjbi37hnp4qq9gkxy2cfb9v29c66qclfmxqyvfcw5s04b1";
      type = "gem";
    };
    version = "1.49.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1chpydvgwa48rbd67k39fpg2vjp21v3kmjygbjqv1l1sqn6rjbvw";
      type = "gem";
    };
    version = "3.124.0";
  };
  aws-sdk-firehose = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01vf0xzyj1j85vvl16mhazkgs5zz9ym6rk5v7396mlzm8a67796g";
      type = "gem";
    };
    version = "1.45.0";
  };
  aws-sdk-kinesis = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xgjmpm2k60sl734g6lv7g8qlm4d6g9pjzgr1825fhd1h492p3dl";
      type = "gem";
    };
    version = "1.38.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1br4h5zwb5ir2bf6y0hnlwafkmghxi2fbjqx86agyv838ndy9npd";
      type = "gem";
    };
    version = "1.52.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yc96imi4v043rdxa94ncg15aapzp1i5qx076rv25zxqcbkdwzwd";
      type = "gem";
    };
    version = "1.109.0";
  };
  aws-sdk-sqs = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vzff2v18098cz8c6pvgfh1lc4l1kk4w5gq76rwjdxw2ahnxf4h9";
      type = "gem";
    };
    version = "1.48.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wh1y79v0s4zgby2m79bnifk65hwf5pvk2yyrxzn2jkjjq8f8fqa";
      type = "gem";
    };
    version = "1.4.0";
  };
  bson = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pnr0b7phdzhkw9xqhmqnw5673ndi13ks3dqwqmbxq6v0rsxiapc";
      type = "gem";
    };
    version = "4.12.1";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nwad3211p7yv9sda31jmbyw6sdafzmdi2i2niaz6f0wk5nq9h0f";
      type = "gem";
    };
    version = "1.1.9";
  };
  "cool.io" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dfq4h168wzvs9cvn2mm8648ynkl936pgjva2p8ik34p6d620537";
      type = "gem";
    };
    version = "1.7.1";
  };
  digest-crc = {
    dependencies = ["rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1czaak53w8n13y1fr0q23gp0fhklvxjac5n562qj3xk6sh5ad0x2";
      type = "gem";
    };
    version = "0.6.4";
  };
  elasticsearch = {
    dependencies = ["elasticsearch-api" "elasticsearch-transport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06vyavz2lcswj32jdcnjccax3flpcb2xnx9f5jxxm95clkpsqnwa";
      type = "gem";
    };
    version = "7.16.0";
  };
  elasticsearch-api = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vp09waa4bi1xk7ixwldiix27g52fd6xcij6826xgypmzrxrn1hc";
      type = "gem";
    };
    version = "7.16.0";
  };
  elasticsearch-transport = {
    dependencies = ["faraday" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kpcy250crl9w1jspqw9ykv0ixlnscym93mi9kvgljis2yql0qlx";
      type = "gem";
    };
    version = "7.16.0";
  };
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0153rr745g48h48vaplgmx7xkfjbc79acpq5jsl7agdrk4yf75ih";
      type = "gem";
    };
    version = "0.89.0";
  };
  faraday = {
    dependencies = ["faraday-em_http" "faraday-em_synchrony" "faraday-excon" "faraday-httpclient" "faraday-net_http" "faraday-net_http_persistent" "faraday-patron" "faraday-rack" "multipart-post" "ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0afhlqgby2cizcwgh7h2sq5f77q01axjbdl25bsvfwsry9n7gyyi";
      type = "gem";
    };
    version = "1.8.0";
  };
  faraday-em_http = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12cnqpbak4vhikrh2cdn94assh3yxza8rq2p9w2j34bqg5q4qgbs";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-em_synchrony = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vgrbhkp83sngv6k4mii9f2s9v5lmp693hylfxp2ssfc60fas3a6";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h09wkb0k0bhm6dqsd47ac601qiaah8qdzjh8gvxfd376x1chmdh";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday-httpclient = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fyk0jd3ks7fdn8nv3spnwjpzx2lmxmg2gh4inz3by1zjzqg33sc";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-net_http = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fi8sda5hc54v1w3mqfl5yz09nhx35kglyx72w7b8xxvdr0cwi9j";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-net_http_persistent = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dc36ih95qw3rlccffcb0vgxjhmipsvxhn6cw71l7ffs0f7vq30b";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-patron = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19wgsgfq0xkski1g7m96snv39la3zxz6x7nbdgiwhg5v82rxfb6w";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h184g4vqql5jv9s9im6igy00jp6mrah2h14py6mpf9bkabfqq7g";
      type = "gem";
    };
    version = "1.0.0";
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
      sha256 = "0z1i1n921i5w43bl6rcsj526a22dzv6lrninwj8ygaksgrg5rr45";
      type = "gem";
    };
    version = "0.14.2";
  };
  fluent-plugin-elasticsearch = {
    dependencies = ["elasticsearch" "excon" "fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gfqpl2izz036faaz3qlq61da87avhmc2406s21shayhkf8sx0p9";
      type = "gem";
    };
    version = "5.1.4";
  };
  fluent-plugin-kafka = {
    dependencies = ["fluentd" "ltsv" "ruby-kafka"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15hdd140nqh9zg10wqdwp3m0k1l5w1xhllvbfs5z21aqwrvwc0mp";
      type = "gem";
    };
    version = "0.17.3";
  };
  fluent-plugin-kinesis = {
    dependencies = ["aws-sdk-firehose" "aws-sdk-kinesis" "fluentd" "google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07n5pzfz143hlvbzbx5rczb33ai9kdp48vhdak100m6xpaqkvc2p";
      type = "gem";
    };
    version = "3.4.2";
  };
  fluent-plugin-mongo = {
    dependencies = ["fluentd" "mongo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rpaglr8hka0prvj5xsrl1af3137c7ma1d1xf1mvib5k9h0aax1f";
      type = "gem";
    };
    version = "1.5.0";
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
      sha256 = "1vjvn8ph87cl2dl0dbaap69rciglsdma1y5ghn2vm5mvh5h7xbs6";
      type = "gem";
    };
    version = "2.4.0";
  };
  fluent-plugin-s3 = {
    dependencies = ["aws-sdk-s3" "aws-sdk-sqs" "fluentd"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "191j1y76irfgrsj259mj062izkfxrr5kajixdf17h26m3l9n5pgh";
      type = "gem";
    };
    version = "1.6.1";
  };
  fluent-plugin-webhdfs = {
    dependencies = ["fluentd" "webhdfs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1llpsbd5n2lgxbq16px5hbp3zfw65bdp46b08v87b6rmn3h47aiv";
      type = "gem";
    };
    version = "1.5.0";
  };
  fluentd = {
    dependencies = ["cool.io" "http_parser.rb" "msgpack" "serverengine" "sigdump" "strptime" "tzinfo" "tzinfo-data" "webrick" "yajl-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vrw0i286ssrr33g1zayqjk9fxmjz8a4xhrka0id2a9w3ncq275z";
      type = "gem";
    };
    version = "1.14.3";
  };
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dwx4ns39bpmzmhglyip9d68i117zspf5lp865pf6hrsmmdf2k53";
      type = "gem";
    };
    version = "3.19.1";
  };
  "http_parser.rb" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gj4fmls0mf52dlr928gaq0c0cb0m3aqa9kaa6l0ikl2zbqk42as";
      type = "gem";
    };
    version = "0.8.0";
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
      sha256 = "06iajjyhx0rvpn4yr3h1hc4w4w3k59bdmfhxnjzzh76wsrdxxrc6";
      type = "gem";
    };
    version = "1.4.2";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
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
      sha256 = "1xqcgkl7bwws1qrlnmxgh8g4g9m10vg60bhlw40fplninb3ng6d9";
      type = "gem";
    };
    version = "4.0.6";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15whn7p9nrkxangbs9hh75q585yfn66lv0v2mhj6q6dl6x8bzr2w";
      type = "gem";
    };
    version = "13.0.6";
  };
  ruby-kafka = {
    dependencies = ["digest-crc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bmp3nsf836z3392drhlfmhav2025k46yj8sbhphpphr22v3ka7k";
      type = "gem";
    };
    version = "1.4.0";
  };
  ruby2_keywords = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  serverengine = {
    dependencies = ["sigdump"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gzhggx40a53mnv4f32xag4h6ai0s5m3w06s59b0h6ih7rqvwns9";
      type = "gem";
    };
    version = "2.2.4";
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
      sha256 = "1ycs0xz58kymf7yp4h56f0nid2z7g3s18dj7pa3p790pfzzpgvcq";
      type = "gem";
    };
    version = "0.2.5";
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10qp5x7f9hvlc0psv9gsfbxg4a7s0485wsbq1kljkxq94in91l4z";
      type = "gem";
    };
    version = "2.0.4";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w1iyvw0m2xvdr4654jnn1g27jwj84y94dvaj1k2p3lcrvndm698";
      type = "gem";
    };
    version = "1.2021.5";
  };
  webhdfs = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pkdsj8ybjfp1sr7gzdxd7van5fpmhc9v2c5g3hifdx4s4yzhcq7";
      type = "gem";
    };
    version = "0.10.2";
  };
  webrick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d4cvgmxhfczxiq5fr534lmizkhigd15bsx5719r5ds7k7ivisc7";
      type = "gem";
    };
    version = "1.7.0";
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
