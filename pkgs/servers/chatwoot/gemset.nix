{
  action-cable-testing = {
    dependencies = ["actioncable"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nj4y9058mm6rvs5wl613hnflqi3727x3y7h0wsh6bbvakm9gqib";
      type = "gem";
    };
    version = "0.6.1";
  };
  actioncable = {
    dependencies = ["actionpack" "nio4r" "websocket-driver"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1543p34bfq7s4l83m0f84f0z5yr1ip1miyimv4gh2k136pgk23r9";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  actionmailbox = {
    dependencies = ["actionpack" "activejob" "activerecord" "activestorage" "activesupport" "mail"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dnx7mhhzwr45lsxkd7y9ld9vazcadxzs7813jp19hk3wra4jvs3";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cnsv97qx7708wg00lxcl7a6h8amxn85h40s8ngszhknh8wpwj3f";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10rn7gmnnwpm593xv6lcf4qa72wmlbyjg4zmdc3lpb5596whd3yz";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  actiontext = {
    dependencies = ["actionpack" "activerecord" "activestorage" "activesupport" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13i7x4zp991sq3zsagpzs01bhm81zgy63lamqrpsp68nv584n5sx";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ikqpxsrsb7xmq6ds5iq22nj2j3ai16z8z2j5r6lk8pzbi0wwsz5";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sy9kyl7famlwrdw7gz6sy7azhkcsn1mjja44s44libcz3fl7jpc";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15kq8ghmkav331dz1pak1bc8q1v5xajw6pkj20hqr8m5zl6czcld";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a3hc2rammy4mfrjwzc9rsn497yq9xc0x89c00niiq45q3qs44vz";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  activerecord-import = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03jmrwyj1qf63r98nx1wv3m37lnr8bsmp6scngikrj3r225vycqs";
      type = "gem";
    };
    version = "1.0.7";
  };
  activestorage = {
    dependencies = ["actionpack" "activejob" "activerecord" "marcel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jwdfqn01g7v7ssrrf2q2pvc8k6rdqccp26qkyfxiraaz9d1la62";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sls37x9pd2zmipn14c46gcjbfzlg269r413cvm0d58595qkiv7z";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  acts-as-taggable-on = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nvhd986xa6llyjnhikq4h1nrcf5b9r9s11if25qsj8358inrpga";
      type = "gem";
    };
    version = "6.5.0";
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
  administrate = {
    dependencies = ["actionpack" "actionview" "activerecord" "autoprefixer-rails" "datetime_picker_rails" "jquery-rails" "kaminari" "momentjs-rails" "sassc-rails" "selectize-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02i44m68njf4kg2ajknz48qhxhaavy18dv0cc673vw176xd2v1yp";
      type = "gem";
    };
    version = "0.14.0";
  };
  annotate = {
    dependencies = ["activerecord" "rake"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dxrfppwfg13vqmambbs56xjj8qsdgcy58r2yc44vvy3z1g5yflw";
      type = "gem";
    };
    version = "3.1.1";
  };
  ast = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l3468czzjmxl93ap40hp7z94yxp4nbag0bxqs789bm30md90m2a";
      type = "gem";
    };
    version = "2.4.1";
  };
  attr_extras = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kaaza605r843jb6bp5am7rfgalvp9l79w5lr5mdly25hywbmlq9";
      type = "gem";
    };
    version = "6.2.4";
  };
  autoprefixer-rails = {
    dependencies = ["execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v96qjvr4hblqw6zzn7sabjlvhzsmxlwq7z0zrm9fykzhp8sj78g";
      type = "gem";
    };
    version = "9.8.6.3";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r0pn66yqrdkrfdin7qdim0yj2x75miyg4wp6mijckhzhrjb7cv5";
      type = "gem";
    };
    version = "1.1.0";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0135gcc81nkzkd0pw4p31qla83phm36s5m3nff3jig7baaknl03c";
      type = "gem";
    };
    version = "1.360.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "159y3ly54cbw3pyyfids61ypfv2z1vbp89vgxplb9k4lxrc8c5xb";
      type = "gem";
    };
    version = "3.105.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gh8zi19bkz4p8969yl4y8fi3wvfg9gxk4l07jmmr7lmiz2qbdka";
      type = "gem";
    };
    version = "1.37.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17q2rw4dbiql420swkcrjv77pvarv0biis39rxyz3b2c6w6dr035";
      type = "gem";
    };
    version = "1.79.1";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ll9382c1x2hp750cilh01h1cycgyhdr4cmmgx23k94hyyb8chv5";
      type = "gem";
    };
    version = "1.2.2";
  };
  axiom-types = {
    dependencies = ["descendants_tracker" "ice_nine" "thread_safe"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10q3k04pll041mkgy0m5fn2b1lazm6ly1drdbcczl5p57lzi3zy1";
      type = "gem";
    };
    version = "0.1.1";
  };
  azure-storage-blob = {
    dependencies = ["azure-storage-common" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01psx005lkrfk3zm816z76fa2pv4hd8jk7hxrjyy4hbvgcqi6rfy";
      type = "gem";
    };
    version = "2.0.1";
  };
  azure-storage-common = {
    dependencies = ["faraday" "faraday_middleware" "net-http-persistent" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h5bwswc5768hblcxsschjz3y0lf9kvz3k7qqwypdhy8sr1lfxg8";
      type = "gem";
    };
    version = "2.0.2";
  };
  barnes = {
    dependencies = ["multi_json" "statsd-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0864vhml64mg9bhkjs6hqii40yx67x42nggmgmxvhh1rcwpdr08h";
      type = "gem";
    };
    version = "0.0.8";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13r86j7avy049hcpzrkyiz8bkghqa8fqvc3fa2s67wvy7b3qyhpg";
      type = "gem";
    };
    version = "3.1.15";
  };
  bindex = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zmirr3m02p52bzq4xgksq4pn8j641rx5d4czk68pv9rqnfwq7kv";
      type = "gem";
    };
    version = "0.8.1";
  };
  bootsnap = {
    dependencies = ["msgpack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m11hpwaqkdhmkld6w9pkm2kjv6m8ib6q9q86s3c2pqwbiii0nc6";
      type = "gem";
    };
    version = "1.4.8";
  };
  brakeman = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "063sn2hx79mbky9h3qjdri31bhx7xa4p0yq4qp5n2wwhcblzxz1s";
      type = "gem";
    };
    version = "4.9.0";
  };
  browser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g4bcpax07kqqr9cp7cjc7i0pcij4nqpn1rdsg2wdwhzf00m6x32";
      type = "gem";
    };
    version = "5.3.1";
  };
  builder = {
    groups = ["default" "development" "test"];
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
  bundle-audit = {
    dependencies = ["bundler-audit"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hvs3blinwd1ngqpf27p8rzim32r11xwhsdy6yl1ns6y1j98bw68";
      type = "gem";
    };
    version = "0.1.0";
  };
  bundler-audit = {
    dependencies = ["thor"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04l9rs56rlvihbr2ybkrigjajgd3swa98lxvmdl8iylj1g5m7n0j";
      type = "gem";
    };
    version = "0.7.0.1";
  };
  byebug = {
    groups = ["development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nx3yjf4xzdgb8jkmk2344081gqr22pgjqnmjg2q64mj5d6r9194";
      type = "gem";
    };
    version = "11.1.3";
  };
  coderay = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  coercible = {
    dependencies = ["descendants_tracker"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p5azydlsz0nkxmcq0i1gzmcfq02lgxc4as7wmf47j1c6ljav0ah";
      type = "gem";
    };
    version = "1.0.0";
  };
  commonmarker = {
    dependencies = ["ruby-enum"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18mciag8jp3jggivfld556myx6y3h0vzqmaqrafjx2l3yhga9yir";
      type = "gem";
    };
    version = "0.21.1";
  };
  concurrent-ruby = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mr23wq0szj52xnj0zcn1k0c7j4v79wlwbijkpfcscqww3l6jlg3";
      type = "gem";
    };
    version = "1.1.8";
  };
  connection_pool = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qikl4av1z8kqnk5ba18136dpqzw8wjawc2w9b4zb5psdd5z8nwf";
      type = "gem";
    };
    version = "2.2.3";
  };
  crack = {
    dependencies = ["safe_yaml"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0abb0fvgw00akyik1zxnq7yv391va148151qxdghnzngv66bl62k";
      type = "gem";
    };
    version = "0.4.3";
  };
  crass = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    version = "1.0.6";
  };
  cypress-on-rails = {
    dependencies = ["rack"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fmbjyfjsddyk27d6lag5g300v8886h210cpn5b4xanj6k6bw5dj";
      type = "gem";
    };
    version = "1.8.0";
  };
  database_cleaner = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ac2lsh7nq8b5j0dkah7d3pkcxgak70m4zb9p71hyy155rpc5a60";
      type = "gem";
    };
    version = "1.8.5";
  };
  datetime_picker_rails = {
    dependencies = ["momentjs-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14bf3nz8plyaybyg2c93nb0zj45x0g5j5cagwxv91cfla0qxv157";
      type = "gem";
    };
    version = "0.0.7";
  };
  declarative = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yczgnqrbls7shrg63y88g7wand2yp9h6sf56c9bdcksn5nds8c0";
      type = "gem";
    };
    version = "0.0.20";
  };
  declarative-option = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g4ibxq566f1frnhdymzi9hxxcm4g2gw4n21mpjk2mhwym4q6l0p";
      type = "gem";
    };
    version = "0.1.0";
  };
  descendants_tracker = {
    dependencies = ["thread_safe"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15q8g3fcqyb41qixn6cky0k3p86291y7xsh1jfd851dvrza1vi79";
      type = "gem";
    };
    version = "0.0.4";
  };
  devise = {
    dependencies = ["bcrypt" "orm_adapter" "railties" "responders" "warden"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kbcq9z05la2nlv4sy1arxpxd75h31c62bqyrv8zay3b98fifhid";
      type = "gem";
    };
    version = "4.7.2";
  };
  devise_token_auth = {
    dependencies = ["bcrypt" "devise" "rails" "sprockets"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16wlmd6khig1x8flkvk402gsk5jykbjksyk96jcbmw6bf5v0qpjp";
      type = "gem";
    };
    version = "1.1.4";
  };
  diff-lcs = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m925b8xc6kbpnif9dldna24q1szg4mk0fvszrki837pfn46afmz";
      type = "gem";
    };
    version = "1.4.4";
  };
  digest-crc = {
    dependencies = ["rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nygbn680kmya9vnz0pr9681z8lszr2whln0rxk168vaxbcnga8d";
      type = "gem";
    };
    version = "0.6.1";
  };
  docile = {
    groups = ["default" "development" "test"];
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
  dotenv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iym172c5337sm1x2ykc2i3f961vj3wdclbyg1x6sxs3irgfsl94";
      type = "gem";
    };
    version = "2.7.6";
  };
  dotenv-rails = {
    dependencies = ["dotenv" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1my2jdmgmpf32rfxffkb9cyxh7ayis4q5ygpwjqj4vpp25y3a70c";
      type = "gem";
    };
    version = "2.7.6";
  };
  equalizer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kjmx3fygx8njxfrwcmn7clfhjhb6bvv3scy2lyyi0wqyi3brra4";
      type = "gem";
    };
    version = "0.0.11";
  };
  erubi = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09l8lz3j00m898li0yfsnb6ihc63rdvhw3k5xczna5zrjk104f2l";
      type = "gem";
    };
    version = "1.10.0";
  };
  et-orbi = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xr8i8ql4xzx17d12590i3j299hj6vc0ja2j29dy12i5nlchxrvp";
      type = "gem";
    };
    version = "1.2.4";
  };
  execjs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yz55sf2nd3l666ms6xr18sm2aggcvmb8qr3v53lr4rir32y1yp1";
      type = "gem";
    };
    version = "2.7.0";
  };
  facebook-messenger = {
    dependencies = ["httparty" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x3d813a7da8x9jk0iyyf8wc7ayk84njpzazsxvvxnmbfarlszqh";
      type = "gem";
    };
    version = "1.5.0";
  };
  factory_bot = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11ij9s4hasy963qjqbrrf0m8lm9m9pxkh2vf4wrnafa6gw6r9qk8";
      type = "gem";
    };
    version = "6.1.0";
  };
  factory_bot_rails = {
    dependencies = ["factory_bot" "railties"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hfxkq6rarg0b8xfzqg200xyj176sn1xplqqqcrz5drhkqp30m14";
      type = "gem";
    };
    version = "6.1.0";
  };
  faker = {
    dependencies = ["i18n"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j4c4hm1licf0c7bhhib54xafyfi239ljwkz16lc39cwvwwl1nnv";
      type = "gem";
    };
    version = "2.13.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wwks9652xwgjm7yszcq5xr960pjypc07ivwzbjzpvy9zh2fw6iq";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jik2kgfinwnfi6fpp512vlvs0mlggign3gkbpkg5fw1jr9his0r";
      type = "gem";
    };
    version = "1.0.0";
  };
  fcm = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0swq2icy3k82abmlkwvfc69155m5995x5vlfdlyy5llm8mvm3mij";
      type = "gem";
    };
    version = "1.0.2";
  };
  ffi = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15hgiy09i8ywjihyzyvjvk42ivi3kmy6dm21s5sgg9j7y3h3zkkx";
      type = "gem";
    };
    version = "1.14.2";
  };
  flag_shih_tzu = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gk1f24w94bfmnih5l1gfm84c2676j7y111qw5qicxwnbdd230h9";
      type = "gem";
    };
    version = "0.3.23";
  };
  foreman = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0szgxvnzwkzrfbq5dkwa98mig78aqglfy6irdsvq1gq045pbq9r7";
      type = "gem";
    };
    version = "0.87.2";
  };
  fugit = {
    dependencies = ["et-orbi" "raabro"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bkqsw8dqliy1pbqzmbfyv3ibf6xcrlxz41s0878aw9glizm7912";
      type = "gem";
    };
    version = "1.4.1";
  };
  geocoder = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a8lxchcqzc8wqafsd0n63kaiym2nj9fyax0adcirr0krvqa8hxa";
      type = "gem";
    };
    version = "1.6.3";
  };
  gli = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q598mvl20isn3ja1ya0p72svmqwx3m6fjp5slnv0b2c5mh0ahvv";
      type = "gem";
    };
    version = "2.19.2";
  };
  globalid = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zkxndvck72bfw235bd9nl2ii0lvs5z88q14706cmn702ww2mxv1";
      type = "gem";
    };
    version = "0.4.2";
  };
  google-api-client = {
    dependencies = ["addressable" "googleauth" "httpclient" "mini_mime" "representable" "retriable" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j5l0raqk0j6p3kl494vpl6mb0zaqdvz5jhh4xys4jn35klgn1dm";
      type = "gem";
    };
    version = "0.43.0";
  };
  google-cloud-core = {
    dependencies = ["google-cloud-env" "google-cloud-errors"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qjn7vs8f85vxi1nkikbjfja6bv9snrj26vzscjii0cm8n4dy0i1";
      type = "gem";
    };
    version = "1.5.0";
  };
  google-cloud-env = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0frifczbhs5k699avaxnaypijfmjd2zb1rbdmcb30vdx8sskypa9";
      type = "gem";
    };
    version = "1.3.3";
  };
  google-cloud-errors = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hvs1x39g77hbdqjxmzcl6gq8160pv3kskvzbbch0ww1np6qwm67";
      type = "gem";
    };
    version = "1.0.1";
  };
  google-cloud-storage = {
    dependencies = ["addressable" "digest-crc" "google-api-client" "google-cloud-core" "googleauth" "mini_mime"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10rnv0mr6qswpbfkxsqnk70x6przc94df52hscdr7f2l8b4g4d5i";
      type = "gem";
    };
    version = "1.28.0";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "memoist" "multi_json" "os" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ldhllhv8mlbalp8a3zb1hsj5p2i8f0vf88r71vm083gq7820iwn";
      type = "gem";
    };
    version = "0.13.1";
  };
  groupdate = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1byjnssnwzjq30aksjjnfhyskyijgjm6mfkrkrhm3575pjrm8q9l";
      type = "gem";
    };
    version = "5.1.0";
  };
  haikunator = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13rkrrkqbsg9yvp1x1v4wf5i8ff4vz8jw2rcl18zagrwccvmy82c";
      type = "gem";
    };
    version = "1.1.0";
  };
  hairtrigger = {
    dependencies = ["activerecord" "ruby2ruby" "ruby_parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15w1622p0dvbff0cf16vvl2qgbki5fd4lqwg0lsqcgpw88vd3cp0";
      type = "gem";
    };
    version = "0.2.23";
  };
  hana = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ij5clmkfl5ij9wdzr62b0w7j2qg7pb65mhvxa6mf1kv1xp6l585";
      type = "gem";
    };
    version = "1.3.6";
  };
  hashdiff = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nynpl0xbj0nphqx1qlmyggq58ms1phf5i03hk64wcc0a17x1m1c";
      type = "gem";
    };
    version = "1.0.1";
  };
  hashie = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02bsx12ihl78x0vdm37byp78jjw2ff6035y7rrmbd90qxjwxr43q";
      type = "gem";
    };
    version = "4.1.0";
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
  http-accept = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09m1facypsdjynfwrcv19xcb1mqg8z6kk31g8r33pfxzh838c9n6";
      type = "gem";
    };
    version = "1.7.0";
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
  httparty = {
    dependencies = ["mime-types" "multi_xml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17gpnbf2a7xkvsy20jig3ljvx8hl5520rqm9pffj2jrliq1yi3w7";
      type = "gem";
    };
    version = "0.18.1";
  };
  httpclient = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08p6b13p99j1rrcrw1l3v0kb9mxbsvy6nk31r8h4rnszdgzpga32";
      type = "gem";
    };
    version = "1.8.9";
  };
  ice_nine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    version = "0.11.2";
  };
  inflecto = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "085l5axmvqw59mw5jg454a3m3gr67ckq9405a075isdsn7bm3sp4";
      type = "gem";
    };
    version = "0.0.2";
  };
  jbuilder = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w5zrpfxaxlnq0ild80mbxz4w226l1gv0v1i51x6gy2sw1z69r0f";
      type = "gem";
    };
    version = "2.10.0";
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
  jquery-rails = {
    dependencies = ["rails-dom-testing" "railties" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dkhm8lan1vnyl3ll0ks2q06576pdils8a1dr354vfc1y5dqw15i";
      type = "gem";
    };
    version = "4.4.0";
  };
  json = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "158fawfwmv2sq4whqqaksfykkiad2xxrrj0nmpnc6vnlzi1bp7iz";
      type = "gem";
    };
    version = "2.3.1";
  };
  json_refs = {
    dependencies = ["hana"];
    groups = ["development"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "e32deb073ce9aef39bdd63556bffd7fe7c2a803d";
      sha256 = "1b1s6pxk7prx4jk1ryklhp6mcqri9z1igx7gbr7d4acxbavnpiyx";
      type = "git";
      url = "https://github.com/tzmfreedom/json_refs";
    };
    version = "0.1.2";
  };
  jwt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14ynyq1q483spj20ffl4xayfqx1a8qr761mqjfxczf8lwlap392n";
      type = "gem";
    };
    version = "2.2.2";
  };
  kaminari = {
    dependencies = ["activesupport" "kaminari-actionview" "kaminari-activerecord" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vxkqciny5v4jgmjxl8qrgbmig2cij2iskqbwh4bfcmpxf467ch3";
      type = "gem";
    };
    version = "1.2.1";
  };
  kaminari-actionview = {
    dependencies = ["actionview" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w0p1hyv6lgf6h036cmn2kbkdv4x7g0g9q9kc5gzkpz7amlxr8ri";
      type = "gem";
    };
    version = "1.2.1";
  };
  kaminari-activerecord = {
    dependencies = ["activerecord" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02n5xxv6ilh39q2m6vcz7qrdai7ghk3s178dw6f0b3lavwyq49w3";
      type = "gem";
    };
    version = "1.2.1";
  };
  kaminari-core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h04cr4y1jfn81gxy439vmczifghc2cvsyw47aa32is5bbxg1wlz";
      type = "gem";
    };
    version = "1.2.1";
  };
  koala = {
    dependencies = ["addressable" "faraday" "json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k7nlif8nwgb6bfkclry41xklaf4rqf18ycgq63sgkgj6zdpda4w";
      type = "gem";
    };
    version = "3.0.0";
  };
  launchy = {
    dependencies = ["addressable"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xdyvr5j0gjj7b10kgvh8ylxnwk3wx19my42wqn9h82r4p246hlm";
      type = "gem";
    };
    version = "2.5.0";
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
  liquid = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zhg5ha8zy8zw9qr3fl4wgk4r5940n4128xm2pn4shpbzdbsj5by";
      type = "gem";
    };
    version = "4.0.3";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zpcgha7g33wvy2xbbc663cbjyvg9l1325lg3gzgcn3baydr9rha";
      type = "gem";
    };
    version = "3.3.3";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bzwvxvilx7w1p3pg028ks38925y9i0xm870lm7s12w7598hiyck";
      type = "gem";
    };
    version = "2.9.0";
  };
  mail = {
    dependencies = ["mini_mime"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00wwz6ys0502dpk8xprwcqfwyf3hmnx6lgxaiq6vj43mkx43sapc";
      type = "gem";
    };
    version = "2.7.1";
  };
  marcel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vhp6lifwvqs2b0a276lj61n86c1l7d1xiswjj2w23f54gl51mpk";
      type = "gem";
    };
    version = "1.0.0";
  };
  maxminddb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zlhqilyggiryywgswfi624bv10qnkm66hggmg79vvgv73j3p4sh";
      type = "gem";
    };
    version = "0.1.22";
  };
  memoist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i9wpzix3sjhf6d9zw60dm4371iq8kyz7ckh2qapan2vyaim6b55";
      type = "gem";
    };
    version = "0.16.2";
  };
  method_source = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      type = "gem";
    };
    version = "1.0.0";
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
      sha256 = "1z75svngyhsglx0y2f9rnil2j08f9ab54b3l95bpgz67zq2if753";
      type = "gem";
    };
    version = "3.2020.0512";
  };
  mini_magick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lpq12z70n10c1qshcddd5nib2pkcbkwzvmiqqzj60l01k3x4fg9";
      type = "gem";
    };
    version = "4.10.1";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1np6srnyagghhh2w4nyv09sz47v0i6ri3q6blicj94vgxqp12c94";
      type = "gem";
    };
    version = "1.0.3";
  };
  mini_portile2 = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hdbpmamx8js53yk3h8cqy12kgv6ca06k0c9n3pxh6b6cjfs19x7";
      type = "gem";
    };
    version = "2.5.0";
  };
  minitest = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19z7wkhg59y8abginfrm2wzplz7py3va8fyngiigngqvsws6cwgl";
      type = "gem";
    };
    version = "5.14.4";
  };
  mock_redis = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "16d00789f0341a3aac35126c0ffe97a596753ff9";
      sha256 = "1rqzrwr41akrcrrc6ynvg7j9bdrshzmyihcm5m8i5q1wxf0hccr2";
      type = "git";
      url = "https://github.com/sds/mock_redis";
    };
    version = "0.22.0";
  };
  momentjs-rails = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mqk2x8qh7qq8ll9ck8yv40w909m4qa5qh3dfzg8fdna35ljhjnz";
      type = "gem";
    };
    version = "2.20.1";
  };
  msgpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lva6bkvb4mfa0m3bqn4lm4s4gi81c40jvdcsrxr6vng49q9daih";
      type = "gem";
    };
    version = "1.3.3";
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
  multi_xml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lmd4f401mvravi1i1yq7b2qjjli0yq7dfc4p1nj5nwajp7r6hyj";
      type = "gem";
    };
    version = "0.6.0";
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
  net-http-persistent = {
    dependencies = ["connection_pool"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sbdvkn7mzl883iykz74hgp14qj041gldf2vdk9g3gyqc843l2vr";
      type = "gem";
    };
    version = "4.0.0";
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
  nio4r = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00fwz0qq7agd2xkdz02i8li236qvwhma3p0jdn5bdvc21b7ydzd5";
      type = "gem";
    };
    version = "2.5.7";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b51df8fwadak075cvi17w0nch6qz1r66564qp29qwfj67j9qp0p";
      type = "gem";
    };
    version = "1.11.2";
  };
  oauth = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zszdg8q1b135z7l7crjj234k4j0m347hywp5kj6zsq7q78pw09y";
      type = "gem";
    };
    version = "0.5.4";
  };
  orm_adapter = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fg9jpjlzf5y49qs9mlpdrgs5rpcyihq1s4k79nv9js0spjhnpda";
      type = "gem";
    };
    version = "0.5.0";
  };
  os = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12fli64wz5j9868gpzv5wqsingk1jk457qyqksv9ksmq9b0zpc9x";
      type = "gem";
    };
    version = "1.1.1";
  };
  parallel = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17b127xxmm2yqdz146qwbs57046kn0js1h8synv01dwqz2z1kp2l";
      type = "gem";
    };
    version = "1.19.2";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1030znhvhkfn39svwbj6qn4xb6hgl94gnvg57k4d3r76f9bryqmn";
      type = "gem";
    };
    version = "2.7.1.4";
  };
  pg = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13mfrysrdrh8cka1d96zm0lnfs59i5x2g6ps49r2kz5p3q81xrzj";
      type = "gem";
    };
    version = "1.2.3";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iyw4q4an2wmk8v5rn2ghfy2jaz9vmw2nk8415nnpx2s866934qk";
      type = "gem";
    };
    version = "0.13.1";
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
      sha256 = "0vywld400fzi17cszwrchrzcqys4qm6sshbv73wy5mwcixmrgg7g";
      type = "gem";
    };
    version = "4.0.5";
  };
  puma = {
    dependencies = ["nio4r"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01wkz13rvjprkb23f99zg9r1h1iicfrwwc0lfi40zklgzrg6ygc1";
      type = "gem";
    };
    version = "4.3.6";
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
      sha256 = "10m8bln9d00dwzjil1k42i5r7l82x25ysbi45fwyv4932zsrzynl";
      type = "gem";
    };
    version = "1.4.0";
  };
  racc = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "178k7r0xn689spviqzhvazzvxfq6fyjldxb3ywjbgipbfi4s8j1g";
      type = "gem";
    };
    version = "1.5.2";
  };
  rack = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i5vs0dph9i5jn8dfc6aqd6njcafmb20rwqngrf759c9cvmyff16";
      type = "gem";
    };
    version = "2.2.3";
  };
  rack-cache = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0022cd97jxhnvwjv12fz3xda7i7cq97hbvg04b1067szyw23lx0k";
      type = "gem";
    };
    version = "1.12.0";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rh8h376mx71ci5yklnpqqn118z3bl67nnv5k801qaqn1zs62h8m";
      type = "gem";
    };
    version = "1.1.0";
  };
  rails = {
    dependencies = ["actioncable" "actionmailbox" "actionmailer" "actionpack" "actiontext" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties" "sprockets-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01mwx4q9yz792dbi61j378iz6p7q63sxj3267jwwccjqmn6hf2kr";
      type = "gem";
    };
    version = "6.0.3.6";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri"];
    groups = ["default" "development" "test"];
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1icpqmxbppl4ynzmn6dx7wdil5hhq6fz707m9ya6d86c7ys8sd4f";
      type = "gem";
    };
    version = "1.3.0";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "method_source" "rake" "thor"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i50vbscdk6wqxd2p0xwsyi07lwda612njqk8pn1f56snz5z0dcr";
      type = "gem";
    };
    version = "6.0.3.6";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iik52mf9ky4cgs38fp2m8r6skdkq1yz23vh18lk95fhbcxb6a67";
      type = "gem";
    };
    version = "13.0.3";
  };
  rb-fsevent = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k9bsj7ni0g2fd7scyyy1sk9dy2pg9akniahab0iznvjmhn54h87";
      type = "gem";
    };
    version = "0.10.4";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jm76h8f8hji38z3ggf4bzi8vps6p7sagxn3ab57qc0xyga64005";
      type = "gem";
    };
    version = "0.10.1";
  };
  redis = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19hm66kw5vx1lmlh8bj7rxlddyj0vfp11ajw9njhrmn8173d0vb5";
      type = "gem";
    };
    version = "4.2.1";
  };
  redis-namespace = {
    dependencies = ["redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05i6s898z5w31z385cba1683pgg5nnmj4m686cbravg7j4pgbcgv";
      type = "gem";
    };
    version = "1.8.0";
  };
  redis-rack-cache = {
    dependencies = ["rack-cache" "redis-store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w4rq5fg4sqj88j4kb3x2gqi6jjar4rdsczrnbz2xq2lcf59fwlw";
      type = "gem";
    };
    version = "2.2.1";
  };
  redis-store = {
    dependencies = ["redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cpzbf2svnk4j5awb24ncl0mih45zkbdrd7q23jdg1r8k3q7mdg6";
      type = "gem";
    };
    version = "1.9.0";
  };
  regexp_parser = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "106azpr2c280y2f8jnr6fd49q1abb43xh9hhgbxc4d4kvzpa8094";
      type = "gem";
    };
    version = "1.7.1";
  };
  representable = {
    dependencies = ["declarative" "declarative-option" "uber"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qm9rgi1j5a6nv726ka4mmixivlxfsg91h8rpp72wwd4vqbkkm07";
      type = "gem";
    };
    version = "3.0.4";
  };
  responders = {
    dependencies = ["actionpack" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14kjykc6rpdh24sshg9savqdajya2dislc1jmbzg91w9967f4gv1";
      type = "gem";
    };
    version = "3.0.1";
  };
  rest-client = {
    dependencies = ["http-accept" "http-cookie" "mime-types" "netrc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qs74yzl58agzx9dgjhcpgmzfn61fqkk33k1js2y5yhlvc5l19im";
      type = "gem";
    };
    version = "2.1.0";
  };
  retriable = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q48hqws2dy1vws9schc0kmina40gy7sn5qsndpsfqdslh65snha";
      type = "gem";
    };
    version = "3.1.2";
  };
  rexml = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mkvkcw9fhpaizrhca0pdgjcrbns48rlz4g6lavl5gjjq3rk2sq3";
      type = "gem";
    };
    version = "3.2.4";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xndkv5cz763wh30x7hdqw6k7zs8xfh0f86amra9agwn44pcqs0y";
      type = "gem";
    };
    version = "3.9.2";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bxkv25qmy39jqrdx35bfgw00g24qkssail9jlljm7hywbqvr9bb";
      type = "gem";
    };
    version = "3.9.2";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19vmdqym1v2g1zbdnq37zwmyj87y9yc9ijwc8js55igvbb9hx0mr";
      type = "gem";
    };
    version = "3.9.1";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lzik01ziaskgpdpy8knffpw0fsy9151f5lfigyhb89wq4q45hfs";
      type = "gem";
    };
    version = "4.0.1";
  };
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dandh2fy1dfkjk8jf9v4azbbma6968bhh06hddv0yqqm8108jir";
      type = "gem";
    };
    version = "3.9.3";
  };
  rubocop = {
    dependencies = ["parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yh71v5d7aw6jz7505d2sv0n0ldf3wh0ly3lphdanjl0n8b42y9h";
      type = "gem";
    };
    version = "0.89.1";
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c2dgb6pk1jrqbx3gg262q8h32icljpnvkl88cyc4mi8kahbg50h";
      type = "gem";
    };
    version = "0.3.0";
  };
  rubocop-performance = {
    dependencies = ["rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04r8d4x62ygv17spvz9yyfxbmbf8qxwhijs0xycfvzr0q4pyg9sw";
      type = "gem";
    };
    version = "1.7.1";
  };
  rubocop-rails = {
    dependencies = ["activesupport" "rack" "rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14g703lv0cbqw504cdjsv0yydrsnm61rwg0n0mql4zl5hw1n7lfh";
      type = "gem";
    };
    version = "2.8.1";
  };
  rubocop-rspec = {
    dependencies = ["rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sc0bwdxzfr8byxzwvfyf22lwzqcaa6ca7wzxx31mk7vvy7r7dhl";
      type = "gem";
    };
    version = "1.43.2";
  };
  ruby-enum = {
    dependencies = ["i18n"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pys90hxylhyg969iw9lz3qai5lblf8xwbdg1g5aj52731a9k83p";
      type = "gem";
    };
    version = "0.9.0";
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
  ruby2ruby = {
    dependencies = ["ruby_parser" "sexp_processor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b7vdzlfyq4cwq4s47jkf9sn8gkhar7jixamid234yg33szm8830";
      type = "gem";
    };
    version = "2.4.4";
  };
  ruby_parser = {
    dependencies = ["rubocop" "sexp_processor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b6l5bxbamaplp904i7f088j806v0pqi0kvhb8xx81v4whl40y2k";
      type = "gem";
    };
    version = "3.15.0";
  };
  safe_yaml = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j7qv63p0vqcd838i2iy2f76c3dgwzkiz1d1xkg7n0pbnxj2vb56";
      type = "gem";
    };
    version = "1.0.5";
  };
  sass = {
    dependencies = ["sass-listen"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p95lhs0jza5l7hqci1isflxakz83xkj97lkvxl919is0lwhv2w0";
      type = "gem";
    };
    version = "3.7.4";
  };
  sass-listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";
      type = "gem";
    };
    version = "4.0.0";
  };
  sassc = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gpqv48xhl8mb8qqhcifcp0pixn206a7imc07g48armklfqa4q2c";
      type = "gem";
    };
    version = "2.4.0";
  };
  sassc-rails = {
    dependencies = ["railties" "sassc" "sprockets" "sprockets-rails" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d9djmwn36a5m8a83bpycs48g8kh1n2xkyvghn7dr6zwh4wdyksz";
      type = "gem";
    };
    version = "2.1.2";
  };
  scout_apm = {
    dependencies = ["parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zgb8sxr5fc253jq8asgl8cilig87mhpwgchvmaj91qi2nk9ijrk";
      type = "gem";
    };
    version = "2.6.9";
  };
  scss_lint = {
    dependencies = ["sass"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s6dzk4n9pnmqciliggwpiny43vc3cx3n2d5gqa9aqng77ff7yv7";
      type = "gem";
    };
    version = "0.59.0";
  };
  seed_dump = {
    dependencies = ["activerecord" "activesupport"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pz69f171fsy11sbgll065ha3wx0z8b517srwgpa43kmb6yc8ccm";
      type = "gem";
    };
    version = "3.3.1";
  };
  selectize-rails = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1adzp7b3qyl4ki1432mga914za0j9dzy7401vs92kl4avr40nns2";
      type = "gem";
    };
    version = "0.12.6";
  };
  semantic_range = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "150wq0y749rags4pm0g3zljd575vk17nwdzp0m0q04s62977rd24";
      type = "gem";
    };
    version = "2.3.0";
  };
  sentry-raven = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n8sqxi868fdsnpw6wqidphnjshfl27ai5zslf7v96yvbdn4dszm";
      type = "gem";
    };
    version = "3.0.3";
  };
  sexp_processor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p0jj2la8bhb7kgqmqbksaq7idnpgjv6asgfd18d2l3z4kra14cj";
      type = "gem";
    };
    version = "4.15.1";
  };
  shoulda-matchers = {
    dependencies = ["activesupport"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wd1bblxr4dfmrnh3j83kvfds6a7nak4ifq37ab0pg1kdi6iiw7l";
      type = "gem";
    };
    version = "4.4.1";
  };
  sidekiq = {
    dependencies = ["connection_pool" "rack" "redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vnx8v2w9randxszcwwxnnd6b2nf6av7c1nl5k7kbyp1jqs941m9";
      type = "gem";
    };
    version = "6.1.1";
  };
  sidekiq-cron = {
    dependencies = ["fugit" "sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hxvm42zbr27k40jvdba5v8ich2ys8q7a2wbia9sxb0mmcy8v2aj";
      type = "gem";
    };
    version = "1.2.0";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10g2667fvxnc50hcd1aywgsbf8j7nrckg3n7zjvywmyz82pwmpqp";
      type = "gem";
    };
    version = "0.14.0";
  };
  simplecov = {
    dependencies = ["docile" "json" "simplecov-html"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1135k46nik05sdab30yxb8264lqiz01c8v000g16cl9pjc4mxrdw";
      type = "gem";
    };
    version = "0.17.1";
  };
  simplecov-html = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lihraa4rgxk8wbfl77fy9sf0ypk31iivly8vl3w04srd7i0clzn";
      type = "gem";
    };
    version = "0.10.2";
  };
  slack-ruby-client = {
    dependencies = ["faraday" "faraday_middleware" "gli" "hashie" "websocket-driver"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pyxwsx1bkr30gqbby5636ljlsm16d41w9bc0d6wx9z2ck1hzfbk";
      type = "gem";
    };
    version = "0.15.0";
  };
  spring = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x2wz1y2b0kp7mlk9k8zkl39rddk2l3x34b7dar3bh3axd1cs30d";
      type = "gem";
    };
    version = "2.1.1";
  };
  spring-watcher-listen = {
    dependencies = ["listen" "spring"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ybz9nsngfz4psvgnbr3gdk5ibqqhq47lsjkwh5yq4f8brpr10yz";
      type = "gem";
    };
    version = "2.0.1";
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
      sha256 = "0mwmz36265646xqfyczgr1mhkm1hfxgxxvgdgr4xfcbf2g72p1k2";
      type = "gem";
    };
    version = "3.2.2";
  };
  squasher = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02rh01b27nilvf6vs0jvxpf6phzxg6w1qa4i1f67iz2za1llmwdp";
      type = "gem";
    };
    version = "0.6.2";
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
  telegram-bot-ruby = {
    dependencies = ["faraday" "inflecto" "virtus"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wcvwj7ngqp8r1fpinp2kc5l49z70idbmc2mc7gj8dy3vgb75xkf";
      type = "gem";
    };
    version = "0.12.0";
  };
  telephone_number = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bwwzv6k5jhz35i5iq6m8wi09qxlimz29iryv2krhdcgicwvskkm";
      type = "gem";
    };
    version = "1.4.9";
  };
  thor = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18yhlvmfya23cs3pvhr1qy38y41b6mhr5q9vwv5lrgk16wmf3jna";
      type = "gem";
    };
    version = "1.1.0";
  };
  thread_safe = {
    groups = ["default" "development" "test"];
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
      sha256 = "0rn8z8hda4h41a64l0zhkiwz2vxw9b1nb70gl37h1dg2k874yrlv";
      type = "gem";
    };
    version = "2.0.10";
  };
  time_diff = {
    dependencies = ["activesupport" "i18n"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zfnnkqbxay2cjkgyy34915fhp89zq6lmiri3dhb99pv3bxyplil";
      type = "gem";
    };
    version = "0.3.0";
  };
  twilio-ruby = {
    dependencies = ["faraday" "jwt" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aby6y4f32aayib6k01nsnz0r7ya7gdjgl6q5k0gzp0pgk1a8l49";
      type = "gem";
    };
    version = "5.32.0";
  };
  twitty = {
    dependencies = ["oauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jngmia25pznpxw6xvbd38rhbdbz1fv40klg7zpgvbpj72q4jbn5";
      type = "gem";
    };
    version = "0.1.1";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zwqqh6138s8b321fwvfbywxy00lw1azw4ql3zr0xh1aqxf8cnvj";
      type = "gem";
    };
    version = "1.2.9";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kjywciambyhlkc8ijp3kkx4r24pi9zs7plmxw003mxr6mrhah1w";
      type = "gem";
    };
    version = "1.2020.1";
  };
  uber = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1mm7mngg40x05z52md3mbamkng0zpajbzqjjwmsyw0zw3v9vjv";
      type = "gem";
    };
    version = "0.1.0";
  };
  uglifier = {
    dependencies = ["execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wgh7bzy68vhv9v68061519dd8samcy8sazzz0w3k8kqpy3g4s5f";
      type = "gem";
    };
    version = "4.2.0";
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
      sha256 = "0wc47r23h063l8ysws8sy24gzh74mks81cak3lkzlrw4qkqb3sg4";
      type = "gem";
    };
    version = "0.0.7.7";
  };
  unicode-display_width = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06i3id27s60141x6fdnjn5rar1cywdwy64ilc59cz937303q3mna";
      type = "gem";
    };
    version = "1.7.0";
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
  valid_email2 = {
    dependencies = ["activemodel" "mail"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sibhd91mjf848w5rarz4f1afkwhny6lm7rwbwzin8594d7k3yiq";
      type = "gem";
    };
    version = "3.3.1";
  };
  virtus = {
    dependencies = ["axiom-types" "coercible" "descendants_tracker" "equalizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06iphwi3c4f7y9i2rvhvaizfswqbaflilziz4dxqngrdysgkn1fk";
      type = "gem";
    };
    version = "1.0.5";
  };
  warden = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fr9n9i9r82xb6i61fdw4xgc7zjv7fsdrr4k0njchy87iw9fl454";
      type = "gem";
    };
    version = "1.2.8";
  };
  web-console = {
    dependencies = ["actionview" "activemodel" "bindex" "railties"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09qgz0j3sa9svrs96zmi8qlkgjgl34jfl6pr4401a0yxani80ifr";
      type = "gem";
    };
    version = "4.0.4";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zhpdq86b00gfyjdski3k0z3rmrgkw2mpfgh394fizwn97mqpnzh";
      type = "gem";
    };
    version = "3.8.3";
  };
  webpacker = {
    dependencies = ["activesupport" "rack-proxy" "railties" "semantic_range"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xgyv5ppljw3yq71nbrw2hj6hq9y8qbdavjrn53nsccpy7801wdx";
      type = "gem";
    };
    version = "5.2.1";
  };
  webpush = {
    dependencies = ["hkdf" "jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0risllxidmi22mjlqrw57cp6cbh5n9kifh76mx5i6n1h3c7gmyx0";
      type = "gem";
    };
    version = "1.0.0";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i3rs4kcj0jba8idxla3s6xd1xfln3k8b4cb1dik2lda3ifnp3dh";
      type = "gem";
    };
    version = "0.7.3";
  };
  websocket-extensions = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
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
  zeitwerk = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1746czsjarixq0x05f7p3hpzi38ldg6wxnxxw74kbjzh1sdjgmpl";
      type = "gem";
    };
    version = "2.4.2";
  };
}
