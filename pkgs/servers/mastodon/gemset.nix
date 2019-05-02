{
  actioncable = {
    dependencies = ["actionpack" "nio4r" "websocket-driver"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04wd9rf8sglrqc8jz49apqcxbi51gdj7l1apf5qr4i86iddk6pkm";
      type = "gem";
    };
    version = "5.2.3";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15laym06zcm2021qdhlyr6y9jn1marw436i89hcxqg14a8zvyvwa";
      type = "gem";
    };
    version = "5.2.3";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s2iay17i2k0xx36cmnpbrmr5w6x70jk7fq1d8w70xcdw5chm0w1";
      type = "gem";
    };
    version = "5.2.3";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v49rgf8305grqf6gq7qa47qhamr369igyy0giycz60x86afyr4h";
      type = "gem";
    };
    version = "5.2.3";
  };
  active_model_serializers = {
    dependencies = ["actionpack" "activemodel" "case_transform" "jsonapi-renderer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00fldcifg5zyx866njpjhwlxjxvb32pakf5q3pwnw3ms905s70kd";
      type = "gem";
    };
    version = "0.10.9";
  };
  active_record_query_trace = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16fwv2h3h3hh8v6wgrpv13yxgg8mswsld0d8z6q1y5z9vd8vncc3";
      type = "gem";
    };
    version = "1.6.2";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17vizibxbsli5yppgrvmw13wj7a9xy19s5nqxf1k23bbk2s5b87s";
      type = "gem";
    };
    version = "5.2.3";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mghh9di8011ara9h1r5a216yzk1vjm9r3p0gdvdi8j1zmkl6k6h";
      type = "gem";
    };
    version = "5.2.3";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d6036f592803iyvp6bw98p3sg638mia5dbw19lvachx6jgzfvpw";
      type = "gem";
    };
    version = "5.2.3";
  };
  activestorage = {
    dependencies = ["actionpack" "activerecord" "marcel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04is6ipjqw1f337i8pm8w5bd99rpygqfd0fzzxkr7jd308ggmsjk";
      type = "gem";
    };
    version = "5.2.3";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "110vp4frgkw3mpzlmshg2f2ig09cknls2w68ym1r1s39d01v0mi8";
      type = "gem";
    };
    version = "5.2.3";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bcm2hchn897xjhqj9zzsxf3n9xhddymj4lsclz508f4vw3av46l";
      type = "gem";
    };
    version = "2.6.0";
  };
  airbrussh = {
    dependencies = ["sshkit"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yp1sl5n94ksxpwmaajflbdls45s81hw4spgz01h19xs2zrvv8wl";
      type = "gem";
    };
    version = "1.3.0";
  };
  annotate = {
    dependencies = ["activerecord" "rake"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l69l2kn06nkrnyq6gb1x322x5raxs8ms60shpf0v5dsi8lfig16";
      type = "gem";
    };
    version = "2.7.4";
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
      sha256 = "1jlxa2l2xijg360nyszib4awd6vanzma2cdhm9yifrq43fgmaw87";
      type = "gem";
    };
    version = "1.147.0";
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
  benchmark-ips = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w59c4qnwkjqwn7zyp9hshslbshna77vknmz43h0va5lxisd6ai2";
      type = "gem";
    };
    version = "2.7.2";
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
  bootsnap = {
    dependencies = ["msgpack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0chpkqmlmn5y03k5c469s5n3ja7ilhabmdnasbnfz1vzncalc0rh";
      type = "gem";
    };
    version = "1.4.3";
  };
  brakeman = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c11i01yw87fssmwbybaqf5rdxsjp44hvxdw54c3iqb8fvj76b68";
      type = "gem";
    };
    version = "4.5.0";
  };
  browser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sdx0ny34i6vqxdsc7sy9g0nafdbrw8kvvb5xh9m18x1bzpqk92f";
      type = "gem";
    };
    version = "2.5.3";
  };
  builder = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  bullet = {
    dependencies = ["activesupport" "uniform_notifier"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fhsq5r9xc3cb32zr21hnsb2zmwbkck7xjvds9ny4inhykrjg47m";
      type = "gem";
    };
    version = "5.9.0";
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
      sha256 = "1vk10jinfp345s2cb4ba7d0jcxj3phbgvab0by4a3ln2d376mkj4";
      type = "gem";
    };
    version = "11.0.0";
  };
  capistrano = {
    dependencies = ["airbrussh" "i18n" "rake" "sshkit"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1hj8hpmplxl41y6phsvkw2k8x3yxmkngs8yl8gkr7c1ma870p4";
      type = "gem";
    };
    version = "3.11.0";
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
      sha256 = "182dmsliny87b74m9mxi7farmp03ycqh30yf58b2kcx7m2js2s92";
      type = "gem";
    };
    version = "2.1.4";
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
      sha256 = "1j96fdhh65glgkv91s5s3gly660syll0mp2yqc0p4m11nmaj1lfz";
      type = "gem";
    };
    version = "3.16.1";
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
      sha256 = "1nf1l31n10yaark2rrg5qzyzcx9w80681449s3j09qmnipsl8rl5";
      type = "gem";
    };
    version = "0.7.6";
  };
  chewy = {
    dependencies = ["activesupport" "elasticsearch" "elasticsearch-dsl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m1n98fww2is9v4h73qnxjzs0l9ixx2szby5rip26g9l7mjwmm7v";
      type = "gem";
    };
    version = "5.0.0";
  };
  chunky_png = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05g2xli9wbjylkmblln3bhvjalziwb92q452q8ibjagmb853424w";
      type = "gem";
    };
    version = "1.3.10";
  };
  cld3 = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a3q025jqfwf8id1g40cv7s5pn7mdwzjpgqyzhdxdci1ps5ycgmn";
      type = "gem";
    };
    version = "3.2.3";
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
      sha256 = "0bpxzy6gjw9ggjynlxschbfsgmx8lv3zw1azkjvnb8b9i895dqfi";
      type = "gem";
    };
    version = "1.0.4";
  };
  css_parser = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gwvf8mc8gnz4aizfijplv3594998h2j44ydakpzsdmkivs07v61";
      type = "gem";
    };
    version = "1.6.0";
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
  derailed_benchmarks = {
    dependencies = ["benchmark-ips" "get_process_mem" "heapy" "memory_profiler" "rack" "rake" "thor"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c9djg1r2w461h97zmmdsdgnsrxqm4qfyp7gry9qxbav9skrplb8";
      type = "gem";
    };
    version = "1.3.5";
  };
  devise = {
    dependencies = ["bcrypt" "orm_adapter" "railties" "responders" "warden"];
    groups = ["default" "pam_authentication"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04b2p61mqfb6ln8s2lhmvnkd45wjjinykbn9svmhs54kacrrjkcf";
      type = "gem";
    };
    version = "4.6.2";
  };
  devise-two-factor = {
    dependencies = ["activesupport" "attr_encrypted" "devise" "railties" "rotp"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b61s5y1ch205lgf3xv8hcvyi27ddd0d4qbbcpnnakhn2bx16lmc";
      type = "gem";
    };
    version = "3.0.3";
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
  docile = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yyh4lr03q2vafzsfqy1xax7vr8zn7mbddz3ax3vnlm5fg0px6pn";
      type = "gem";
    };
    version = "1.3.0";
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
  doorkeeper = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0488m6nwp31mxrhayj60gsb7jgyw1lzh73r2kldx00a9bw3634d4";
      type = "gem";
    };
    version = "5.0.2";
  };
  dotenv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13cis6bf06hmz744xrsl163p6gb78xcm8g8q4pcabsy5ywyv6kag";
      type = "gem";
    };
    version = "2.7.2";
  };
  dotenv-rails = {
    dependencies = ["dotenv" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ih7nx7byiaws3w4vsb82fcfkgw4z14y8rclhnxmpghj0kn4871s";
      type = "gem";
    };
    version = "2.7.2";
  };
  elasticsearch = {
    dependencies = ["elasticsearch-api" "elasticsearch-transport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a08ynvxz5clfm2ndqpgjrv4aiga9m2y1ab34s3qkihdfdzdzhj8";
      type = "gem";
    };
    version = "6.0.2";
  };
  elasticsearch-api = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vkahknqn85vvwr1gzh8jf3pvdial0c0d524icg8x06vibqgzd5h";
      type = "gem";
    };
    version = "6.0.2";
  };
  elasticsearch-dsl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mwn6hvkki560p7sfc841q15zzgldsk9lzm2mlvc2bra7x1yk2q8";
      type = "gem";
    };
    version = "0.1.5";
  };
  elasticsearch-transport = {
    dependencies = ["faraday" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gpwbw70qisx681j1bw8xq6shg5kdxmcdzg6425af0b5881jg7iy";
      type = "gem";
    };
    version = "6.0.2";
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
      sha256 = "1sjm9zjakyixyvsqziikdrsqfzis6j3fq23crgjkp6fwkfgndj7x";
      type = "gem";
    };
    version = "0.5.0";
  };
  erubi = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kagnf6ziahj0d781s6ryy6fwqwa3ad4xbzzj84p9m4nv4c2jir1";
      type = "gem";
    };
    version = "1.8.0";
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
      sha256 = "15l9w0938c19nxmrp09n75qpmm64k12xj69h47yvxzcxcpbgnkb2";
      type = "gem";
    };
    version = "0.62.0";
  };
  fabrication = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0an28kjand4mjbkmnwd9fmgq3y5vf717zpmiijavar3sxqj52zri";
      type = "gem";
    };
    version = "2.20.1";
  };
  faker = {
    dependencies = ["i18n"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vslyqmk9gjvp1ahyfqmwy1jcyv75rp88hxwpy7cdk2lpdb1jp3l";
      type = "gem";
    };
    version = "1.9.3";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dv1vcxxyw4vy0r2diiml0r8zqk1csrksfxv8nkrw61xlf2daaaa";
      type = "gem";
    };
    version = "0.15.0";
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
      sha256 = "1iy9jm13r2r4yz41xaivhxs8mvqn57fjwihxvazbip002mq6rxfz";
      type = "gem";
    };
    version = "2.1.5";
  };
  ffi = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jpm2dis1j7zvvy3lg7axz9jml316zrn7s0j59vyq3qr127z0m7q";
      type = "gem";
    };
    version = "1.9.25";
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
      sha256 = "1sqkr1nh49rlm86l3qyrgsdqavgqii4pnrjn7855z6dfavh3spxr";
      type = "gem";
    };
    version = "2.3.2";
  };
  get_process_mem = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bvfjdign16r0zwm2rlfrq0sk1licvmlgbnlpnyckniv5r7i080g";
      type = "gem";
    };
    version = "0.2.3";
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
      sha256 = "0n142035jhyqwczi52zjr07c8kygp9b9f158miaby3z5hygzjyzh";
      type = "gem";
    };
    version = "2.1.0";
  };
  hamlit = {
    dependencies = ["temple" "thor" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17qn9w4100v9mkd4i8qbzs1d5ambdsqq0y1j6hhxbcldbqcznbvx";
      type = "gem";
    };
    version = "2.9.3";
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
      sha256 = "0yj5l2rw8i8jc725hbcpc4wks0qlaaimr3dpaqamfjkjkxl0hjp9";
      type = "gem";
    };
    version = "0.3.7";
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
  heapy = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r9f38fpgjgaxskkwvsliijj6vfmgsff9pnranvvvzkdl67hk1hw";
      type = "gem";
    };
    version = "0.1.4";
  };
  highline = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gr6pckj2jayxw1gdgh9193j5jag5zrrqqlrnl4jvcwpyd3sn2zc";
      type = "gem";
    };
    version = "2.0.1";
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
    dependencies = ["addressable" "http-cookie" "http-form_data" "http_parser.rb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jlm5prw437wqpfxcigh88lfap3m7g8mnmj5as7qw6dzqnvrxwmc";
      type = "gem";
    };
    version = "3.3.0";
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
      sha256 = "15lpn604byf7cyxnw949xz4rvpcknqp7a48q73nm630gqxsa76f3";
      type = "gem";
    };
    version = "2.1.1";
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
      sha256 = "05vap23hcwh6qixx5idbgg91nw318nnqxlq2fx4b9h9p8zgd437d";
      type = "gem";
    };
    version = "1.2.2";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hfxnlyr618s25xpafw9mypa82qppjccbh292c4l3bj36az7f6wl";
      type = "gem";
    };
    version = "1.6.0";
  };
  i18n-tasks = {
    dependencies = ["activesupport" "ast" "erubi" "highline" "i18n" "parser" "rails-i18n" "rainbow" "terminal-table"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11h0chj0jpdfxpaglkr98l4qcwwpb8glh3dxar3inq9ccmsrdzaf";
      type = "gem";
    };
    version = "0.9.29";
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
      sha256 = "1zz27z88qznix4r65gd9h56gl177snlfpgv10b0s69vi8qpl909l";
      type = "gem";
    };
    version = "1.5.2";
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
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  json-ld = {
    dependencies = ["multi_json" "rdf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yk4gnxzwlif9d0dy7csdb9ix60h69alk139aaip6304nx2yhdsk";
      type = "gem";
    };
    version = "3.0.2";
  };
  json-ld-preloaded = {
    dependencies = ["json-ld" "multi_json" "rdf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c3yh5ayxvz33znbmzinigc5wivicib7nnykqjf00j2f9qag18pv";
      type = "gem";
    };
    version = "3.0.2";
  };
  jsonapi-renderer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00ysmcv3nrccyimi334ida4axlfgir6cc2ryjxrf4xb97m1bfk5j";
      type = "gem";
    };
    version = "0.2.0";
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
      sha256 = "17qhwrkncrrp1bi2f7fbkm5lpnkdsiwy8jcvgr2wa97ck8y4x2bb";
      type = "gem";
    };
    version = "1.3.4";
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
      sha256 = "00lcn7s3slfn32di4qwlx2yj5f9r2pcnd0naxrvqqwypcg1z2sdd";
      type = "gem";
    };
    version = "0.10.0";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ccsid33xjajd0im2xv941aywi58z7ihwkvaf1w2bv89vn5bhsjg";
      type = "gem";
    };
    version = "2.2.3";
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
      sha256 = "1xki7jrbzylsmk1brjibmhifb0x70skr55pdq4rvxcyrlnrrvyxz";
      type = "gem";
    };
    version = "0.9.13";
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
      sha256 = "12wj9lydba2dz5pqd6ngklwnzhsg63kl3yhi9zm8h9hjg6dsw3nb";
      type = "gem";
    };
    version = "4.1.0";
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
      sha256 = "07wvp0aw2gjm4njibb70as6rh5hi1zzri5vky1q6jx95h8l56idc";
      type = "gem";
    };
    version = "3.2018.0812";
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
      sha256 = "1q4pshq387lzv9m39jv32vwb8wrq3wc4jwgl4jk209r4l33v09d3";
      type = "gem";
    };
    version = "1.0.1";
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
      sha256 = "0icglrhghgwdlnzzp4jf76b0mbc71s80njn5afyfjn4wqji8mqbq";
      type = "gem";
    };
    version = "5.11.3";
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
  necromancer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v9nhdkv6zrp7cn48xv7n2vjhsbslpvs0ha36mfkcd56cp27pavz";
      type = "gem";
    };
    version = "0.4.0";
  };
  net-ldap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "016igqz81a8zcwqzp5bbhryqmb2skmyf57ij3nb5z8sxwhw22jgh";
      type = "gem";
    };
    version = "0.16.1";
  };
  net-scp = {
    dependencies = ["net-ssh"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0jqrcsp4bbi4n4mzyf70cp2ysyp6x07j8k8cqgxnvb4i3a134j";
      type = "gem";
    };
    version = "1.2.1";
  };
  net-ssh = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qfanf71yv8w7yl9l9wqcy68i2x1ghvnf8m581yy4pl0anfdhqw8";
      type = "gem";
    };
    version = "5.0.2";
  };
  nio4r = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a41ca1kpdmrypjp9xbgvckpy8g26zxphkja9vk7j5wl4n8yvlyr";
      type = "gem";
    };
    version = "2.3.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sy96cc8i5y4p67fhf4d9c6sg8ymrrva21zyvzw55l0pa1582wx2";
      type = "gem";
    };
    version = "1.10.2";
  };
  nokogumbo = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qr7r2ysbp8b5q78yr8l5qpaxfqdw1i2yz6nsrbavdki8mqjgj24";
      type = "gem";
    };
    version = "2.0.0";
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
      sha256 = "0qhqv3x1qdm63mmn810dmpjyy4b6zw4lcraa1xswl44ldmbdv8jm";
      type = "gem";
    };
    version = "3.7.11";
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
  ostatus2 = {
    dependencies = ["addressable" "http" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fj27nr38g5y52s755pmg5zifwc6n88bw2zmkc22kg4vrhs64k19";
      type = "gem";
    };
    version = "2.0.3";
  };
  ox = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vkq18fp58504ld9vfakisxdmp68pk5y1bmmm5g7b0q25p8z5pq";
      type = "gem";
    };
    version = "2.10.0";
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
      sha256 = "1x1gzgjrdlkm1aw0hfpyphsxcx90qgs3y4gmp9km3dvf4hc4qm8r";
      type = "gem";
    };
    version = "1.17.0";
  };
  parallel_tests = {
    dependencies = ["parallel"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h9zjw0ybban3vl46ci6dr5zprbr76yliw9qalhr6cnhqnmmvx1h";
      type = "gem";
    };
    version = "2.28.0";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b69lv65xklvgk8im92y7mhr05iyygvr07sal7z5xf0jy4ym7nd2";
      type = "gem";
    };
    version = "2.6.2.0";
  };
  pastel = {
    dependencies = ["equatable" "tty-color"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yf30d9kzpm96gw9kwbv31p0qigwfykn8qdis5950plnzgc1vlp1";
      type = "gem";
    };
    version = "0.7.2";
  };
  pg = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fmnyxcyrvgdbgq7m09whgn9i8rwfybk0w8aii1nc4g5kqw0k2jy";
      type = "gem";
    };
    version = "1.1.4";
  };
  pghero = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nvg9jwynnw3brignq6raka0abrcjmm8mr8yxhvybjpmr6lyyjrd";
      type = "gem";
    };
    version = "2.2.0";
  };
  pkg-config = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s56ym0chq3fycl29vqabcalqdcf7y2f25pmihjwqgbmrmzdyvr1";
      type = "gem";
    };
    version = "1.3.7";
  };
  posix-spawn = {
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = true;
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
      sha256 = "1avh2bkhabicf1zxla8z6ig5192h3vdzli4d2y9wmxfwgh549lmx";
      type = "gem";
    };
    version = "1.10.2";
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
      sha256 = "1aqz4gz8z44k6svpvcsfrqbigcpjd2kwvfm77yq3v8yzkhjrx0zi";
      type = "gem";
    };
    version = "3.7.0";
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
  psych = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09jv2lbpv4p4zfh77a3q0a8xl9ady96iq4rmqrnzsdn69f6wyn58";
      type = "gem";
    };
    version = "3.1.0";
  };
  public_suffix = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08q64b5br692dd3v0a9wq9q5dvycc6kmiqmjbdxkxbfizggsvx6l";
      type = "gem";
    };
    version = "3.0.3";
  };
  puma = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pkrbvak6rlf147qpd4zss031qrwwh53g8s6017037iwg0436kv3";
      type = "gem";
    };
    version = "3.12.1";
  };
  pundit = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rqnll033ya64qvknbmnq076q9mxaibvcd7q70jhkpjda1xi4703";
      type = "gem";
    };
    version = "2.0.1";
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
      sha256 = "0z90vflxbgjy2n84r7mbyax3i2vyvvrxxrf86ljzn5rw65jgnn2i";
      type = "gem";
    };
    version = "2.0.7";
  };
  rack-attack = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11y6kw7hj2z25ba67www6qap7shj2bp6s43h57cn4yrid9kbsibs";
      type = "gem";
    };
    version = "5.4.2";
  };
  rack-cors = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dmg0f7zdmcn321fr05g568slzf8cmqgccavyhvx7c37ir040k4l";
      type = "gem";
    };
    version = "1.0.3";
  };
  rack-protection = {
    dependencies = ["rack"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15167q25rmxipqwi6hjqj3i1byi9iwl3xq9b7mdar7qiz39pmjsk";
      type = "gem";
    };
    version = "2.0.5";
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
      sha256 = "1p7cszi3n9ksxchxnccmz61pd1i3rjg4813dsdinsm8xm5k1pdgr";
      type = "gem";
    };
    version = "5.2.3";
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
      sha256 = "1gv7vr5d9g2xmgpjfq4nxsqr70r9pr042r9ycqqnfvw5cz9c7jwr";
      type = "gem";
    };
    version = "1.0.4";
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
      sha256 = "1gn9fwb5wm08fbj7zpilqgblfl315l5b7pg4jsvxlizvrzg8h8q4";
      type = "gem";
    };
    version = "5.2.3";
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
      sha256 = "1sy5a7nh6xjdc9yhcw31jji7ssrf9v5806hn95gbrzr998a2ydjn";
      type = "gem";
    };
    version = "12.3.2";
  };
  rb-fsevent = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lm1k7wpz69jx7jrc92w3ggczkjyjbfziq5mg62vjnxmzs383xx8";
      type = "gem";
    };
    version = "0.10.3";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yfsgw5n7pkpyky6a9wkf1g9jafxb0ja7gz0qw0y14fd2jnzfh71";
      type = "gem";
    };
    version = "0.9.10";
  };
  rdf = {
    dependencies = ["hamster" "link_header"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ylgsspdj2g0af0pgfi1ry50x8ng5069223238vg8kz0p7b24q79";
      type = "gem";
    };
    version = "3.0.9";
  };
  rdf-normalize = {
    dependencies = ["rdf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h8qk3x5frqbgb4gj9ga75ddls47x8qhghscgz82gfq76m4r45g0";
      type = "gem";
    };
    version = "0.3.3";
  };
  redis = {
    groups = ["default" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rk6mmy3y2jd34llrf591ribl1p54ghkw7m96wrbamy8fwva5zqv";
      type = "gem";
    };
    version = "4.1.0";
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
      sha256 = "0r7daagrjjribn098dxwbv9zivrbq2rsffbkj2ccxyn9lmjjbgah";
      type = "gem";
    };
    version = "1.6.0";
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
      sha256 = "18g5jyg3blsdrz3mc8d87bms6qqn6gcdh1nvdhvgbjdpk9pw21dq";
      type = "gem";
    };
    version = "1.3.0";
  };
  request_store = {
    dependencies = ["rack"];
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1963330z03fk382fi8y231ygcbnh86m91dqlp5rh1mwy9ihzzl6d";
      type = "gem";
    };
    version = "1.4.1";
  };
  responders = {
    dependencies = ["actionpack" "railties"];
    groups = ["default" "pam_authentication"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18lqbiyc7234vd6iwxia5yvvzg6bdvdwl2nm4a5y7ia5fxjl3kqm";
      type = "gem";
    };
    version = "2.4.1";
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
    dependencies = ["chunky_png"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h1pnnydgs032psakvg3l779w3ghbn08ajhhhw19hpmnfhrs8k0a";
      type = "gem";
    };
    version = "0.10.1";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1s5bnbqp3sxk67y0fh0x884jjym527r0vgmhbm81w7aq6b7l4p";
      type = "gem";
    };
    version = "3.8.0";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18l21hy1zdc2pgc2yb17k3n2al1khpfr0z6pijlm852iz6vj0dkm";
      type = "gem";
    };
    version = "3.8.2";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06y508cjqycb4yfhxmb3nxn0v9xqf17qbd46l1dh4xhncinr4fyp";
      type = "gem";
    };
    version = "3.8.0";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pf6n9l4sw1arlax1bdbm1znsvl8cgna2n6k6yk1bi8vz2n73ls1";
      type = "gem";
    };
    version = "3.8.2";
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
      sha256 = "0p3m7drixrlhvj2zpc38b11x145bvm311x6f33jjcxmvcm0wq609";
      type = "gem";
    };
    version = "3.8.0";
  };
  rubocop = {
    dependencies = ["jaro_winkler" "parallel" "parser" "psych" "rainbow" "ruby-progressbar" "unicode-display_width"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18npdw0j4pxdp36aixl43v4jyv760523l2far1sqvcp8mah2ksf1";
      type = "gem";
    };
    version = "0.67.1";
  };
  ruby-progressbar = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cv2ym3rl09svw8940ny67bav7b2db4ms39i4raaqzkf59jmhglk";
      type = "gem";
    };
    version = "1.10.0";
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
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
      type = "gem";
    };
    version = "1.0.4";
  };
  sanitize = {
    dependencies = ["crass" "nokogiri" "nokogumbo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rsb2gvqdh41miq7xjckidmgnjh3slvfqbp1hh4s6xfhc32r8g3s";
      type = "gem";
    };
    version = "5.0.0";
  };
  sass = {
    dependencies = ["sass-listen"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18c6prbw9wl8bqhb2435pd9s0lzarl3g7xf8pmyla28zblvwxmyh";
      type = "gem";
    };
    version = "3.6.0";
  };
  sass-listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";
      type = "gem";
    };
    version = "4.0.0";
  };
  scss_lint = {
    dependencies = ["rake" "sass"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dv4ff1lqbgqdx99nwg059c983dhw67kvvjd21f6vf62cjx09lpn";
      type = "gem";
    };
    version = "0.57.1";
  };
  sidekiq = {
    dependencies = ["connection_pool" "rack" "rack-protection" "redis"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1caiq5f5z5vzfria554n04pcbwc8zixf1fpavaksly9zywr3pc29";
      type = "gem";
    };
    version = "5.2.5";
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
      sha256 = "0mwzrl9rhs90a34xp2h4hkxcxm12bwvmvh5l78zsgb1qddxgs67i";
      type = "gem";
    };
    version = "6.0.12";
  };
  simple-navigation = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08a2s18an3br3xj5j86r33q0hrkai0y157xg67h1khdskb08yylk";
      type = "gem";
    };
    version = "4.0.5";
  };
  simple_form = {
    dependencies = ["actionpack" "activemodel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1221bf6glwinknrnp3pa2676ayg1yxyfa6l6lbajc72950v5mzm6";
      type = "gem";
    };
    version = "4.1.0";
  };
  simplecov = {
    dependencies = ["docile" "json" "simplecov-html"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sfyfgf7zrp2n42v7rswkqgk3bbwk1bnsphm24y7laxv3f8z0947";
      type = "gem";
    };
    version = "0.16.1";
  };
  simplecov-html = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lihraa4rgxk8wbfl77fy9sf0ypk31iivly8vl3w04srd7i0clzn";
      type = "gem";
    };
    version = "0.10.2";
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
      sha256 = "1982pcckxy811gm6z9h8brkds13mrgrx8sgmdz8dq5rg1h91y0yw";
      type = "gem";
    };
    version = "1.17.0";
  };
  stackprof = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v7mkl4ng2is5h0glivhcjjkkj2shq1qzx9sg9shw9nn8xvg7i4w";
      type = "gem";
    };
    version = "0.2.12";
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
      sha256 = "1c55ar2chyivz8n6xkhyq36hgpb0b7cfqfjrcyyv9sjiyrbqyhic";
      type = "gem";
    };
    version = "2.1.3";
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
      sha256 = "0scrffkhjx14rrk5cn01vg20y3vvhzzb47a7c9wa864aq8j8kw7z";
      type = "gem";
    };
    version = "0.3.1";
  };
  temple = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "158d7ygbwcifqnvrph219p7m78yjdjazhykv5darbkms7bxm5y09";
      type = "gem";
    };
    version = "0.8.1";
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
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ca4k0clwf0rkvy7726x4nxpjxkpv67w043i39saxgldxd97zmwz";
      type = "gem";
    };
    version = "2.0.9";
  };
  timers = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04zbs9wyzajn7g9xfgg2zqz5kzf0qa7jgh4hgry4pfcxfmlnwdwx";
      type = "gem";
    };
    version = "4.2.0";
  };
  tty-color = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zz5xa6xbrj69h334d8nx7z732fz80s1a0b02b53mim95p80s7bk";
      type = "gem";
    };
    version = "0.4.3";
  };
  tty-command = {
    dependencies = ["pastel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d1fghdvnlc8m5i36h7gswn21232k2f9z5ls73fhs9p5ryfs4vz7";
      type = "gem";
    };
    version = "0.8.2";
  };
  tty-cursor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f4rsapf4apaxn11xnqrq7axgrlvn6pdlqxqb2g34jnpfh5yrk1i";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-prompt = {
    dependencies = ["necromancer" "pastel" "timers" "tty-cursor" "tty-reader"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wjlsrzky7n7fr4psy2jbi4qpcixkq3196g0bbnmmjy6f26vrjcm";
      type = "gem";
    };
    version = "0.18.1";
  };
  tty-reader = {
    dependencies = ["tty-cursor" "tty-screen" "wisper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r1cbfmkprp2m8jbf5f59jqn2zda7xqxj3gzdsgpz8v7arp9m3wn";
      type = "gem";
    };
    version = "0.5.0";
  };
  tty-screen = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0azpjgyhdm8ycblnx9crq3dgb2x8yg454a13n60zfpsc0n138sw1";
      type = "gem";
    };
    version = "0.6.5";
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
      sha256 = "06p1i6qhy34bpb8q8ms88y6f2kz86azwm098yvcc0nyqk9y729j1";
      type = "gem";
    };
    version = "0.0.7.5";
  };
  unicode-display_width = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ssnc6rja9ii97z7m35y4zd0rd7cpv3bija20l7cpd7y4jyyx44q";
      type = "gem";
    };
    version = "1.5.0";
  };
  uniform_notifier = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mb0pq99zm17qnz2czmad5b3z0ivzkf6493afj3n550kd56z18s3";
      type = "gem";
    };
    version = "1.12.1";
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
      sha256 = "0gg0c2sxq7rni0b93w47h7p7cn590xdhf5va7ska48inpipwlgxp";
      type = "gem";
    };
    version = "3.5.1";
  };
  webpacker = {
    dependencies = ["activesupport" "rack-proxy" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rci5q5cph283a8950klc6hbmrgb444p4i5l77hyd637h5rcs1lz";
      type = "gem";
    };
    version = "4.0.2";
  };
  webpush = {
    dependencies = ["hkdf" "jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fky1gmxq4izdrrnmfmbizggwailk7gr716rp15bhpi9ff70gmhl";
      type = "gem";
    };
    version = "0.3.7";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1551k3fs3kkb3ghqfj3n5lps0ikb9pyrdnzmvgfdxy8574n4g1dn";
      type = "gem";
    };
    version = "0.7.0";
  };
  websocket-extensions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "034sdr7fd34yag5l6y156rkbhiqgmy395m231dwhlpcswhs6d270";
      type = "gem";
    };
    version = "0.1.3";
  };
  wisper = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ar2wn3pxnffyzcmf67y67b8lnhgn9zayqhqp26jwqa3d73j71kd";
      type = "gem";
    };
    version = "2.0.0";
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
