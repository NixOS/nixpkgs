{
  amq-protocol = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rpn9vgh7y037aqhhp04smihzr73vp5i5g6xlqlha10wy3q0wp7x";
      type = "gem";
    };
    version = "2.0.1";
  };
  amqp = {
    dependencies = ["amq-protocol" "eventmachine"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kbrqnpjgj9v0722p3n5rw589l4g26ry8mcghwc5yr20ggkpdaz9";
      type = "gem";
    };
    version = "1.6.0";
  };
  aws-sdk = {
    dependencies = ["aws-sdk-resources"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k367vs9gb640cr1afphxjfmlykw7knnb9xz0kl2x5f9yr3zz23";
      type = "gem";
    };
    version = "2.10.34";
  };
  aws-sdk-core = {
    dependencies = ["aws-sigv4" "jmespath"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gfsph8kr59jdpvycq8qh0c0ah64k0n96ag5qbvy7mzq9292085w";
      type = "gem";
    };
    version = "2.10.34";
  };
  aws-sdk-resources = {
    dependencies = ["aws-sdk-core"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0knip45mhx0dm8llp1akhhar2z007r7kjg3i3xbws7lhvms8fbjc";
      type = "gem";
    };
    version = "2.10.34";
  };
  aws-sigv4 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cxl0yvmyl8d0yj4cx3p75iki4fqk8ckb6ajfj7mr3g4ihp5mryp";
      type = "gem";
    };
    version = "1.0.1";
  };
  cause = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0digirxqlwdg79mkbn70yc7i9i1qnclm2wjbrc47kqv6236bpj00";
      type = "gem";
    };
    version = "0.1";
  };
  childprocess = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lv7axi1fhascm9njxh3lx1rbrnsm8wgvib0g7j26v4h1fcphqg0";
      type = "gem";
    };
    version = "0.5.8";
  };
  dentaku = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11z4cw4lspx3rgmmd2hd4l1iikk6p17icxwn7xym92v1j825zpnr";
      type = "gem";
    };
    version = "2.0.9";
  };
  domain_name = {
    dependencies = ["unf"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12hs8yijhak7p2hf1xkh98g0mnp5phq3mrrhywzaxpwz1gw5r3kf";
      type = "gem";
    };
    version = "0.5.20170404";
  };
  em-http-server = {
    dependencies = ["eventmachine"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y8l4gymy9dzjjchjav90ck6has2i2zdjihlhcyrg3jgq6kjzyq5";
      type = "gem";
    };
    version = "0.1.8";
  };
  em-worker = {
    dependencies = ["eventmachine"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z4jx9z2q5hxvdvik4yp0ahwfk69qsmdnyp72ln22p3qlkq2z5wk";
      type = "gem";
    };
    version = "0.0.2";
  };
  eventmachine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "075hdw0fgzldgss3xaqm2dk545736khcvv1fmzbf1sgdlkyh1v8z";
      type = "gem";
    };
    version = "1.2.5";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "034f52xf7zcqgbvwbl20jwdyjwznvqnwpbaps9nk18v9lgb1dpx0";
      type = "gem";
    };
    version = "1.9.18";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
      type = "gem";
    };
    version = "1.0.3";
  };
  influxdb = {
    dependencies = ["cause" "json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jikl3iylbffsdmb4vr09ysqvpwxk133y6m9ylwcd0931ngsf0ks";
      type = "gem";
    };
    version = "0.3.13";
  };
  jmespath = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07w8ipjg59qavijq59hl82zs74jf3jsp7vxl9q3a2d0wpv5akz3y";
      type = "gem";
    };
    version = "1.3.1";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qmj7fypgb9vag723w1a49qihxrcf5shzars106ynw2zk352gbv5";
      type = "gem";
    };
    version = "1.8.6";
  };
  jsonpath = {
    dependencies = ["multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gwhrd7xlysq537yy8ma69jc83lblwiccajl5zvyqpnwyjjc93df";
      type = "gem";
    };
    version = "0.5.8";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0087z9kbnlqhci7fxh9f6il63hj1k02icq2rs0c6cppmqchr753m";
      type = "gem";
    };
    version = "3.1";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04my3746hwa4yvbx1ranhfaqkgf6vavi1kyijjnw8w3dy37vqhkm";
      type = "gem";
    };
    version = "3.2016.0521";
  };
  mixlib-cli = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0647msh7kp7lzyf6m72g6snpirvhimjm22qb8xgv9pdhbcrmcccp";
      type = "gem";
    };
    version = "1.7.0";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wpc23ls6v2xbk3l1qncsbz16npvmw8p0b38l8czdzri18mp51xk";
      type = "gem";
    };
    version = "1.12.1";
  };
  netrc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  oj = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "147whmq8h2n04chskl3v4a132xhz5i6kk6vhnz83jwng4vihin5f";
      type = "gem";
    };
    version = "2.18.1";
  };
  parse-cron = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02fj9i21brm88nb91ikxwxbwv9y7mb7jsz6yydh82rifwq7357hg";
      type = "gem";
    };
    version = "0.1.4";
  };
  rest-client = {
    dependencies = ["http-cookie" "mime-types" "netrc"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hzcs2r7b5bjkf2x2z3n8z6082maz0j8vqjiciwgg3hzb63f958j";
      type = "gem";
    };
    version = "2.0.2";
  };
  sensu = {
    dependencies = ["em-http-server" "eventmachine" "parse-cron" "sensu-extension" "sensu-extensions" "sensu-json" "sensu-logger" "sensu-redis" "sensu-settings" "sensu-spawn" "sensu-transport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07fa9rv7hdj2n58a0cm1i5nis309w7xbs9lmgckmrpj190q1gvdm";
      type = "gem";
    };
    version = "1.0.3";
  };
  sensu-extension = {
    dependencies = ["eventmachine"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lgmjxfbq11v4yi3qanf1qxv0sgm1a8a7wj7qyn1nkva6zmimss3";
      type = "gem";
    };
    version = "1.5.1";
  };
  sensu-extensions = {
    dependencies = ["sensu-extension" "sensu-extensions-check-dependencies" "sensu-extensions-debug" "sensu-extensions-json" "sensu-extensions-occurrences" "sensu-extensions-only-check-output" "sensu-extensions-ruby-hash" "sensu-json" "sensu-logger" "sensu-settings"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r09mdbbnh5cg9yvqw78sxbhlb8xqld1vwbr4hsjw6k3x1xpnnr9";
      type = "gem";
    };
    version = "1.9.0";
  };
  sensu-extensions-check-dependencies = {
    dependencies = ["sensu-extension"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0clgvf2abvwz549f28ny3zd6q7z6y7m49i8pp91ll10jp1vsy4b2";
      type = "gem";
    };
    version = "1.0.1";
  };
  sensu-extensions-debug = {
    dependencies = ["sensu-extension"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11abdgn2kkkbvxq4692yg6a27qnxz4349gfiq7d35biy7vrw34lp";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-extensions-json = {
    dependencies = ["sensu-extension"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wnbn9sycdqdh9m0fhszaqkv0jijs3fkdbvcv8kdspx6irbv3m6g";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-extensions-occurrences = {
    dependencies = ["sensu-extension"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lx5wsbblfs0rvkxfg09bsz0g2mwmckrhga7idnarsnm8m565v1v";
      type = "gem";
    };
    version = "1.2.0";
  };
  sensu-extensions-only-check-output = {
    dependencies = ["sensu-extension"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ds2i8wd4ji9ifig2zzr4jpxinvk5dm7j10pvaqy4snykxa3rqh3";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-extensions-ruby-hash = {
    dependencies = ["sensu-extension"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xyrj3gbmslbivcd5qcmyclgapn7qf7f5jwfvfpw53bxzib0h7s3";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-json = {
    dependencies = ["oj"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02qkh86jddv7gha39vjx6g9hi7vkq7r433dr86bwmm9c7lqkgyl9";
      type = "gem";
    };
    version = "2.1.0";
  };
  sensu-logger = {
    dependencies = ["eventmachine" "sensu-json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03kicjqz8a594bxnwyg6bcd4fipy2vxjl1gbaip4gpixxki32dx0";
      type = "gem";
    };
    version = "1.2.1";
  };
  sensu-plugin = {
    dependencies = ["json" "mixlib-cli"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z18zk04l9klbjmqvjg6cpv3k4w5hi1by8wnpkiwdwa2jdv61jyb";
      type = "gem";
    };
    version = "1.4.5";
  };
  sensu-plugins-disk-checks = {
    dependencies = ["sensu-plugin" "sys-filesystem"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m5pygdaf8xqrby61vcsq6ynhzcvjr2xgahwmkkcai8a4xqrpq9x";
      type = "gem";
    };
    version = "2.4.2";
  };
  sensu-plugins-http = {
    dependencies = ["aws-sdk" "rest-client" "sensu-plugin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yg05x9dl4xwqi7lvglyv374a3hbp7ag0z9325jmc9bazm6i2q2d";
      type = "gem";
    };
    version = "2.6.0";
  };
  sensu-plugins-influxdb = {
    dependencies = ["dentaku" "influxdb" "jsonpath" "sensu-plugin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18nk7c451df46xcjk97r3h8yhaj8bz138ih5y0z26sdiha58brv7";
      type = "gem";
    };
    version = "1.2.0";
  };
  sensu-plugins-logs = {
    dependencies = ["sensu-plugin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ycrf3967v5kavm58fj9db16l9wgyzac4h3r0f9hm32jy9qsxwq6";
      type = "gem";
    };
    version = "1.2.0";
  };
  sensu-plugins-systemd = {
    dependencies = ["sensu-plugin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r7prvkf33j6qvvqq78186rn5g6wf0g3dqni34vnj8v1z287wkfh";
      type = "gem";
    };
    version = "0.0.5";
  };
  sensu-redis = {
    dependencies = ["eventmachine"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1drmychc04fg2gs7zsxx6aidfyxf7cn7k8k1jy7dnfbnlr5aln3n";
      type = "gem";
    };
    version = "2.2.0";
  };
  sensu-settings = {
    dependencies = ["parse-cron" "sensu-json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y55bqvps06gk94zllamqr0fa5bc27q0k1b5sp5gxh1bkf4w8gb3";
      type = "gem";
    };
    version = "10.3.0";
  };
  sensu-spawn = {
    dependencies = ["childprocess" "em-worker" "eventmachine"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz5kbqk3ld0s16zjl8m38l1m1xwcvjlfc1g4nfm45qxdyfn7la7";
      type = "gem";
    };
    version = "2.2.1";
  };
  sensu-transport = {
    dependencies = ["amq-protocol" "amqp" "eventmachine" "sensu-redis"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15yib92hwyd8v04wcc0kaw0p8w2c2mwvi4ldya2jh3dqgs31mvhr";
      type = "gem";
    };
    version = "7.0.2";
  };
  sys-filesystem = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10didky52nfapmybj6ipda18i8fcwf8bs9bbfbk5i7v1shzd36rf";
      type = "gem";
    };
    version = "1.1.7";
  };
  unf = {
    dependencies = ["unf_ext"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14hr2dzqh33kqc0xchs8l05pf3kjcayvad4z1ip5rdjxrkfk8glb";
      type = "gem";
    };
    version = "0.0.7.4";
  };
}