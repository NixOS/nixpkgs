{
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10n2v2al68rsq5ghrdp7cpycsc1q0m19fcd8cd5i528n30nl23iw";
      type = "gem";
    };
    version = "5.2.2.1";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lxqzxa728dqg42yw0q4hqkaawqagiw1k0392an2ghjfgb16pafx";
      type = "gem";
    };
    version = "5.2.2.1";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0832vlx37rly8ryfgi01b20mld8b3bv9cg62n5wax4zpzgn6jdxb";
      type = "gem";
    };
    version = "5.2.2.1";
  };
  active_model_serializers = {
    dependencies = ["activemodel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k3mgia2ahh7mbk30hjq9pzqbk0kh281s91kq2z6p555nv9y6l3k";
      type = "gem";
    };
    version = "0.8.4";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zma452lc3qp4a7r10zbdmsci0kv9a3gnk4da2apbdrc8fib5mr3";
      type = "gem";
    };
    version = "5.2.2.1";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1idmvqvpgri34k31s44pjb88rc3jad3yxra7fd1kpidpnv5f3v65";
      type = "gem";
    };
    version = "5.2.2.1";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c5cz9v7ggpqjxf0fqs1xhy1pb9m34cp31pxarhs9aqb71qjl98v";
      type = "gem";
    };
    version = "5.2.2.1";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "161bp4p01v1a1lvszrhd1a02zf9x1p1l1yhw79a3rix1kvzkkdqb";
      type = "gem";
    };
    version = "5.2.2.1";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
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
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gdiwkg24jpx5f3bkw6vchgliicn6v9bpm09j0dldaxsca66q0wy";
      type = "gem";
    };
    version = "1.0.1";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13ikzgkafzcn6gb34cd2imyvnsxvi3ndqbm01i3l6zk6fv66kknl";
      type = "gem";
    };
    version = "1.138.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rx2f8bz536zkd2x3vbq0whfg28knmibhsrz7cj6h9j14rr822pi";
      type = "gem";
    };
    version = "3.46.1";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "195f12iygwlxj720gyikggdlxgfh4j371qa8dn7x4kwgq732b1fn";
      type = "gem";
    };
    version = "1.13.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mpf7v5n19ymq585xr0s47d9hcjc6crx5vi99s2ivcl79k1xj87d";
      type = "gem";
    };
    version = "1.30.1";
  };
  aws-sdk-sns = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1acsldql5x0wqzkbbhxl3svbcafjkl1zrnrzdwfqjbi5xj8hcy7y";
      type = "gem";
    };
    version = "1.9.0";
  };
  aws-sigv4 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hzndv113i6bgy2n72i5l3mwn8vjnb6hhjxfkpn9mm2p5ra77yk7";
      type = "gem";
    };
    version = "1.0.3";
  };
  barber = {
    dependencies = ["ember-source" "execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnn9q31jiz5wjyn49r3zjmh8ffx9x6asbmvmg15ppsxd9lkvjb9";
      type = "gem";
    };
    version = "0.12.0";
  };
  better_errors = {
    dependencies = ["coderay" "erubi" "rack"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pqnxxsqqs7vnqvamk5bzs84dv584g9s0qaf2vqb1v2aj5dabcg7";
      type = "gem";
    };
    version = "2.5.0";
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
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g6r784lmjfhwi046w82phsk244byq9wkj1q3lddwxg9z559bmhy";
      type = "gem";
    };
    version = "1.3.2";
  };
  builder = {
    groups = ["default" "development" "test"];
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
  byebug = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10znc1hjv8n686hhpl08f3m2g6h08a4b83nxblqwy2kqamkxcqf8";
      type = "gem";
    };
    version = "10.0.2";
  };
  certified = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1706p6p0a8adyvd943af2a3093xakvislgffw3v9dvp7j07dyk5a";
      type = "gem";
    };
    version = "1.0.0";
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
  claide = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0az54rp691hc42yl1xyix2cxv58byhaaf4gxbpghvvq29l476rzc";
      type = "gem";
    };
    version = "1.0.2";
  };
  claide-plugins = {
    dependencies = ["cork" "nap" "open4"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bhw5j985qs48v217gnzva31rw5qvkf7qj8mhp73pcks0sy7isn7";
      type = "gem";
    };
    version = "0.9.2";
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
  colored2 = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jlbqa9q4mvrm73aw9mxh23ygzbjiqwisl32d8szfb5fxvbjng5i";
      type = "gem";
    };
    version = "3.1.2";
  };
  concurrent-ruby = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ixcx9pfissxrga53jbdpza85qd5f6b5nq1sfqa9rnfq82qnlbp1";
      type = "gem";
    };
    version = "1.1.4";
  };
  connection_pool = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lflx29mlznf1hn0nihkgllzbj8xp5qasn8j7h838465pi399k68";
      type = "gem";
    };
    version = "2.2.2";
  };
  cork = {
    dependencies = ["colored2"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g6l780z1nj4s3jr11ipwcj8pjbibvli82my396m3y32w98ar850";
      type = "gem";
    };
    version = "0.3.0";
  };
  cppjieba_rb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sslff7yy8jvp4rcn1b6jn9v0d3iibb68i79shgd94rs2yq8k117";
      type = "gem";
    };
    version = "0.3.3";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bpxzy6gjw9ggjynlxschbfsgmx8lv3zw1azkjvnb8b9i895dqfi";
      type = "gem";
    };
    version = "1.0.4";
  };
  danger = {
    dependencies = ["claide" "claide-plugins" "colored2" "cork" "faraday" "faraday-http-cache" "git" "kramdown" "no_proxy_fix" "octokit" "terminal-table"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x7n0s4qw19dknkbzvgp62pkbhd1j1pmsk3vkhii1cprizyr857d";
      type = "gem";
    };
    version = "5.13.0";
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
  discourse-ember-source = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ar1fwn38g9ry8fxs705a08b2x1dx7ivsfv46qydb4q6m8qlgd1i";
      type = "gem";
    };
    version = "3.7.0.2";
  };
  discourse_image_optim = {
    dependencies = ["exifr" "fspath" "image_size" "in_threads" "progress"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11nqmga5ygxyhjmsc07gsa0fwwyhdpwi20yyr4fnh263xs1xylvv";
      type = "gem";
    };
    version = "0.26.2";
  };
  docile = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04d2izkna3ahfn6fwq4xrcafa715d3bbqczxm16fq40fqy87xn17";
      type = "gem";
    };
    version = "1.3.1";
  };
  email_reply_trimmer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pnirdmkh7cpss5vvlh7rbmihcx72mjpsb4y1bjil64ig433lpm1";
      type = "gem";
    };
    version = "0.1.12";
  };
  ember-data-source = {
    dependencies = ["ember-source"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1803nh3knvwl12h63jd48qvbbrp42yy291wcb35960daklip0fd8";
      type = "gem";
    };
    version = "3.0.2";
  };
  ember-handlebars-template = {
    dependencies = ["barber" "sprockets"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wxj3vi4xs3vjxrdbzi4j4w6vv45r5dkz2rg2ldid3p8dp3irlf4";
      type = "gem";
    };
    version = "0.8.0";
  };
  ember-rails = {
    dependencies = ["active_model_serializers" "ember-data-source" "ember-handlebars-template" "ember-source" "jquery-rails" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "059qrwjlq6zba8g86y3mkav95vzr8hadvn6sajvid1vn6bgj31lb";
      type = "gem";
    };
    version = "0.18.5";
  };
  ember-source = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sixy30ym9j2slhlr0lfq943g958w8arlb0lsizh59iv1w5gmxxy";
      type = "gem";
    };
    version = "2.18.2";
  };
  erubi = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kagnf6ziahj0d781s6ryy6fwqwa3ad4xbzzj84p9m4nv4c2jir1";
      type = "gem";
    };
    version = "1.8.0";
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
  execjs = {
    groups = ["assets" "default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yz55sf2nd3l666ms6xr18sm2aggcvmb8qr3v53lr4rir32y1yp1";
      type = "gem";
    };
    version = "2.7.0";
  };
  exifr = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16a93gbcg38i2p8kca4mwwdpasg0frbnv0m1572jnjpw4771asqb";
      type = "gem";
    };
    version = "1.3.5";
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
  fakeweb = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a09z9nb369bvwpghncgd5y4f95lh28w0q258srh02h22fz9dj8y";
      type = "gem";
    };
    version = "1.3.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s72m05jvzc1pd6cw1i289chas399q0a14xrwg4rvkdwy7bgzrh0";
      type = "gem";
    };
    version = "0.15.4";
  };
  faraday-http-cache = {
    dependencies = ["faraday"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hcp58ig28cbkzzv5is9dcyv1999981rhkdwd993l4l85ybiv2cm";
      type = "gem";
    };
    version = "1.3.1";
  };
  fast_blank = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16s1ilyvwzmkcgmklbrn0c2pch5n02vf921njx0bld4crgdr6z56";
      type = "gem";
    };
    version = "1.0.0";
  };
  fast_xor = {
    dependencies = ["rake" "rake-compiler"];
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n1p3bvvj92p38rgddrnxyhbxp1jlx6ky4r3fdzva8jg3z3wlpli";
      type = "gem";
    };
    version = "1.1.3";
  };
  fast_xs = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iydzaqmvqq7ncxkr182aybkk6xap0cb2w9amr73vbdxi2qf3wjz";
      type = "gem";
    };
    version = "0.8.0";
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
    groups = ["default" "development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j8pzj8raxbir5w5k6s7a042sb5k02pg0f8s4na1r5lan901j00p";
      type = "gem";
    };
    version = "1.10.0";
  };
  flamegraph = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p785nmhdzbwj0qpxn5fzrmr4kgimcds83v4f95f387z6w3050x6";
      type = "gem";
    };
    version = "0.9.5";
  };
  fspath = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vjn9sy4hklr2d5wxmj5x1ry31dfq3sjp779wyprb3nbbdmra1sc";
      type = "gem";
    };
    version = "3.1.0";
  };
  gc_tracer = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yv3mp8lx74lfzs04fd5h4g89209iwhzpc407y35p7cmzgx6a4kv";
      type = "gem";
    };
    version = "1.5.1";
  };
  git = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bf83icwypi3p3pd97vlqbnp3hvf31ncd440m9kh9y7x6yk74wyh";
      type = "gem";
    };
    version = "1.5.0";
  };
  globalid = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02smrgdi11kziqi9zhnsy9i6yr2fnxrqlv3lllsvdjki3cd4is38";
      type = "gem";
    };
    version = "0.4.1";
  };
  guess_html_encoding = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16700fk6kmif3q3kpc1ldhy3nsc9pkxlgl8sqhznff2zjj5lddna";
      type = "gem";
    };
    version = "0.0.11";
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
  highline = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ib7jp85xjc4gh4jg0wyzllm46hwv8p0w1m4c75pbgi41fps50y";
      type = "gem";
    };
    version = "1.7.10";
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
  http_accept_language = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vg6vaiv1d8dfynplyyifk26hjbygajqpz9azng04v9hd8l16isv";
      type = "gem";
    };
    version = "2.0.5";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "073fzya59mnzi4jlqc6nhl7kx31w49qpshis27j4qyyjjvl1nrgv";
      type = "gem";
    };
    version = "1.5.3";
  };
  image_size = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zrn2mqaf1kk548wn1y35i1a6kwh3320q62m929kn9m8sqpy4fk7";
      type = "gem";
    };
    version = "1.5.0";
  };
  in_threads = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cxsvxs0xr3hz37pxsyx9wbhwvzx5j88cqab6mzihcizv91drk4a";
      type = "gem";
    };
    version = "1.5.0";
  };
  jaro_winkler = {
    groups = ["default" "development" "test"];
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
  jquery-rails = {
    dependencies = ["rails-dom-testing" "railties" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17201sb8ddwy4yprizmqabq1kfx3m9c53p0yqngn63m07jjcpnh8";
      type = "gem";
    };
    version = "4.3.3";
  };
  json = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sx97bm9by389rbzv8r1f43h06xcz8vwi3h5jv074gvparql7lcx";
      type = "gem";
    };
    version = "2.2.0";
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
  kgio = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1528pyj1szzzp3pgj05fzjd36qjrxm9yj2x5radc9p1z7vl67y50";
      type = "gem";
    };
    version = "2.11.2";
  };
  kramdown = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n1c4jmrh5ig8iv1rw81s4mw4xsp4v97hvf8zkigv4hn5h542qjq";
      type = "gem";
    };
    version = "1.17.0";
  };
  libv8 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a8zn98br8najdvd9f6c0w29rz6z0k64d7dp63sgnfwzlf745i2m";
      type = "gem";
    };
    version = "6.7.288.46.1";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify" "ruby_dep"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v5mrnfqm6sgm8xn2v5swxsn1wlmq7rzh2i48d4jzjsc7qvb6mx";
      type = "gem";
    };
    version = "3.1.5";
  };
  lograge = {
    dependencies = ["actionpack" "activesupport" "railties" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00lcn7s3slfn32di4qwlx2yj5f9r2pcnd0naxrvqqwypcg1z2sdd";
      type = "gem";
    };
    version = "0.10.0";
  };
  logstash-event = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bk7fhhryjxp1klr3hq6i6srrc21wl4p980bysjp0w66z9hdr9w9";
      type = "gem";
    };
    version = "1.2.02";
  };
  logstash-logger = {
    dependencies = ["logstash-event"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nh0jgz4rl46axqb9l0fa866kh34wb7yf11qc3j30xhprdqb8yjp";
      type = "gem";
    };
    version = "0.26.1";
  };
  logster = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c054wly4r1r2wmnzjsss8x88js1xshnifi7qb0lwxb16b1p7l43";
      type = "gem";
    };
    version = "2.3.0";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ccsid33xjajd0im2xv941aywi58z7ihwkvaf1w2bv89vn5bhsjg";
      type = "gem";
    };
    version = "2.2.3";
  };
  lru_redux = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yxghzg7476sivz8yyr9nkak2dlbls0b89vc2kg52k0nmg6d0wgf";
      type = "gem";
    };
    version = "1.1.0";
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
  memory_profiler = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qir6bc2rw6lac6fsjhnspqyr01sh12d75dkd630qknjwvrrq8kj";
      type = "gem";
    };
    version = "0.9.12";
  };
  message_bus = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wdk51hj6q2sqayx5gf891mv1bwlkj4icm3ryylf5p739h9wb9nx";
      type = "gem";
    };
    version = "2.2.0";
  };
  metaclass = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hp99y2b1nh0nr8pc398n3f8lakgci6pkrg4bf2b2211j1f6hsc5";
      type = "gem";
    };
    version = "0.0.4";
  };
  method_source = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g5i4w0dmlhzd18dijlqw5gk27bv6dj2kziqzrzb7mpgxgsd1sf2";
      type = "gem";
    };
    version = "0.8.2";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q4pshq387lzv9m39jv32vwb8wrq3wc4jwgl4jk209r4l33v09d3";
      type = "gem";
    };
    version = "1.0.1";
  };
  mini_portile2 = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zplpfw3knqifj9bpf604rb3wc1vhq6363pd6lvhayng8wql5vy";
      type = "gem";
    };
    version = "2.4.0";
  };
  mini_racer = {
    dependencies = ["libv8"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c3a61l805slbvqscmc2wbv6bvw37gs2dchyhbfql178mnb7vnwg";
      type = "gem";
    };
    version = "0.2.4";
  };
  mini_scheduler = {
    dependencies = ["sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rdsj3zqv81cj4jjndbv5gzb8cx3ywijkmkwdyy873q1i254a86m";
      type = "gem";
    };
    version = "0.9.1";
  };
  mini_sql = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hn8lj1b0p1jzji8fv23519fcd0dc5bm57ksi9cbnzhxn98q5kq4";
      type = "gem";
    };
    version = "0.2.1";
  };
  mini_suffix = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bxd1fgzb20gvfvhbkrxym9fr7skm5x6fzvqfg4a0jijb34ww50h";
      type = "gem";
    };
    version = "0.3.0";
  };
  minitest = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0icglrhghgwdlnzzp4jf76b0mbc71s80njn5afyfjn4wqji8mqbq";
      type = "gem";
    };
    version = "5.11.3";
  };
  mocha = {
    dependencies = ["metaclass"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hil2164qa3j1h9p83ai3la1gl3131ddj4il56vp2q8sfqvahc6q";
      type = "gem";
    };
    version = "1.5.0";
  };
  mock_redis = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p4bwj1d0v9fdx3fymr9r5p47l8z1w7r489l2pg9hzgym5mvz6pv";
      type = "gem";
    };
    version = "0.18.0";
  };
  moneta = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pv38ly26fhilw27bsyi3x9fvnhybqf2r9w5p693ifhrcf6w7vik";
      type = "gem";
    };
    version = "1.1.0";
  };
  msgpack = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0031gd2mjyba6jb7m97sqa149zjkr0vzn2s2gpb3m9nb67gqkm13";
      type = "gem";
    };
    version = "1.2.6";
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
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  mustache = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1698xpwxmfvj39ii5vv8a4aka54p3fpk5i4rf8z9lfxrh4948rbk";
      type = "gem";
    };
    version = "1.1.0";
  };
  nap = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xm5xssxk5s03wjarpipfm39qmgxsalb46v1prsis14x1xk935ll";
      type = "gem";
    };
    version = "1.1.0";
  };
  no_proxy_fix = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "006dmdb640v1kq0sll3dnlwj1b0kpf3i1p27ygyffv8lpcqlr6sf";
      type = "gem";
    };
    version = "0.1.2";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09zll7c6j7xr6wyvh5mm5ncj6pkryp70ybcsxdbw1nyphx5dh184";
      type = "gem";
    };
    version = "1.10.1";
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
  oauth2 = {
    dependencies = ["faraday" "jwt" "multi_json" "multi_xml" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0av6nlb5y2sm6m8fx669ywrqa9858yqaqfqzny75nqp3anag89qh";
      type = "gem";
    };
    version = "1.4.1";
  };
  octokit = {
    dependencies = ["sawyer"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yh0yzzqg575ix3y2l2261b9ag82gv2v4f1wczdhcmfbxcz755x6";
      type = "gem";
    };
    version = "4.13.0";
  };
  oj = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0swv2ryjgbcyrisb2arf88rz0pf8d8f8g7iihc2fhz96a1h985n0";
      type = "gem";
    };
    version = "3.7.8";
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
  omniauth-facebook = {
    dependencies = ["omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nll6vvn432750mydvjipy2sq3qdp0knkwp23s7qnki7v7w1f0yj";
      type = "gem";
    };
    version = "5.0.0";
  };
  omniauth-github = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yg7k4p95ybcsii17spqarl8rpfzkq0kb19ab6wl4lc922zgfbqc";
      type = "gem";
    };
    version = "1.3.0";
  };
  omniauth-google-oauth2 = {
    dependencies = ["jwt" "omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03v2gqpsbdhkqaxhvzr83za885awm6pgskv3mkyfvang7mr321df";
      type = "gem";
    };
    version = "0.6.0";
  };
  omniauth-instagram = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07vgcjsl2q3zcpvkzsq4nx0blxnklb1dp9va4dj9sw8jk3v5w3ap";
      type = "gem";
    };
    version = "1.3.0";
  };
  omniauth-oauth = {
    dependencies = ["oauth" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n5vk4by7hkyc09d9blrw2argry5awpw4gbw1l4n2s9b3j4qz037";
      type = "gem";
    };
    version = "1.1.0";
  };
  omniauth-oauth2 = {
    dependencies = ["oauth2" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11mi36l9d97r77q99jnafdc1yaa0a9wahhpp7dj7ank8q52g7g79";
      type = "gem";
    };
    version = "1.6.0";
  };
  omniauth-openid = {
    dependencies = ["omniauth" "rack-openid"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qjplj47m5yxw67vh8p2g20sdl90ivbync4a985k8wl0a8swwfw2";
      type = "gem";
    };
    version = "1.0.1";
  };
  omniauth-twitter = {
    dependencies = ["omniauth-oauth" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r5j65hkpgzhvvbs90id3nfsjgsad6ymzggbm7zlaxvnrmvnrk65";
      type = "gem";
    };
    version = "1.4.0";
  };
  onebox = {
    dependencies = ["htmlentities" "moneta" "multi_json" "mustache" "nokogiri" "sanitize"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rpl2gzsd2qa7rd63k5kcml51na80k2nya2xm04wiaa2vp9j0q25";
      type = "gem";
    };
    version = "1.8.83";
  };
  open4 = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cgls3f9dlrpil846q0w7h66vsc33jqn84nql4gcqkk221rh7px1";
      type = "gem";
    };
    version = "1.3.4";
  };
  openid-redis-store = {
    dependencies = ["redis" "ruby-openid"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15f6rd1jis8dybqasi487hqlvzqpknprh7yh35sxvmbczq69q8hi";
      type = "gem";
    };
    version = "0.0.2";
  };
  optimist = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05jxrp3nbn5iilc1k7ir90mfnwc5abc9h78s5rpm3qafwqxvcj4j";
      type = "gem";
    };
    version = "3.0.0";
  };
  parallel = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "005shcy8dabc7lwydpkbhd3fx8bfqzvsj6g04r90mx0wky10lz84";
      type = "gem";
    };
    version = "1.13.0";
  };
  parallel_tests = {
    dependencies = ["parallel"];
    groups = ["development" "test"];
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
      sha256 = "1hhz2k5417vr2k1llwqgjdnmyrhlpqicy0y2arr6r1gp04fg9wlm";
      type = "gem";
    };
    version = "2.6.0.0";
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
  powerpack = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r51d67wd467rpdfl6x43y84vwm8f5ql9l9m85ak1s2sp3nc5hyv";
      type = "gem";
    };
    version = "0.1.2";
  };
  progress = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yrzq4v5sp7cg4nbgqh11k3d1czcllfz98dcdrxrsjxwq5ziiw0p";
      type = "gem";
    };
    version = "3.5.0";
  };
  pry = {
    dependencies = ["coderay" "method_source" "slop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05xbzyin63aj2prrv8fbq2d5df2mid93m81hz5bvf2v4hnzs42ar";
      type = "gem";
    };
    version = "0.10.4";
  };
  pry-nav = {
    dependencies = ["pry"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qrvzyp9c6s7lavfl2sx298nr3s4xhgy6c6fdh0p03pddl256prd";
      type = "gem";
    };
    version = "0.2.4";
  };
  pry-rails = {
    dependencies = ["pry"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k2d43bwmqbswfra4fkadjjbszwb11pr7qdkma91qrcrk62wqxvy";
      type = "gem";
    };
    version = "0.3.6";
  };
  public_suffix = {
    groups = ["default" "test"];
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
      sha256 = "1k7dqxnq0dnf5rxkgs9rknclkn3ah7lsdrk6nrqxla8qzy31wliq";
      type = "gem";
    };
    version = "3.12.0";
  };
  r2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wk0p55zp3l96xy5ps28b33dn5z0jwsjl74bwfdn6z81pzjs5sfk";
      type = "gem";
    };
    version = "0.2.7";
  };
  rack = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pcgv8dv4vkaczzlix8q3j68capwhk420cddzijwqgi2qb4lm1zm";
      type = "gem";
    };
    version = "2.0.6";
  };
  rack-mini-profiler = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1la5sa2k7hdfphk074z2pa8sgc12inh5527lck9d65pp1ajdm63m";
      type = "gem";
    };
    version = "1.0.2";
  };
  rack-openid = {
    dependencies = ["rack" "ruby-openid"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dr5hfqp1754ny19sgrf68cnaydqvyx299987qgwzsa0k3nk0fhv";
      type = "gem";
    };
    version = "1.3.1";
  };
  rack-protection = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15167q25rmxipqwi6hjqj3i1byi9iwl3xq9b7mdar7qiz39pmjsk";
      type = "gem";
    };
    version = "2.0.5";
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
      sha256 = "1gv7vr5d9g2xmgpjfq4nxsqr70r9pr042r9ycqqnfvw5cz9c7jwr";
      type = "gem";
    };
    version = "1.0.4";
  };
  rails_multisite = {
    dependencies = ["activerecord" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04anpaxslr96zz3lqsh5wvh0h359g55niqgy7yb77cv4y7qsb0rw";
      type = "gem";
    };
    version = "2.0.6";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "method_source" "rake" "thor"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0al6mvh2jvr3n7cxkx0yvhgiiarby6gxc93vl5xg1yxkvx27qzd6";
      type = "gem";
    };
    version = "5.2.2.1";
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
  raindrops = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qpbd9jif40c53fz2r0l8khfl016y8s8bkx37ibcaafclbl3xygp";
      type = "gem";
    };
    version = "0.19.0";
  };
  rake = {
    groups = ["default" "development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sy5a7nh6xjdc9yhcw31jji7ssrf9v5806hn95gbrzr998a2ydjn";
      type = "gem";
    };
    version = "12.3.2";
  };
  rake-compiler = {
    dependencies = ["rake"];
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xpdi4w8zaklk1i9ps8g3k0icw3v5fcks092l84w28rgrpx82qip";
      type = "gem";
    };
    version = "1.0.4";
  };
  rb-fsevent = {
    groups = ["development" "test"];
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
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fs7hxm9g6ywv2yih83b879klhc4fs8i0p9166z795qmd77dk0a4";
      type = "gem";
    };
    version = "0.10.0";
  };
  rbtrace = {
    dependencies = ["ffi" "msgpack" "optimist"];
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lwsq08i0aj8na5q5ba3gg02sx3wl58fi6m52svl5p7cy56ycdwi";
      type = "gem";
    };
    version = "0.4.11";
  };
  rchardet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1isj1b3ywgg2m1vdlnr41lpvpm3dbyarf1lla4dfibfmad9csfk9";
      type = "gem";
    };
    version = "1.8.0";
  };
  redis = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y1l2gm1n4i29vgmn37jh2bj4znncpraw1gymjny95hgxfm5wzwg";
      type = "gem";
    };
    version = "4.0.1";
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
  request_store = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1963330z03fk382fi8y231ygcbnh86m91dqlp5rh1mwy9ihzzl6d";
      type = "gem";
    };
    version = "1.4.1";
  };
  rinku = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "149r18w7wv8lc8nlb5a6rvm7m8gj7iydkvpjri6ypljplp2pq2f7";
      type = "gem";
    };
    version = "2.0.4";
  };
  rotp = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r00j119v6im268k58fhhys5z6j8fdm5lcdmyplqdw1gn0bqgsg7";
      type = "gem";
    };
    version = "3.3.1";
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
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0134g96wzxjlig2gxzd240gm2dxfw8izcyi2h6hjmr40syzcyx01";
      type = "gem";
    };
    version = "3.7.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zvjbymx3avxm3lf8v4gka3a862vnaxldmwvp6767bpy48nhnvjj";
      type = "gem";
    };
    version = "3.7.1";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fw06wm8jdj8k7wrb8xmzj0fr1wjyb0ya13x31hidnyblm41hmvy";
      type = "gem";
    };
    version = "3.7.0";
  };
  rspec-html-matchers = {
    dependencies = ["nokogiri" "rspec"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vc7mpxn8jqfqyyv0k37jmlxr5vqgmd157m6mprrwc7k2vpgyz1q";
      type = "gem";
    };
    version = "0.9.1";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b02ya3qhqgmcywqv4570dlhav70r656f7dmvwg89whpkq1z1xr3";
      type = "gem";
    };
    version = "3.7.0";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cdcnbv5dppwy3b4jdp5a0wd9m07a8wlqwb9yazn8i7k1k2mwgvx";
      type = "gem";
    };
    version = "3.7.2";
  };
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nl30xb6jmcl0awhqp6jycl01wdssblifwy921phfml70rd9flj1";
      type = "gem";
    };
    version = "3.7.1";
  };
  rtlit = {
    groups = ["assets"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0srfh7cl95srjiwbyc9pmn3w739zlvyj89hyj0bm7g92zrsd27qm";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubocop = {
    dependencies = ["jaro_winkler" "parallel" "parser" "powerpack" "rainbow" "ruby-progressbar" "unicode-display_width"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pq00qwlmcv52dbhgbk534ggwn1ny9k3sq3vfb1zk3r4psnqz2jy";
      type = "gem";
    };
    version = "0.63.1";
  };
  ruby-openid = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmg0vjsv7d0vxidssmxmncpzx5w3j3llncn4fzymvvcddn0h1ps";
      type = "gem";
    };
    version = "2.7.0";
  };
  ruby-prof = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02z4lh1iv1d8751a1l6r4hfc9mp61gf80g4qc4l6gbync3j3hf2c";
      type = "gem";
    };
    version = "0.17.0";
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
  ruby-readability = {
    dependencies = ["guess_html_encoding" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15ivhbry7hf82lww1bzcrwfyjymijfb3rb0wdd32g2z0942wdspa";
      type = "gem";
    };
    version = "0.7.0";
  };
  ruby_dep = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c1bkl97i9mkcvkn1jks346ksnvnnp84cs22gwl0vd7radybrgy5";
      type = "gem";
    };
    version = "1.5.0";
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
  sassc = {
    dependencies = ["ffi" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sr4825rlwsrl7xrsm0sgalcpf5zgp4i56dbi3qxfa9lhs8r6zh4";
      type = "gem";
    };
    version = "2.0.1";
  };
  sassc-rails = {
    dependencies = ["railties" "sassc" "sprockets" "sprockets-rails" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18mgdjxdzpbw92zrllynxw7jn7yihi85j3dg7i4f6c39w1scqkbn";
      type = "gem";
    };
    version = "2.1.0";
  };
  sawyer = {
    dependencies = ["addressable" "faraday"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sv1463r7bqzvx4drqdmd36m7rrv6sf1v3c6vswpnq3k6vdw2dvd";
      type = "gem";
    };
    version = "0.8.1";
  };
  seed-fu = {
    dependencies = ["activerecord" "activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y7lzcshsq6i20qn1p8zczir4fivr6nbl1km91ns320vvh92v43d";
      type = "gem";
    };
    version = "2.3.9";
  };
  shoulda = {
    dependencies = ["shoulda-context" "shoulda-matchers"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0csmf15a7mcinfq54lfa4arp0f4b2jmwva55m0p94hdf3pxnjymy";
      type = "gem";
    };
    version = "3.5.0";
  };
  shoulda-context = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l0ncsxycb4s8n47dml97kdnixw4mizljbkwqc3rh05r70csq9bc";
      type = "gem";
    };
    version = "1.2.2";
  };
  shoulda-matchers = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d3ryqcsk1n9y35bx5wxnqbgw4m8b3c79isazdjnnbg8crdp72d0";
      type = "gem";
    };
    version = "2.8.0";
  };
  sidekiq = {
    dependencies = ["connection_pool" "rack" "rack-protection" "redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1caiq5f5z5vzfria554n04pcbwc8zixf1fpavaksly9zywr3pc29";
      type = "gem";
    };
    version = "5.2.5";
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
  slop = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
      type = "gem";
    };
    version = "3.6.0";
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
  sshkey = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g02lh50jd5z4l9bp7xirnfn3n1dh9lr06dv3xh0kr3yhsny059h";
      type = "gem";
    };
    version = "1.9.0";
  };
  stackprof = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v7mkl4ng2is5h0glivhcjjkkj2shq1qzx9sg9shw9nn8xvg7i4w";
      type = "gem";
    };
    version = "0.2.12";
  };
  terminal-table = {
    dependencies = ["unicode-display_width"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1512cngw35hsmhvw4c05rscihc59mnj09m249sm9p3pik831ydqk";
      type = "gem";
    };
    version = "1.8.0";
  };
  thor = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    version = "0.20.3";
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
      sha256 = "0020mrgdf11q23hm1ddd6fv691l51vi10af00f137ilcdb2ycfra";
      type = "gem";
    };
    version = "2.0.8";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fjx9j327xpkkdlxwmkl3a8wqj7i4l4jwlrv3z13mg95z9wl253z";
      type = "gem";
    };
    version = "1.2.5";
  };
  uglifier = {
    dependencies = ["execjs"];
    groups = ["assets"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xb32ygg8sdyqi7y0gda5rinx1y76n4wf7vj8ifb4n44q3gkb7gw";
      type = "gem";
    };
    version = "4.1.20";
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
      sha256 = "0bq528fibi8s0jmxz0xzlgzggdq0x4fx46wfqz49478pv8gb2diq";
      type = "gem";
    };
    version = "1.4.1";
  };
  unicorn = {
    dependencies = ["kgio" "raindrops"];
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qfhvzs4i6ja1s43j8p1kfbzm10n7a02ngki30a38y5m46a2qrak";
      type = "gem";
    };
    version = "5.4.1";
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
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03994dxs4xayvkxqp01dd1ivhg4xxx7z35f7cxw7y2mwj3xn24ib";
      type = "gem";
    };
    version = "3.4.2";
  };
  webpush = {
    dependencies = ["hkdf" "jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1id7i4gdqck8wj6x22q8dljynvznvwn9f0pgi8h8jiy5dm7m0cf2";
      type = "gem";
    };
    version = "0.3.6";
  };
}