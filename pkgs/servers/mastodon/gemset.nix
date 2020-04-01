{
  actioncable = {
    dependencies = ["actionpack" "nio4r" "websocket-driver"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yz5mcjl4is99650vq6rkv539xccq8mp5zsbvzh43wqzfga1llwm";
      type = "gem";
    };
    version = "5.2.4.1";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dbw3q3yyh7m7wgc4196hc3v86v123z0xz40llmic8iwx3d9vnda";
      type = "gem";
    };
    version = "5.2.4.1";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f5pm62y08j679k3vhcml8436f92kripd6j3v5dyvn760kwzz72z";
      type = "gem";
    };
    version = "5.2.4.1";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hnkyx268czfb6ljv6ipcnz9dbgsb1z9n1gcr6279z9wx9550zij";
      type = "gem";
    };
    version = "5.2.4.1";
  };
  active_model_serializers = {
    dependencies = ["actionpack" "activemodel" "case_transform" "jsonapi-renderer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p8rhy2bw86d0l3d0l97zj179yqzl338v7r5pvl8mdagcrp2fw9i";
      type = "gem";
    };
    version = "0.10.10";
  };
  active_record_query_trace = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08r87g47rv4j8svz4zp2g8ck7j3i0cdrbh53lkr58434s1fakdqc";
      type = "gem";
    };
    version = "1.7";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k4j3fcfc8m4hxwhs8xnbxazra760j3amn5r2zm2d5r1a1nqfh91";
      type = "gem";
    };
    version = "5.2.4.1";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sg1yyz710pxhq9z0jsbpbgn666y8iv4aj7pywglydipp4i0bpx1";
      type = "gem";
    };
    version = "5.2.4.1";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p35d6pj1370mnlppqq9lhr7m1ck82xvv621wq6hy12v41qfdnrg";
      type = "gem";
    };
    version = "5.2.4.1";
  };
  activestorage = {
    dependencies = ["actionpack" "activerecord" "marcel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dd8k91b88b875mypwqific2jilgzj5bx1637cwmzi4c0cy1v17f";
      type = "gem";
    };
    version = "5.2.4.1";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lmlnx79sv18xv1ddm4vq7z3mwdfa4468mq5186av0k8n1k471sp";
      type = "gem";
    };
    version = "5.2.4.1";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fvchp2rhp2rmigx7qglf69xvjqvzq7x0g49naliw29r2bz656sy";
      type = "gem";
    };
    version = "2.7.0";
  };
  airbrussh = {
    dependencies = ["sshkit"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16lmd6173gvhcpzj1blracx6hhlqjmmmmi4rh5y4lz6c87vg51lp";
      type = "gem";
    };
    version = "1.4.0";
  };
  annotate = {
    dependencies = ["activerecord" "rake"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zy4flmvp9idsasld2qwaylrb0ssnn80yml6z7vn77grf4kp0ir3";
      type = "gem";
    };
    version = "3.0.3";
  };
  arel = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jk7wlmkr61f6g36w9s2sn46nmdg6wn2jfssrhbhirv5x9n95nk0";
      type = "gem";
    };
    version = "9.0.0";
  };
  ast = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "184ssy3w93nkajlz2c70ifm79jp3j737294kbc5fjw69v1w0n9x7";
      type = "gem";
    };
    version = "2.4.0";
  };
  attr_encrypted = {
    dependencies = ["encryptor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ncv2az1zlj33bsllr6q1qdvbw42gv91lxq0ryclbv8l8xh841jg";
      type = "gem";
    };
    version = "3.1.0";
  };
  av = {
    dependencies = ["cocaine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1swakpybf6g0nzfdn6q4s9c97ysc3i4ffk84dw8v2321fpvc8gqq";
      type = "gem";
    };
    version = "0.9.0";
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
      sha256 = "1mdx146v290vcrd6aihkv3cx7iw1yi6qq4n4vjl7pzj7w8v0zh16";
      type = "gem";
    };
    version = "1.261.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "137mvm64b86sp6klfq5b2m412v2q1b1vjyd5f0iymkr70yqvm420";
      type = "gem";
    };
    version = "3.86.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rzzfxvxqqgjh01z9pm4kdh6y45gkqgfraf6irn5m260k7ynccmm";
      type = "gem";
    };
    version = "1.27.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x8k9kqzyan3rp8gmzigqc96nyyi4mb33pg2c9mzbyqxg3z2wah6";
      type = "gem";
    };
    version = "1.60.1";
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
  bcrypt = {
    groups = ["default" "pam_authentication"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ysblqxkclmnhrd0kmb5mr8p38mbar633gdsb14b7dhkhgawgzfy";
      type = "gem";
    };
    version = "3.1.12";
  };
  better_errors = {
    dependencies = ["coderay" "erubi" "rack"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mq43k4szfgcdanhdwacyp7yvldl76m9arhdj9n0x25dmbdzp2yn";
      type = "gem";
    };
    version = "2.5.1";
  };
  binding_of_caller = {
    dependencies = ["debug_inspector"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05syqlks7463zsy1jdfbbdravdhj9hpj5pv2m74blqpv8bq4vv5g";
      type = "gem";
    };
    version = "0.8.0";
  };
  blurhash = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04halkacf3pd030s3bqfjd59vbj47lchrhp9zvwsn4c6sdrfjdd4";
      type = "gem";
    };
    version = "0.1.4";
  };
  bootsnap = {
    dependencies = ["msgpack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dyjk2irr0d3d3am2dzipg1zyv2nz69a16g8xkprxfa0na07wvs0";
      type = "gem";
    };
    version = "1.4.5";
  };
  brakeman = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j1svldxvbl27kpyp9yngfwa0fdqal926sjk0cha7h520wvnz79k";
      type = "gem";
    };
    version = "4.7.2";
  };
  browser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16q3qgczp91rrl05579jk3xj5l2bqx532jd8n3ji5m5wrba3nvdi";
      type = "gem";
    };
    version = "3.0.3";
  };
  builder = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      type = "gem";
    };
    version = "3.2.4";
  };
  bullet = {
    dependencies = ["activesupport" "uniform_notifier"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18ifwnvn13755qkfigapyj5bflpby3phxzbb7x5336d0kzv5k7d9";
      type = "gem";
    };
    version = "6.1.0";
  };
  bundler-audit = {
    dependencies = ["thor"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pm22xpn3xyymsainixnrk8v3l3xi9bzwkjkspx00cfzp84xvxbq";
      type = "gem";
    };
    version = "0.6.1";
  };
  byebug = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18a9wlwvwxi86nldj56jbk6pwx3rd8l5xi6p8ap24p169h9m8wc4";
      type = "gem";
    };
    version = "11.1.1";
  };
  capistrano = {
    dependencies = ["airbrussh" "i18n" "rake" "sshkit"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ddn7f5dqmz1xv5fs95vijlvb25zsd0x62pwmr36fzylh86xrf99";
      type = "gem";
    };
    version = "3.11.2";
  };
  capistrano-bundler = {
    dependencies = ["capistrano" "sshkit"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p00rw2886v77kfjnh0mslyrv4lij5fa9niflz1lhynzlivgrmdr";
      type = "gem";
    };
    version = "1.3.0";
  };
  capistrano-rails = {
    dependencies = ["capistrano" "capistrano-bundler"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19j82kiarrph1ilw2xfhfj62z0b53w0gph7613b21iccb2gn3dqy";
      type = "gem";
    };
    version = "1.4.0";
  };
  capistrano-rbenv = {
    dependencies = ["capistrano" "sshkit"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "011g7f1r7kcmbjk4q0srl12pc9x27m0sg96j9b6cxsny5zpi8843";
      type = "gem";
    };
    version = "2.1.6";
  };
  capistrano-yarn = {
    dependencies = ["capistrano"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zdg2s061vl5b8114n909mrjb2hc1qx0i4wqx9nacsrcjgyp07l9";
      type = "gem";
    };
    version = "2.0.2";
  };
  capybara = {
    dependencies = ["addressable" "mini_mime" "nokogiri" "rack" "rack-test" "regexp_parser" "xpath"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fhgnw6xgnphaka50b995mcmc2pjifmlr8ypz6dw2a6jkz3qqlcl";
      type = "gem";
    };
    version = "3.31.0";
  };
  case_transform = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fzyws6spn5arqf6q604dh9mrj84a36k5hsc8z7jgcpfvhc49bg2";
      type = "gem";
    };
    version = "0.2";
  };
  charlock_holmes = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hybw8jw9ryvz5zrki3gc9r88jqy373m6v46ynxsdzv1ysiyr40p";
      type = "gem";
    };
    version = "0.7.7";
  };
  chewy = {
    dependencies = ["activesupport" "elasticsearch" "elasticsearch-dsl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dczmxh09s0s8d2l111zdb49s0c6wa1s09dslh8prqms6r4n544f";
      type = "gem";
    };
    version = "5.1.0";
  };
  chunky_png = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "124najs9prqzrzk49h53kap992rmqxj0wni61z2hhsn7mwmgdp9d";
      type = "gem";
    };
    version = "1.3.11";
  };
  cld3 = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06fzqykaz46bzipriaqfs5a8xqy7gnh4757nhw74nycgly7362n2";
      type = "gem";
    };
    version = "3.2.6";
  };
  climate_control = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q11v0iabvr6rif0d025xh078ili5frrihlj0m04zfg7lgvagxji";
      type = "gem";
    };
    version = "0.2.0";
  };
  cocaine = {
    dependencies = ["climate_control"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01kk5xd7lspbkdvn6nyj0y51zhvia3z6r4nalbdcqw5fbsywwi7d";
      type = "gem";
    };
    version = "0.5.8";
  };
  coderay = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vav4bhcc2x3jmi3izb11l4d9f3xv8hp2fszb7iqmpsccv1pz4y";
      type = "gem";
    };
    version = "1.1.2";
  };
  concurrent-ruby = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x07r23s7836cpp5z9yrlbpljcxpax14yw4fy4bnp6crhr6x24an";
      type = "gem";
    };
    version = "1.1.5";
  };
  connection_pool = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lflx29mlznf1hn0nihkgllzbj8xp5qasn8j7h838465pi399k68";
      type = "gem";
    };
    version = "2.2.2";
  };
  crack = {
    dependencies = ["safe_yaml"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0abb0fvgw00akyik1zxnq7yv391va148151qxdghnzngv66bl62k";
      type = "gem";
    };
    version = "0.4.3";
  };
  crass = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    version = "1.0.6";
  };
  css_parser = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04c4dl8cm5rjr50k9qa6yl9r05fk9zcb1zxh0y0cdahxlsgcydfw";
      type = "gem";
    };
    version = "1.7.1";
  };
  debug_inspector = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vxr0xa1mfbkfcrn71n7c4f2dj7la5hvphn904vh20j3x4j5lrx0";
      type = "gem";
    };
    version = "0.0.3";
  };
  devise = {
    dependencies = ["bcrypt" "orm_adapter" "railties" "responders" "warden"];
    groups = ["default" "pam_authentication"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a64xq0dj6p0firpg4mrrfmlakpv17hky5yfrjhchs2sybmymr9i";
      type = "gem";
    };
    version = "4.7.1";
  };
  devise-two-factor = {
    dependencies = ["activesupport" "attr_encrypted" "devise" "railties" "rotp"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzk7phrryxlq4k3jrcxm8faifmbqrbfxq7jx089ncsixwd69bn4";
      type = "gem";
    };
    version = "3.1.0";
  };
  devise_pam_authenticatable2 = {
    dependencies = ["devise" "rpam2"];
    groups = ["pam_authentication"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13ipl52pkhc6vxp8ca31viwv01237bi2bfk3b1fixq1x46nf87p2";
      type = "gem";
    };
    version = "9.2.0";
  };
  diff-lcs = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
  };
  discard = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pp9wkbkw4bxl2qym4fy2w8bhri2s8p1f441n5kjlrmyqsv07w89";
      type = "gem";
    };
    version = "1.1.0";
  };
  docile = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qrwiyagxzl8zlx3dafb0ay8l14ib7imb2rsmx70i5cp420v8gif";
      type = "gem";
    };
    version = "1.3.2";
  };
  domain_name = {
    dependencies = ["unf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lcqjsmixjp52bnlgzh4lg9ppsk52x9hpwdjd53k8jnbah2602h0";
      type = "gem";
    };
    version = "0.5.20190701";
  };
  doorkeeper = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kg44r2hlcxjq48zish37f0x1h9cnk6s8ynis3ij4mcgwy71cwnk";
      type = "gem";
    };
    version = "5.2.3";
  };
  dotenv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17hkd62ig9b0czv192kqdfq7gw0a8hgq07yclri6myc8y5lmfin5";
      type = "gem";
    };
    version = "2.7.5";
  };
  dotenv-rails = {
    dependencies = ["dotenv" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "028a14sl4h9mpfsvapqb9c7l54a7pj7wnj4hdri5himq52y6kpp0";
      type = "gem";
    };
    version = "2.7.5";
  };
  e2mmap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n8gxjb63dck3vrmsdcqqll7xs7f3wk78mw8w0gdk9wp5nx6pvj5";
      type = "gem";
    };
    version = "0.1.0";
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
  elasticsearch-dsl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13yzdim3dc32bvsind4yk6asam75yh4s78lda8bnxf8kb13dznlq";
      type = "gem";
    };
    version = "0.1.8";
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
  encryptor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s8rvfl0vn8w7k1sgkc234060jh468s3zd45xa64p1jdmfa3zwmb";
      type = "gem";
    };
    version = "3.0.0";
  };
  equatable = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fzx2ishipnp6c124ka6fiw5wk42s7c7gxid2c4c1mb55b30dglf";
      type = "gem";
    };
    version = "0.6.1";
  };
  erubi = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nwzxnqhr31fn7nbqmffcysvxjdfl3bhxi0bld5qqhcnfc1xd13x";
      type = "gem";
    };
    version = "1.9.0";
  };
  et-orbi = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wk7i0bmsy46la8gcvbmdns0ni8lmdqas838phj97bdwykxw8m4b";
      type = "gem";
    };
    version = "1.1.6";
  };
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0karcvkw4mn5hvpjdmg65yvrnrvhzjg8fgk1z4b4crbhkbmvp1cp";
      type = "gem";
    };
    version = "0.71.0";
  };
  fabrication = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z2v6j3dlv6laldky9364696d1wcg3smz5h9zm6ax0d404hpl4n6";
      type = "gem";
    };
    version = "2.21.0";
  };
  faker = {
    dependencies = ["i18n"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13h4ijsx5jvb9lnyi9llxpcxp213m08j82zs4xyf09rrzr6x4mly";
      type = "gem";
    };
    version = "2.10.1";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11yn7mhi4rl24brs2qfwysas14csjf1zmb835cfklqz5ka032xp6";
      type = "gem";
    };
    version = "1.0.0";
  };
  fast_blank = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16s1ilyvwzmkcgmklbrn0c2pch5n02vf921njx0bld4crgdr6z56";
      type = "gem";
    };
    version = "1.0.0";
  };
  fastimage = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06lgsy1zdkhhgd9w1c0nb7v9d38mljwz13n6gi3acbzkhz1sf642";
      type = "gem";
    };
    version = "2.1.7";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j8pzj8raxbir5w5k6s7a042sb5k02pg0f8s4na1r5lan901j00p";
      type = "gem";
    };
    version = "1.10.0";
  };
  ffi-compiler = {
    dependencies = ["ffi" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c2caqm9wqnbidcb8dj4wd3s902z15qmgxplwyfyqbwa0ydki7q1";
      type = "gem";
    };
    version = "1.0.1";
  };
  fog-core = {
    dependencies = ["builder" "excon" "formatador" "mime-types"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1agd6xgzk0rxrsjdpn94v4hy89s0nm2cs4zg2p880w2dan9xgrak";
      type = "gem";
    };
    version = "2.1.0";
  };
  fog-json = {
    dependencies = ["fog-core" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj8llzc119zafbmfa4ai3z5s7c4vp9akfs0f9l2piyvcarmlkyx";
      type = "gem";
    };
    version = "1.2.0";
  };
  fog-openstack = {
    dependencies = ["fog-core" "fog-json" "ipaddress"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aphjrvmchmqbyxqq82yj0qngyvkmwdci9iqs8722fi23bk83gdl";
      type = "gem";
    };
    version = "0.3.7";
  };
  formatador = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gc26phrwlmlqrmz4bagq1wd5b7g64avpx0ghxr9xdxcvmlii0l0";
      type = "gem";
    };
    version = "0.2.5";
  };
  fugit = {
    dependencies = ["et-orbi" "raabro"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1szijawzdii668z5is9xi849399gy786951dx0l5r2z5mbfqvl9i";
      type = "gem";
    };
    version = "1.1.6";
  };
  fuubar = {
    dependencies = ["rspec-core" "ruby-progressbar"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "090sx0ck194am6v3hwfld2ijvldd0mjwplqz8r36p34l4p8z9d79";
      type = "gem";
    };
    version = "2.5.0";
  };
  globalid = {
    dependencies = ["activesupport"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zkxndvck72bfw235bd9nl2ii0lvs5z88q14706cmn702ww2mxv1";
      type = "gem";
    };
    version = "0.4.2";
  };
  goldfinger = {
    dependencies = ["addressable" "http" "nokogiri" "oj"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "101ijr0gh6jnjliddvgvmnjz8zr5iyf18bxj8g4h4583fcwcyls4";
      type = "gem";
    };
    version = "2.1.1";
  };
  hamlit = {
    dependencies = ["temple" "thor" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13wkrvyldk21xlc9illam495fpgf7w7bksaj8y6n00y036wmbg60";
      type = "gem";
    };
    version = "2.11.0";
  };
  hamlit-rails = {
    dependencies = ["actionpack" "activesupport" "hamlit" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v75yd6x0nwky83smd9hw5ym9h0pi32jrzbnvq55pzj0rc95gg2p";
      type = "gem";
    };
    version = "0.2.3";
  };
  hamster = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n1lsh96vnyc1pnzyd30f9prcsclmvmkdb3nm5aahnyizyiy6lar";
      type = "gem";
    };
    version = "3.0.0";
  };
  hashdiff = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18jqpbvidrlnq3xf0hkdbs00607jgz35lry6gjw4bcxgh52am2mk";
      type = "gem";
    };
    version = "1.0.0";
  };
  hashie = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13bdzfp25c8k51ayzxqkbzag3wj5gc1jd8h7d985nsq6pn57g5xh";
      type = "gem";
    };
    version = "3.6.0";
  };
  health_check = {
    dependencies = ["rails"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "0b799ead604f900ed50685e9b2d469cd2befba5b";
      sha256 = "0yz4axwkynsnng8xswrg2ysxlkjwfw0v4padvqwm4xal7nri172d";
      type = "git";
      url = "https://github.com/ianheggie/health_check";
    };
    version = "4.0.0.pre";
  };
  highline = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yclf57n2j3cw8144ania99h1zinf8q3f5zrhqa754j6gl95rp9d";
      type = "gem";
    };
    version = "2.0.3";
  };
  hiredis = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04jj8k7lxqxw24sp0jiravigdkgsyrpprxpxm71ba93x1wr2w1bz";
      type = "gem";
    };
    version = "0.6.3";
  };
  hkdf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04fixg0a51n4vy0j6c1hvisa2yl33m3jrrpxpb5sq6j511vjriil";
      type = "gem";
    };
    version = "0.3.0";
  };
  htmlentities = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  http = {
    dependencies = ["addressable" "http-cookie" "http-form_data" "http-parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sfx18hs1r48xxhfijhk6g18h1g9q3571m8y9mxvc58mnx3cisgi";
      type = "gem";
    };
    version = "4.3.0";
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
  http-form_data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l9r0izad55cii0vk5sm8byhybgh2fms8d8fc091r8y2azgcqxky";
      type = "gem";
    };
    version = "2.2.0";
  };
  http-parser = {
    dependencies = ["ffi-compiler"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10wz818i7dq5zkcll0yf7pbjz1zqvs7mgh3xg3x6www2f2ccwxqj";
      type = "gem";
    };
    version = "1.2.1";
  };
  http_accept_language = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d0nlfz9vm4jr1l6q0chx4rp2hrnrfbx3gadc1dz930lbbaz0hq0";
      type = "gem";
    };
    version = "2.1.1";
  };
  "http_parser.rb" = {
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = true;
      rev = "54b17ba8c7d8d20a16dfc65d1775241833219cf2";
      sha256 = "16ihplh821kjbck9kjvqr780qsx9wi9vyc6kpmydj44r2pq76v59";
      type = "git";
      url = "https://github.com/tmm1/http_parser.rb";
    };
    version = "0.6.1";
  };
  httplog = {
    dependencies = ["rack" "rainbow"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a9prznl3n8vy4hv2l05pfcj2ylval4mgivj2b67r0m5yrm1dkrs";
      type = "gem";
    };
    version = "1.4.2";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jwrd1l4mxz06iyx6053lr6hz2zy7ah2k3ranfzisvych5q19kwm";
      type = "gem";
    };
    version = "1.8.2";
  };
  i18n-tasks = {
    dependencies = ["activesupport" "ast" "erubi" "highline" "i18n" "parser" "rails-i18n" "rainbow" "terminal-table"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0di4ya58bp1gcjlllrg28jhi7pd18ybrfx2wmb8kxk8mcdvg57jv";
      type = "gem";
    };
    version = "0.9.30";
  };
  idn-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07vblcyk3g72sbq12xz7xj28snpxnh3sbcnxy8bglqbfqqhvmawr";
      type = "gem";
    };
    version = "0.1.0";
  };
  ipaddress = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x86s0s11w202j6ka40jbmywkrx8fhq8xiy8mwvnkhllj57hqr45";
      type = "gem";
    };
    version = "0.8.3";
  };
  iso-639 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10k1gpkkbxbasgjzh4hd32ygxzjb5312rphipm46ryxkpx556zzz";
      type = "gem";
    };
    version = "0.2.8";
  };
  jaro_winkler = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y8l6k34svmdyqxya3iahpwbpvmn3fswhwsvrz0nk1wyb8yfihsh";
      type = "gem";
    };
    version = "1.5.4";
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
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nrmw2r4nfxlfgprfgki3hjifgrcrs3l5zvm3ca3gb4743yr25mn";
      type = "gem";
    };
    version = "2.3.0";
  };
  json-canonicalization = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "014lc8am17m2amfkzdfc9ksaafnwpb7zzr8l7382r60zkkgpkljg";
      type = "gem";
    };
    version = "0.2.0";
  };
  json-ld = {
    dependencies = ["htmlentities" "json-canonicalization" "link_header" "multi_json" "rack" "rdf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11cjj6ylmlh3pp3yfika0gn2p9k28mb1l4l0l57rvkz16425b1y4";
      type = "gem";
    };
    version = "3.1.0";
  };
  json-ld-preloaded = {
    dependencies = ["json-ld" "rdf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x9kxfr1qvnhdhjv9wsi599bhnnlxiirjy8jrqa6k8dvalwij9ah";
      type = "gem";
    };
    version = "3.1.0";
  };
  jsonapi-renderer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ys4drd0k9rw5ixf8n8fx8v0pjh792w4myh0cpdspd317l1lpi5m";
      type = "gem";
    };
    version = "0.2.2";
  };
  jwt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w0kaqrbl71cq9sbnixc20x5lqah3hs2i93xmhlfdg2y3by7yzky";
      type = "gem";
    };
    version = "2.1.0";
  };
  kaminari = {
    dependencies = ["activesupport" "kaminari-actionview" "kaminari-activerecord" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j27y5phifwpggspglmg8pmlf6n4jblxwziix9am42661c770jlm";
      type = "gem";
    };
    version = "1.1.1";
  };
  kaminari-actionview = {
    dependencies = ["actionview" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1386wshpy1ygbris0s7rv7lyzbs0v8dfqkzdwsrsgm9fd1ira640";
      type = "gem";
    };
    version = "1.1.1";
  };
  kaminari-activerecord = {
    dependencies = ["activerecord" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q31ik5648xi2hpy61knnjd0m7rvs17i93gzwcbh3ccj1y24gv2x";
      type = "gem";
    };
    version = "1.1.1";
  };
  kaminari-core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cfjrhvidvgdwp9ffsm9d4c2s18k2zp3gnya3f41qb3fc6bc2q2w";
      type = "gem";
    };
    version = "1.1.1";
  };
  launchy = {
    dependencies = ["addressable"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190lfbiy1vwxhbgn4nl4dcbzxvm049jwc158r2x7kq3g5khjrxa2";
      type = "gem";
    };
    version = "2.4.3";
  };
  letter_opener = {
    dependencies = ["launchy"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09a7kgsmr10a0hrc9bwxglgqvppjxij9w8bxx91mnvh0ivaw0nq9";
      type = "gem";
    };
    version = "1.7.0";
  };
  letter_opener_web = {
    dependencies = ["actionmailer" "letter_opener" "railties"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pianlrbf9n7jrqxpyxgsfk1j1d312d57d6gq7yxni6ax2q0293q";
      type = "gem";
    };
    version = "1.4.0";
  };
  link_header = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yamrdq4rywmnpdhbygnkkl9fdy249fg5r851nrkkxr97gj5rihm";
      type = "gem";
    };
    version = "0.0.8";
  };
  lograge = {
    dependencies = ["actionpack" "activesupport" "railties" "request_store"];
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vrjm4yqn5l6q5gsl72fmk95fl6j9z1a05gzbrwmsm3gp1a1bgac";
      type = "gem";
    };
    version = "0.11.2";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g7ps9m3s14cajhxrfgbzahv9i3gy47s4hqrv3mpybpj5cyr0srn";
      type = "gem";
    };
    version = "2.4.0";
  };
  mail = {
    dependencies = ["mini_mime"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00wwz6ys0502dpk8xprwcqfwyf3hmnx6lgxaiq6vj43mkx43sapc";
      type = "gem";
    };
    version = "2.7.1";
  };
  makara = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01n90s1jcc05dc9a70k3c3aa4gc9j49k9iv56n2k4jm949dacms6";
      type = "gem";
    };
    version = "0.4.1";
  };
  marcel = {
    dependencies = ["mimemagic"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nxbjmcyg8vlw6zwagf17l9y2mwkagmmkg95xybpn4bmf3rfnksx";
      type = "gem";
    };
    version = "0.3.3";
  };
  mario-redis-lock = {
    dependencies = ["redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v9wdjcjqzpns2migxp4a5b4w82mipi0fwihbqz3q2qj2qm7wc17";
      type = "gem";
    };
    version = "1.2.1";
  };
  memory_profiler = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04ivhv1bilwqm33jv28gar2vwzsichb5nipaq395d3axabv8qmfy";
      type = "gem";
    };
    version = "0.9.14";
  };
  method_source = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pviwzvdqd90gn6y7illcdd9adapw8fczml933p5vl739dkvl3lq";
      type = "gem";
    };
    version = "0.9.2";
  };
  microformats = {
    dependencies = ["json" "nokogiri"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dc9b18lcs9isdw0c5c2hbvlabxrw8aj6m8kv6zz4qrmvyy3xa2i";
      type = "gem";
    };
    version = "4.2.0";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj12l9qk62anvk9bjvandpa6vy4xslil15wl6wlivyf51z773vh";
      type = "gem";
    };
    version = "3.3.1";
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18x61fc36951vw7f74gq8cyybdpxvyg5d0azvqhrs82ddw3v16xh";
      type = "gem";
    };
    version = "3.2019.1009";
  };
  mimemagic = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04cp5sfbh1qx82yqxn0q75c7hlcx8y1dr5g3kyzwm4mx6wi2gifw";
      type = "gem";
    };
    version = "0.3.3";
  };
  mini_mime = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1axm0rxyx3ss93wbmfkm78a6x03l8y4qy60rhkkiq0aza0vwq3ha";
      type = "gem";
    };
    version = "1.0.2";
  };
  mini_portile2 = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zplpfw3knqifj9bpf604rb3wc1vhq6363pd6lvhayng8wql5vy";
      type = "gem";
    };
    version = "2.4.0";
  };
  minitest = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g73x65hmjph8dg1h3rkzfg7ys3ffxm35hj35grw75fixmq53qyz";
      type = "gem";
    };
    version = "5.14.0";
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
      sha256 = "0xy54mjf7xg41l8qrg1bqri75agdqmxap9z466fjismc1rn2jwfr";
      type = "gem";
    };
    version = "1.14.1";
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
  necromancer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w2y31947axs62bsf0xrpgalsw4ip1m44vpw7p8f4s9zvnayj2vd";
      type = "gem";
    };
    version = "0.5.1";
  };
  net-ldap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vzfhivjfr9q65hkln7xig3qcba6fw9y4kb4384fpm7d7ww0b7xg";
      type = "gem";
    };
    version = "0.16.2";
  };
  net-scp = {
    dependencies = ["net-ssh"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nkf3my587f0izqw0dl3zl24c3lnrw9y5xrq9vb0lhgymmgcav9g";
      type = "gem";
    };
    version = "2.0.0";
  };
  net-ssh = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "101wd2px9lady54aqmkibvy4j62zk32w0rjz4vnigyg974fsga40";
      type = "gem";
    };
    version = "5.2.0";
  };
  nilsimsa = {
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "fd184883048b922b176939f851338d0a4971a532";
      sha256 = "0fds01pr220kg6g3g0rphrkg1fc6py1pnf546pnsb76wd9c0c5il";
      type = "git";
      url = "https://github.com/witgo/nilsimsa";
    };
    version = "1.1.2";
  };
  nio4r = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gnmvbryr521r135yz5bv8354m7xn6miiapfgpg1bnwsvxz8xj6c";
      type = "gem";
    };
    version = "2.5.2";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yi8j8hwrlc3rg5v3w52gxndmwifyk7m732q9yfbal0qajqbh1h8";
      type = "gem";
    };
    version = "1.10.8";
  };
  nokogumbo = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gp12a6mnvgx3qmcavff640k2ciy56rwasrqgca5xjmbcc5q5j9f";
      type = "gem";
    };
    version = "2.0.1";
  };
  nsa = {
    dependencies = ["activesupport" "concurrent-ruby" "sidekiq" "statsd-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i1bhmvs49yv70pgl41lx1lr8x6whg52szb8ic1jb6wmmxr2ylcz";
      type = "gem";
    };
    version = "0.2.7";
  };
  oj = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xc14id5x9bq82z3vs4w5l996amsfwxbx04lmbfynwq6107xz5iy";
      type = "gem";
    };
    version = "3.10.1";
  };
  omniauth = {
    dependencies = ["hashie" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p16h1rp8by05k8gfw17xjhgwp60dk8qmj1xalv1n23kmxfsxb1x";
      type = "gem";
    };
    version = "1.9.0";
  };
  omniauth-cas = {
    dependencies = ["addressable" "nokogiri" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nnk7cr45aj7hj19zpky58yysvjg8mn5f45sj9knpn5f9kgld7p4";
      type = "gem";
    };
    version = "1.1.1";
  };
  omniauth-saml = {
    dependencies = ["omniauth" "ruby-saml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pg3pw4yjd9w1rn3lkycllrvd767pydbhldgdcqbbcck01asfcfz";
      type = "gem";
    };
    version = "1.10.1";
  };
  orm_adapter = {
    groups = ["default" "pam_authentication"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fg9jpjlzf5y49qs9mlpdrgs5rpcyihq1s4k79nv9js0spjhnpda";
      type = "gem";
    };
    version = "0.5.0";
  };
  ox = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qs0si2s8wdgmj3izkg750py7ncn2103bsslh7v7jhqm5y616332";
      type = "gem";
    };
    version = "2.12.1";
  };
  paperclip = {
    dependencies = ["activemodel" "activesupport" "mime-types" "mimemagic" "terrapin"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04mlw7aqj20ry0fy92gxnxg99hy5xczff7rhywfzz4mqlhc2wgg7";
      type = "gem";
    };
    version = "6.0.0";
  };
  paperclip-av-transcoder = {
    dependencies = ["av" "paperclip"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gcnp3fpdb5lqilcij4yqga6397nb7zyyf9lzxnqpbp7cvc18lhf";
      type = "gem";
    };
    version = "0.6.4";
  };
  parallel = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12jijkap4akzdv11lm08dglsc8jmc87xcgq6947i1s3qb69f4zn2";
      type = "gem";
    };
    version = "1.19.1";
  };
  parallel_tests = {
    dependencies = ["parallel"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01xa8hasnazm1glxl731za07rdqqmcnng28l73wdriml15dddrd1";
      type = "gem";
    };
    version = "2.30.1";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "145lv6rbbnbddbk79l10kadycjq05vyrzq5d733zswmypshpq6ni";
      type = "gem";
    };
    version = "2.7.0.2";
  };
  parslet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12nrzfwjphjlakb9pmpj70hgjwgzvnr8i1zfzddifgyd44vspl88";
      type = "gem";
    };
    version = "1.8.2";
  };
  pastel = {
    dependencies = ["equatable" "tty-color"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m43wk7gswwkl6lfxwlliqc9v1qp8arfygihyz91jc9icf270xzm";
      type = "gem";
    };
    version = "0.7.3";
  };
  pg = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r01bqqhnk272dsyhg3cqx6j0aiwbcdnrwp7vxzc969mb5dgnnrl";
      type = "gem";
    };
    version = "1.2.2";
  };
  pghero = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1krdkdd81y6q7k6dgjws3z1g1fq5dnzj06qj6mx1f28jiachj6y5";
      type = "gem";
    };
    version = "2.4.1";
  };
  pkg-config = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wjfdf7yzi8wgbfb53xlyp8mnak2ssg2iqax3kv3zz2dadc7ma6w";
      type = "gem";
    };
    version = "1.4.1";
  };
  posix-spawn = {
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "58465d2e213991f8afb13b984854a49fcdcc980c";
      sha256 = "158m86k54i5cxzasrzp6q0cpvf6d4v91pjcd6kb0cvslfki1drn2";
      type = "git";
      url = "https://github.com/rtomayko/posix-spawn";
    };
    version = "0.3.13";
  };
  premailer = {
    dependencies = ["addressable" "css_parser" "htmlentities"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xrhmialxn5vlp1nmf40a4db9gji4h2wbzd7f43sz64z8lvrjj6h";
      type = "gem";
    };
    version = "1.11.1";
  };
  premailer-rails = {
    dependencies = ["actionmailer" "premailer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bqi7d4f15vy3f1g0xb3bxmncfbzv9dd3ilhqj0plvw64xqbkp3w";
      type = "gem";
    };
    version = "1.10.3";
  };
  private_address_check = {
    groups = ["production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05phz0vscfh9chv90yc9091pifw3cpwkh76flnhrmvja1q3na4cy";
      type = "gem";
    };
    version = "0.5.0";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00rm71x0r1jdycwbs83lf9l6p494m99asakbvqxh8rz7zwnlzg69";
      type = "gem";
    };
    version = "0.12.2";
  };
  pry-byebug = {
    dependencies = ["byebug" "pry"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07cv2hddswb334777pjgc9avxn0x9qhrdr191g7windvnjk3scvg";
      type = "gem";
    };
    version = "3.8.0";
  };
  pry-rails = {
    dependencies = ["pry"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cf4ii53w2hdh7fn8vhqpzkymmchjbwij4l3m7s6fsxvb9bn51j6";
      type = "gem";
    };
    version = "0.3.9";
  };
  public_suffix = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c6kq6s13idl2036b5lch8r7390f8w82cal8hcp4ml76fm2vdac7";
      type = "gem";
    };
    version = "4.0.3";
  };
  puma = {
    dependencies = ["nio4r"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v6zai6sinw5r1lchm278mm3dr8x5vi8pwmybwv9lz1kz02fk2g3";
      type = "gem";
    };
    version = "4.3.1";
  };
  pundit = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18kwm5rkazb89yf792y3fxqihcxw2vdy7k1w542s4hg82ibfpyx3";
      type = "gem";
    };
    version = "2.1.0";
  };
  raabro = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xzdmbn48753f6k0ckirp8ja5p0xn1a92wbwxfyggyhj0hza9ylq";
      type = "gem";
    };
    version = "1.1.6";
  };
  rack = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10mp9s48ssnw004aksq90gvhdvwczh8j6q82q2kqiqq92jd1zxbp";
      type = "gem";
    };
    version = "2.2.2";
  };
  rack-attack = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0543lvxmysqgwsmzwf7amwgfwb7q6n7ddqdlx2smz1iz38n50d6a";
      type = "gem";
    };
    version = "6.2.2";
  };
  rack-cors = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvs0mq8jrsz86jva91mgql16daprpa3qaipzzfvngnnqr5680j7";
      type = "gem";
    };
    version = "1.1.1";
  };
  rack-protection = {
    dependencies = ["rack"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xcvf6lxwdfls6mk1pc6kyw37gr9jyyal83vc6cnlscyp7zafh8j";
      type = "gem";
    };
    version = "2.0.7";
  };
  rack-proxy = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v40xd3xhzhbdqfynd03gn88j1pga2zhrv58xs9fl4hzrlbp096s";
      type = "gem";
    };
    version = "0.6.5";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rh8h376mx71ci5yklnpqqn118z3bl67nnv5k801qaqn1zs62h8m";
      type = "gem";
    };
    version = "1.1.0";
  };
  rails = {
    dependencies = ["actioncable" "actionmailer" "actionpack" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties" "sprockets-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1198azwbhlhq2n9xmpb19709d6smkanimip9cagvnlihagw80b20";
      type = "gem";
    };
    version = "5.2.4.1";
  };
  rails-controller-testing = {
    dependencies = ["actionpack" "actionview" "activesupport"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m1rklj6pvzi4fydxcmcv4q0xd7913hhhw1hw530nfz1wkl7vjlf";
      type = "gem";
    };
    version = "1.0.4";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lfq2a7kp2x64dzzi5p4cjcbiv62vxh9lyqk2f0rqq3fkzrw8h5i";
      type = "gem";
    };
    version = "2.0.3";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1icpqmxbppl4ynzmn6dx7wdil5hhq6fz707m9ya6d86c7ys8sd4f";
      type = "gem";
    };
    version = "1.3.0";
  };
  rails-i18n = {
    dependencies = ["i18n" "railties"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02kdlm7jgwvwnnc1amy8md2vl0f2jkfr6rr36vybclr9qm4fb80f";
      type = "gem";
    };
    version = "5.1.3";
  };
  rails-settings-cached = {
    dependencies = ["rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wyhyls0aqb1iw7mnaldg39w3mnbi3anmpbvb52rjwkpj2mchhnc";
      type = "gem";
    };
    version = "0.6.6";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "method_source" "rake" "thor"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iqsqyyjscwnj2d3i0zl2k9apgsm7bb92l5h4wv1zbpdbb30wsqb";
      type = "gem";
    };
    version = "5.2.4.1";
  };
  rainbow = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb2fpjspydr6x0s8pn1pqkzmxszvkfapv0p4627mywl7ky4zkhk";
      type = "gem";
    };
    version = "3.0.0";
  };
  rake = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w6qza25bq1s825faaglkx1k6d59aiyjjk3yw3ip5sb463mhhai9";
      type = "gem";
    };
    version = "13.0.1";
  };
  rdf = {
    dependencies = ["hamster" "link_header"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nlzkz6vi2rqj2cr8rjp9if8bmsv89h8gmlrzpi09sxjl73h4dg1";
      type = "gem";
    };
    version = "3.1.1";
  };
  rdf-normalize = {
    dependencies = ["rdf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kfhh5n57im80i1ak00qz9f5hx8k10ldn0r5l1gw1qaa1lydmydg";
      type = "gem";
    };
    version = "0.4.0";
  };
  redis = {
    groups = ["default" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08v2y91q1pmv12g9zsvwj66w3s8j9d82yrmxgyv4y4gz380j3wyh";
      type = "gem";
    };
    version = "4.1.3";
  };
  redis-actionpack = {
    dependencies = ["actionpack" "redis-rack" "redis-store"];
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15k41gz7nygd4yydk2yd25gghya1j7q6zifk4mdrra6bwnwjbm63";
      type = "gem";
    };
    version = "5.0.2";
  };
  redis-activesupport = {
    dependencies = ["activesupport" "redis-store"];
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rq5dhrzc1l8c7f5gx9r7mvnsk5206dfwih3yv5si5rf42nx2ay5";
      type = "gem";
    };
    version = "5.0.4";
  };
  redis-namespace = {
    dependencies = ["redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wb4x8bg2d0plv3izpmi1sd7nd1ix8nxw7b43hd9bac08f4w62mx";
      type = "gem";
    };
    version = "1.7.0";
  };
  redis-rack = {
    dependencies = ["rack" "redis-store"];
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0px0wv8zripc6lrn3k0k61j6nlxda145q8sz50yvnig17wlk36gb";
      type = "gem";
    };
    version = "2.0.4";
  };
  redis-rails = {
    dependencies = ["redis-actionpack" "redis-activesupport" "redis-store"];
    groups = ["production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hjvkyaw5hgz7v6fgwdk8pb966z44h1gv8jarmb0gwhkqmjnsh40";
      type = "gem";
    };
    version = "5.0.2";
  };
  redis-store = {
    dependencies = ["redis"];
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cpg4fmqcyl8mm77l852xsidp8384a7s1mgbpki999swvq97svi4";
      type = "gem";
    };
    version = "1.5.0";
  };
  regexp_parser = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l44ml30jvqpdi3707x1n1dinq7fx9887pv3q2ywyfmi4kja7yf2";
      type = "gem";
    };
    version = "1.6.0";
  };
  request_store = {
    dependencies = ["rack"];
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cx74kispmnw3ljwb239j65a2j14n8jlsygy372hrsa8mxc71hxi";
      type = "gem";
    };
    version = "1.5.0";
  };
  responders = {
    dependencies = ["actionpack" "railties"];
    groups = ["default" "pam_authentication"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p7pqcfq33q1z4xlp4qm94w4h3fzc1yvr3cny16d00i8b20v4rx2";
      type = "gem";
    };
    version = "3.0.0";
  };
  rotp = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w8d6svhq3y9y952r8cqirxvdx12zlkb7zxjb44bcbidb2sisy4d";
      type = "gem";
    };
    version = "2.1.2";
  };
  rpam2 = {
    groups = ["default" "pam_authentication"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zvli3s4z1hf2l7gyfickm5i3afjrnycc3ihbiax6ji6arpbyf33";
      type = "gem";
    };
    version = "4.0.2";
  };
  rqrcode = {
    dependencies = ["chunky_png" "rqrcode_core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06lw8b6wfshxd61xw98xyp1a0zsz6av4nls2c9fwb7q59wb05sci";
      type = "gem";
    };
    version = "1.1.2";
  };
  rqrcode_core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jq5hbk7lhc6iwilppbra41jraavgakv763nw2kngvhdpiif9qvp";
      type = "gem";
    };
    version = "0.1.1";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gppalb2ynj0xk7vp8kk5pwzihmiqc8l4prpy4n9spclq7iqkspq";
      type = "gem";
    };
    version = "3.9.0";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gjqfb39da6gywdcp4h77738r7khbrn2v4y45589z25bj4z9paf0";
      type = "gem";
    };
    version = "3.9.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q9f8nrxhs4k2vl3bnm3pi5s44v9pnvjwirjnwji3sxzf68c2xjf";
      type = "gem";
    };
    version = "3.9.0";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iyj1gkid35pvfam28i1qdlv8naf717ql619wrphf4bciksm77h9";
      type = "gem";
    };
    version = "3.9.0";
  };
  rspec-sidekiq = {
    dependencies = ["rspec-core" "sidekiq"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y7pbqrbc8rjszc45vg4vz9qbn8aymgcc4ribrhvm76wrfz3ksfq";
      type = "gem";
    };
    version = "3.0.3";
  };
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18080h06kqayyr6dpw4c62l0wav09ihkd6skinsln13kmq0cv0mx";
      type = "gem";
    };
    version = "3.9.0";
  };
  rubocop = {
    dependencies = ["jaro_winkler" "parallel" "parser" "rainbow" "ruby-progressbar" "unicode-display_width"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14m72wgsnvz179k110bnyp5j8vw0vs6x3r7l12fx2yw9088k6nrj";
      type = "gem";
    };
    version = "0.79.0";
  };
  rubocop-rails = {
    dependencies = ["rack" "rubocop"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zmhnyw269xqmcvwdbyv8vn3nhbj1pkxlpsm85v0kpw1slgbn263";
      type = "gem";
    };
    version = "2.4.2";
  };
  ruby-progressbar = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k77i0d4wsn23ggdd2msrcwfy0i376cglfqypkk2q77r2l3408zf";
      type = "gem";
    };
    version = "1.10.1";
  };
  ruby-saml = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12f3mmyds4y8f7535p79xzx0wnp7rj02h1fp2x3j2hy5vrkmz2k4";
      type = "gem";
    };
    version = "1.9.0";
  };
  rufus-scheduler = {
    dependencies = ["fugit"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "074w41a88343cbv8ydkpl3firhvh3kbh8ppldhdmpvv2g569m32i";
      type = "gem";
    };
    version = "3.5.2";
  };
  safe_yaml = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j7qv63p0vqcd838i2iy2f76c3dgwzkiz1d1xkg7n0pbnxj2vb56";
      type = "gem";
    };
    version = "1.0.5";
  };
  sanitize = {
    dependencies = ["crass" "nokogiri" "nokogumbo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h9y9fn1dm27a3rgva4rkakp8nhxxz80dh1qncipb07mq041m3qp";
      type = "gem";
    };
    version = "5.1.0";
  };
  sidekiq = {
    dependencies = ["connection_pool" "rack" "rack-protection" "redis"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "131zv8i341bkacxx7n1id2cmblkbs379farnibqg8c7bycd1iajq";
      type = "gem";
    };
    version = "5.2.7";
  };
  sidekiq-bulk = {
    dependencies = ["sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08nyxzmgf742irafy3l4fj09d4s5pyvsh0dzlh8y4hl51rgkh4xv";
      type = "gem";
    };
    version = "0.2.0";
  };
  sidekiq-scheduler = {
    dependencies = ["redis" "rufus-scheduler" "sidekiq" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n38p1ig8rx4ndqxcsc2gyzbaaax6r16b1xkn9mgcwwfx8qd5dbw";
      type = "gem";
    };
    version = "3.0.0";
  };
  sidekiq-unique-jobs = {
    dependencies = ["concurrent-ruby" "sidekiq" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1smr90w434mlw8rjlfi73yfp972kwswi3i265vkf3cplhsvwbww9";
      type = "gem";
    };
    version = "6.0.20";
  };
  simple-navigation = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pkj5z48k90v9v53gckl1b0jsix08kpl6qkgsd4pkc7cva8dbqid";
      type = "gem";
    };
    version = "4.1.0";
  };
  simple_form = {
    dependencies = ["actionpack" "activemodel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i5svj1y0chpipz6q2hhpfgfhjq3l5wijva69ap5h0l3879x3v0q";
      type = "gem";
    };
    version = "5.0.1";
  };
  simplecov = {
    dependencies = ["docile" "simplecov-html"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n55gkbirl7zvjk4bli5zm6rgpljlhrhn0ay42rvacz170yihin2";
      type = "gem";
    };
    version = "0.18.2";
  };
  simplecov-html = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19rby1knn827x5x682g9n6p2i2z6fq5zpx94nrsd3rkfjj3bgh6s";
      type = "gem";
    };
    version = "0.12.0";
  };
  sprockets = {
    dependencies = ["concurrent-ruby" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "182jw5a0fbqah5w9jancvfmjbk88h8bxdbwnl4d3q809rpxdg8ay";
      type = "gem";
    };
    version = "3.7.2";
  };
  sprockets-rails = {
    dependencies = ["actionpack" "activesupport" "sprockets"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ab42pm8p5zxpv3sfraq45b9lj39cz9mrpdirm30vywzrwwkm5p1";
      type = "gem";
    };
    version = "3.2.1";
  };
  sshkit = {
    dependencies = ["net-scp" "net-ssh"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pcp4nsm9fd2ypw0j159zwj6k31kbni5anyi82ikn4rmrb18dpgn";
      type = "gem";
    };
    version = "1.20.0";
  };
  stackprof = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g2zzasjdr1qnwmpmn28ddv2z9jsnv4w5raiz26y9h1jh03sagqd";
      type = "gem";
    };
    version = "0.2.15";
  };
  statsd-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0djig5dnqjgww6wrw3f1mvnnjllznahlchvk4lvs4wx9qjsqpysr";
      type = "gem";
    };
    version = "1.4.0";
  };
  stoplight = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ari05lrs0ynjfaj3zqhxjylcignpyzfg7bk07j8bfly7i54rv3q";
      type = "gem";
    };
    version = "2.2.0";
  };
  streamio-ffmpeg = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nnxizc0371vwh0k6gqjj1b7fjszydpqfz549n6qn2q1pza3894z";
      type = "gem";
    };
    version = "3.0.2";
  };
  strong_migrations = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kzay6rayy875dbc85i7v6y3yzswc27d7ygjpkybds27syrznqqb";
      type = "gem";
    };
    version = "0.5.1";
  };
  temple = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "060zzj7c2kicdfk6cpnn40n9yjnhfrr13d0rsbdhdij68chp2861";
      type = "gem";
    };
    version = "0.8.2";
  };
  terminal-table = {
    dependencies = ["unicode-display_width"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1512cngw35hsmhvw4c05rscihc59mnj09m249sm9p3pik831ydqk";
      type = "gem";
    };
    version = "1.8.0";
  };
  terrapin = {
    dependencies = ["climate_control"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p18f05r0c5s70571gqig3z2ym74wx79s6rd45sprp207bqskzn9";
      type = "gem";
    };
    version = "0.6.0";
  };
  thor = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    version = "0.20.3";
  };
  thread_safe = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  thwait = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12v3w3l9ky755mgmyyvh3lfximxxkd5y3y8jj0hbgbw7ndnjm1bs";
      type = "gem";
    };
    version = "0.1.0";
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rn8z8hda4h41a64l0zhkiwz2vxw9b1nb70gl37h1dg2k874yrlv";
      type = "gem";
    };
    version = "2.0.10";
  };
  tty-color = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zpp6zixkkchrc2lqnabrsy24pxikz2px87ggz5ph6355fs803da";
      type = "gem";
    };
    version = "0.5.0";
  };
  tty-command = {
    dependencies = ["pastel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cqqy9pn1b9j1mbkxwxwk7hlk2jh0lzsi9qr19p4hc0r1axcndjk";
      type = "gem";
    };
    version = "0.9.0";
  };
  tty-cursor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0prcxdy6qhqba4cv7hsy503b3bjciqk3j3hhzvcbij1kj2gh31c9";
      type = "gem";
    };
    version = "0.7.0";
  };
  tty-prompt = {
    dependencies = ["necromancer" "pastel" "tty-reader"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19kbxny8cfsy1r02awih1gf76mi3a7zqg3ymxpmf9720khlmziax";
      type = "gem";
    };
    version = "0.20.0";
  };
  tty-reader = {
    dependencies = ["tty-cursor" "tty-screen" "wisper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1977ajs9sxwhd88qqmf6l1hw63dqxlvg9mx626rymsc5ap2xa1r4";
      type = "gem";
    };
    version = "0.7.0";
  };
  tty-screen = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1143g05fs28ssgimaph6sdnsndd1wrpax9kjypvd2ripa1adm4kx";
      type = "gem";
    };
    version = "0.7.0";
  };
  twitter-text = {
    dependencies = ["unf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1732h7hy1k152w8wfvjsx7b79alk45i5imwd37ia4qcx8hfm3gvg";
      type = "gem";
    };
    version = "1.14.7";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04f18jdv6z3zn3va50rqq35nj3izjpb72fnf21ixm7vanq6nc4fp";
      type = "gem";
    };
    version = "1.2.6";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17fbf05qhcxp8anmp7k5wnafw3ypy607h5ybnqg92dqgh4b1c3yi";
      type = "gem";
    };
    version = "1.2019.3";
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
  unicode-display_width = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pppclzq4qb26g321553nm9xqca3zgllvpwb2kqxsdadwj51s09x";
      type = "gem";
    };
    version = "1.6.1";
  };
  uniform_notifier = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vm4aix8jmv42s1x58m3lj3xwkbxyn9qn6lzhhig0d1j8fv6j30c";
      type = "gem";
    };
    version = "1.13.0";
  };
  warden = {
    dependencies = ["rack"];
    groups = ["default" "pam_authentication"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fr9n9i9r82xb6i61fdw4xgc7zjv7fsdrr4k0njchy87iw9fl454";
      type = "gem";
    };
    version = "1.2.8";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "064zlgm2gmw97cdjmal8231xsbh4q15fsix9vx846wvksscdfyz4";
      type = "gem";
    };
    version = "3.8.0";
  };
  webpacker = {
    dependencies = ["activesupport" "rack-proxy" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h59yd6bwlpdny40zymma8bd0giyh6r20s5vim605dw23374pcaj";
      type = "gem";
    };
    version = "4.2.2";
  };
  webpush = {
    dependencies = ["hkdf" "jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gi7aircw2bizk08pihr9srncjy9x9iy0ymp1qgchni639k1k05s";
      type = "gem";
    };
    version = "0.3.8";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bxamwqldmy98hxs5pqby3andws14hl36ch78g0s81gaz9b91nj2";
      type = "gem";
    };
    version = "0.7.1";
  };
  websocket-extensions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00i624ng1nvkz1yckj3f8yxxp6hi7xaqf40qh9q3hj2n1l9i8g6m";
      type = "gem";
    };
    version = "0.1.4";
  };
  wisper = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rpsi0ziy78cj82sbyyywby4d0aw0a5q84v65qd28vqn79fbq5yf";
      type = "gem";
    };
    version = "2.0.1";
  };
  xpath = {
    dependencies = ["nokogiri"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";
      type = "gem";
    };
    version = "3.2.0";
  };
}