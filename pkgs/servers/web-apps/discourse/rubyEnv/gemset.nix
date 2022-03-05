{
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "activesupport" "mail" "rails-dom-testing"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00s07l2ac5igch1g2rpa0linmiq7mhgk6v6wxkckg8gbiqijb592";
      type = "gem";
    };
    version = "6.1.4.1";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xgysqnibjsy6kdz10x2xb3kwa6lssiqhh0zggrbgs31ypwhlpia";
      type = "gem";
    };
    version = "6.1.4.1";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yf4ic5kl324rs0raralpwx24s6hvvdzxfhinafylf8f3x7jj23z";
      type = "gem";
    };
    version = "6.1.4.1";
  };
  actionview_precompiler = {
    dependencies = ["actionview"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07dx8vkwig8han4zccs0chahcf9ibd4abzx9n56qah8zak5cyrhd";
      type = "gem";
    };
    version = "0.2.3";
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
      sha256 = "1q7c0i0kwarxgcbxk71wa9jnlg45grbxmhlrh7dk9bgcv7r7r7hn";
      type = "gem";
    };
    version = "6.1.4.1";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16ixam4lni8b5lgx0whnax0imzh1dh10fy5r9pxs52n83yz5nbq3";
      type = "gem";
    };
    version = "6.1.4.1";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ccgvlj767ybps3pxlaa4iw77n7wbriw2sr8754id3ngjfap08ja";
      type = "gem";
    };
    version = "6.1.4.1";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19gx1jcq46x9d1pi1w8xq0bgvvfw239y4lalr8asm291gj3q3ds4";
      type = "gem";
    };
    version = "6.1.4.1";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "022r3m9wdxljpbya69y2i3h9g3dhhfaqzidf95m6qjzms792jvgp";
      type = "gem";
    };
    version = "2.8.0";
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
      sha256 = "04nc8x27hlzlrr5c2gn7mar4vdr0apw5xg22wp6m8dx3wqr04a0y";
      type = "gem";
    };
    version = "2.4.2";
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
      sha256 = "1jx44f1hc41712k8fqmzrbpqs2j9yl0msdqcmmfp0pirkbqw6ri0";
      type = "gem";
    };
    version = "1.516.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d44wgbzlwc6gb2ql9cayljdwhlvz9byp2grk0n9favb7rq42fwc";
      type = "gem";
    };
    version = "3.121.2";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0407yggwsy89fzh387vq3af5azplci5v0a8y97h7r6da4jrv1ksm";
      type = "gem";
    };
    version = "1.44.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q28bdmpm2c2fw9wh00zhqxnb8p2nzdfi5l6wwa6bl63fm28816h";
      type = "gem";
    };
    version = "1.96.1";
  };
  aws-sdk-sns = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s2ggpwg7v0s0f4bw3887r5y92cbnrjld53lm69irqmx0h7q2564";
      type = "gem";
    };
    version = "1.46.0";
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
  barber = {
    dependencies = ["ember-source" "execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07rnlbh7kgamcbnl1sqlcdrjj8src4qc687klqq4a3vqq2slnscx";
      type = "gem";
    };
    version = "0.12.2";
  };
  better_errors = {
    dependencies = ["coderay" "erubi" "rack"];
    groups = ["development"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11220lfzhsyf5fcril3qd689kgg46qlpiiaj00hc9mh4mcbc3vrr";
      type = "gem";
    };
    version = "2.9.1";
  };
  binding_of_caller = {
    dependencies = ["debug_inspector"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "078n2dkpgsivcf0pr50981w95nfc2bsrp3wpf9wnxz1qsp8jbb9s";
      type = "gem";
    };
    version = "1.0.0";
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
      sha256 = "19i4x2nascd74ahcvmrsnf03cygh1y4c9yf8rcv91fv0mcxpvb9n";
      type = "gem";
    };
    version = "1.9.4";
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
      sha256 = "0q90zk8di7a12by3d81nl78yy90rdml77vi3waxmgzqhvs6na4vj";
      type = "gem";
    };
    version = "7.0.1";
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
  cbor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0511idr8xps9625nh3kxr68sdy6l3xy2kcz7r57g47fxb1v18jj3";
      type = "gem";
    };
    version = "0.5.9.6";
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
      sha256 = "1znw5x86hmm9vfhidwdsijz8m38pqgmv98l9ryilvky0aldv7mc9";
      type = "gem";
    };
    version = "1.4.0";
  };
  coderay = {
    groups = ["default" "development"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  colored2 = {
    groups = ["default"];
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
      sha256 = "0nwad3211p7yv9sda31jmbyw6sdafzmdi2i2niaz6f0wk5nq9h0f";
      type = "gem";
    };
    version = "1.1.9";
  };
  connection_pool = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ffdxhgirgc86qb42yvmfj6v1v0x4lvi0pxn9zhghkff44wzra0k";
      type = "gem";
    };
    version = "2.2.5";
  };
  cose = {
    dependencies = ["cbor" "openssl-signature_algorithm"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gx239d2fracq9az74wfdwmp5zm7zpzkcgchwnv2ng33d8r33p3m";
      type = "gem";
    };
    version = "1.2.0";
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
    dependencies = ["rexml"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cr1kfpw3vkhysvkk3wg7c54m75kd68mbm9rs5azdjdq57xid13r";
      type = "gem";
    };
    version = "0.4.5";
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
  css_parser = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qbdgp36dhcyljhmfxrvbgp1ha9yqxhxgyg3sdm48y9m371jd2an";
      type = "gem";
    };
    version = "1.11.0";
  };
  debug_inspector = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01l678ng12rby6660pmwagmyg8nccvjfgs3487xna7ay378a59ga";
      type = "gem";
    };
    version = "1.1.0";
  };
  diff-lcs = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rwvjahnp7cpmracd8x732rjgnilqv2sx7d1gfrysslc3h039fa9";
      type = "gem";
    };
    version = "1.5.0";
  };
  diffy = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nrg7kpgz6cn1gv2saj2fa5sfiykamvd7vn9lw2v625k7pjwf31l";
      type = "gem";
    };
    version = "3.4.0";
  };
  discourse-ember-rails = {
    dependencies = ["active_model_serializers" "ember-data-source" "ember-handlebars-template" "ember-source" "jquery-rails" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ax5x2d6q6hkm7r58ai9p0sahlg842aqlm7dpv6svrfpnjlaz7sf";
      type = "gem";
    };
    version = "0.18.6";
  };
  discourse-ember-source = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q4wypjiqvjlwaif5z3pnv0z02rsiysx58d7iljrw8xx9sxwxn6x";
      type = "gem";
    };
    version = "3.12.2.3";
  };
  discourse-fonts = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q1q9fmqc7dir2nj94nai58h26zsh6fqmbr6hfax5d6xpy4pm1yf";
      type = "gem";
    };
    version = "0.0.9";
  };
  discourse_dev_assets = {
    dependencies = ["faker" "literate_randomizer"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c6cxrf6kvv4pg6fsig71dn5nrzy7jxbxmyi8206m1ijgpj8nddg";
      type = "gem";
    };
    version = "0.0.3";
  };
  docile = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lxqxgq71rqwj1lpl9q1mbhhhhhhdkkj7my341f2889pwayk85sz";
      type = "gem";
    };
    version = "1.4.0";
  };
  ecma-re-validator = {
    dependencies = ["regexp_parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kqci9ixr1jfp2aaq5lsyz5lkn37z2k94ww9d2hyrd8ncrhrhx8f";
      type = "gem";
    };
    version = "0.4.0";
  };
  email_reply_trimmer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jgcxifm48xq5dz9k47q43pqm5bfnf14l62l3bqhmv8f6z8dw4ki";
      type = "gem";
    };
    version = "0.1.13";
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
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09l8lz3j00m898li0yfsnb6ihc63rdvhw3k5xczna5zrjk104f2l";
      type = "gem";
    };
    version = "1.10.0";
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
  execjs = {
    groups = ["assets" "default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "121h6af4i6wr3wxvv84y53jcyw2sk71j5wsncm6wq6yqrwcrk4vd";
      type = "gem";
    };
    version = "2.8.1";
  };
  exifr = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mylhwmh6n4xihxr9s3zj0lc286f5maxbqd4dgk3paqnd7afz88s";
      type = "gem";
    };
    version = "1.3.9";
  };
  fabrication = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09b6gyqf76iflxh9v69k59xhxmrx1akdp2mbg8k8nb5rxy0sz0v6";
      type = "gem";
    };
    version = "2.24.0";
  };
  faker = {
    dependencies = ["i18n"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hb9wfxyb4ss2vl2mrj1zgdk7dh4yaxghq22gbx62yxj5yb9w4zw";
      type = "gem";
    };
    version = "2.19.0";
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
    dependencies = ["faraday-em_http" "faraday-em_synchrony" "faraday-excon" "faraday-httpclient" "faraday-multipart" "faraday-net_http" "faraday-net_http_persistent" "faraday-patron" "faraday-rack" "faraday-retry" "ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y32gj994ll3zlcqjmwp78r7s03iiwayij6fz2pjpkfywgvp71s6";
      type = "gem";
    };
    version = "1.9.3";
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
  faraday-multipart = {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03qfi9020ynf7hkdiaq01sd2mllvw7fg4qiin3pk028b4wv23j3j";
      type = "gem";
    };
    version = "1.0.3";
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
  faraday-retry = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "153i967yrwnswqgvnnajgwp981k9p50ys1h80yz3q94rygs59ldd";
      type = "gem";
    };
    version = "1.0.3";
  };
  fast_blank = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "rbx";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1shpmamyzyhyxmv95r96ja5rylzaw60r19647d0fdm7y2h2c77r6";
      type = "gem";
    };
    version = "1.0.1";
  };
  fast_xs = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "rbx";
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
      sha256 = "0nnggg20za5vamdpkgrxxa32z33d8hf0g2bciswkhqnc6amb3yjr";
      type = "gem";
    };
    version = "2.2.6";
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
      sha256 = "1862ydmclzy1a0cjbvm8dz7847d9rch495ib0zb64y84d3xd4bkg";
      type = "gem";
    };
    version = "1.15.5";
  };
  fspath = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xcxikkrjv8ws328nn5ax5pyfjs8pn7djg1hks7qyb3yp6prpb5m";
      type = "gem";
    };
    version = "3.1.2";
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
  globalid = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n5yc058i8xhi1fwcp1w7mfi6xaxfmrifdb4r4hjfff33ldn8lqj";
      type = "gem";
    };
    version = "1.0.0";
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
  hana = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03cvrv2wl25j9n4n509hjvqnmwa60k92j741b64a1zjisr1dn9al";
      type = "gem";
    };
    version = "1.3.7";
  };
  hashdiff = {
    groups = ["default" "test"];
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
      sha256 = "1nh3arcrbz1rc1cr59qm53sdhqm137b258y8rcb4cvd3y98lwv4x";
      type = "gem";
    };
    version = "5.0.0";
  };
  highline = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yclf57n2j3cw8144ania99h1zinf8q3f5zrhqa754j6gl95rp9d";
      type = "gem";
    };
    version = "2.0.3";
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
      sha256 = "0d0nlfz9vm4jr1l6q0chx4rp2hrnrfbx3gadc1dz930lbbaz0hq0";
      type = "gem";
    };
    version = "2.1.1";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vdd1kii40qhbr9n8qx71k2gskq6rkl8ygy8hw5hfj8bb5a364xf";
      type = "gem";
    };
    version = "1.8.11";
  };
  image_optim = {
    dependencies = ["exifr" "fspath" "image_size" "in_threads" "progress"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l3n59w1cbvfg2srfa14g3jdqwbkf7l86g4qrgfz3qps7zi0drg7";
      type = "gem";
    };
    version = "0.31.1";
  };
  image_size = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "130yn87pcnr5sblssm88hnvg8hc76isgrnhlf1d9355zhv4i2hsz";
      type = "gem";
    };
    version = "3.0.1";
  };
  in_threads = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m71806p1gm4kxiz4gvkyr8qip16hifn2kdf926jz44jj6kc6bbs";
      type = "gem";
    };
    version = "1.5.4";
  };
  ipaddr = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s2cipiyhm1r8igc1n43py5p5r3rdz8lvagaa61jrm62prn7v5b2";
      type = "gem";
    };
    version = "1.2.3";
  };
  jmespath = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ylph158dc3ql6cvkik00ab6gf2k1rv2dii63m196xclhkzwfyan";
      type = "gem";
    };
    version = "1.5.0";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z9grvjyfz16ag55hg522d3q4dh07hf391sf9s96npc0vfi85xkz";
      type = "gem";
    };
    version = "2.6.1";
  };
  json-schema = {
    dependencies = ["addressable"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yv5lfmr2nzd14af498xqd5p89f3g080q8wk0klr3vxgypsikkb5";
      type = "gem";
    };
    version = "2.8.1";
  };
  json_schemer = {
    dependencies = ["ecma-re-validator" "hana" "regexp_parser" "uri_template"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rkb7gz819g82n3xshb5g8kgv1nvgwg1lm2fk7715pggzcgc4qik";
      type = "gem";
    };
    version = "0.2.18";
  };
  jwt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bg8pjx0mpvl10k6d8a6gc8dzlv2z5jkqcjbjcirnk032iriq838";
      type = "gem";
    };
    version = "2.3.0";
  };
  kgio = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "rbx";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ipzvw7n0kz1w8rkqybyxvf3hb601a770khm0xdqm68mc4aa59xx";
      type = "gem";
    };
    version = "2.11.4";
  };
  libv8-node = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "102ixp1626b4zjh98h3jxhwv0sdbkgijz38wyb1ffgxqr47c7s0w";
      type = "gem";
    };
    version = "16.10.0.0";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0agybr37wpjv3xy4ipcmsvsibgdgphzrwbvcj4vfiykpmakwm01v";
      type = "gem";
    };
    version = "3.7.1";
  };
  literate_randomizer = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c8p8aw93bx4ygpkwfv6dv41psb86jb0pi16gvnv30rr72dkq1q5";
      type = "gem";
    };
    version = "0.4.0";
  };
  lograge = {
    dependencies = ["actionpack" "activesupport" "railties" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vrjm4yqn5l6q5gsl72fmk95fl6j9z1a05gzbrwmsm3gp1a1bgac";
      type = "gem";
    };
    version = "0.11.2";
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
      sha256 = "09l4rdq5gsnhr7ma7i5ddg8sagkqn122kz8cb244q4hyk9rwmd2w";
      type = "gem";
    };
    version = "2.10.1";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17rvbrqcci1579d7dpbsfmz1f9g7msk82lyh9ip5h29dkrnixcgg";
      type = "gem";
    };
    version = "2.13.0";
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
  lz4-ruby = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "rbx";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12fymsvcb9kw6ycyfzc8b9svriq0afqf1qnl121xrz8c4gpfa6q1";
      type = "gem";
    };
    version = "0.3.3";
  };
  mail = {
    dependencies = ["mini_mime"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "5b700fc95ee66378e0cf2559abc73c8bc3062a4b";
      sha256 = "0j084s1gsdwiqvm4jdayi0x4rsdrazqv8z8wkz28v7zmaymw18lz";
      type = "git";
      url = "https://github.com/discourse/mail.git";
    };
    version = "2.8.0.edge";
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
      sha256 = "0s8qaf19yr4lhvdxk3cy3ifc47cgxdz2jybg6hzxsy9gh88c1f7v";
      type = "gem";
    };
    version = "1.0.0";
  };
  message_bus = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0589k3ggj6s970mr2jaz8zfcnl5b926birwi6s3b6j3ijf2nh3s3";
      type = "gem";
    };
    version = "4.0.0";
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
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lbim375gw2dk6383qirz13hgdmxlan0vc5da2l072j3qw6fqjm5";
      type = "gem";
    };
    version = "1.1.2";
  };
  mini_portile2 = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lvxm91hi0pabnkkg47wh1siv56s6slm2mdq1idfm86dyfidfprq";
      type = "gem";
    };
    version = "2.6.1";
  };
  mini_racer = {
    dependencies = ["libv8-node"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j45mg8fs7i0g6ndbzd9qqs3fhq6wpvlp5s95k6mjn1as71l5l55";
      type = "gem";
    };
    version = "0.6.1";
  };
  mini_scheduler = {
    dependencies = ["sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cy9c2wv19m4h2sv9fs66hh1an7hq3y9513678dzx43vm3kjvhz5";
      type = "gem";
    };
    version = "0.13.0";
  };
  mini_sql = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yvln5wx2jfpd9q2pvjdid96vdz1ynnfk8ip913wpx28wp8ww7jn";
      type = "gem";
    };
    version = "1.1.3";
  };
  mini_suffix = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rr2nx1kixd7ccxqdnswjnflg46s6lr1f9vxkdy298k95zwk67cd";
      type = "gem";
    };
    version = "0.3.3";
  };
  minitest = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06xf558gid4w8lwx13jwfdafsch9maz8m0g85wnfymqj63x5nbbd";
      type = "gem";
    };
    version = "5.15.0";
  };
  mocha = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15s53ggsykk69kxqvs4416s8yxdhz6caggva55n8sjgy4ixzwp10";
      type = "gem";
    };
    version = "1.13.0";
  };
  mock_redis = {
    dependencies = ["ruby2_keywords"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10jj7hralc2hmvvm77w71d4dwq9ij5a1lkqyfw6z32saybzmcs99";
      type = "gem";
    };
    version = "0.29.0";
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
  mustache = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l0p4wx15mi3wnamfv92ipkia4nsx8qi132c6g51jfdma3fiz2ch";
      type = "gem";
    };
    version = "1.1.1";
  };
  nio4r = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xk64wghkscs6bv2n22853k2nh39d131c6rfpnlw12mbjnnv9v1v";
      type = "gem";
    };
    version = "2.5.8";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v02g7k7cxiwdcahvlxrmizn3avj2q6nsjccgilq1idc89cr081b";
      type = "gem";
    };
    version = "1.12.5";
  };
  oauth = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h6nfg2pibc17fch0795d4bcy41a92im5zrsrgs31zdhrl6zf4w0";
      type = "gem";
    };
    version = "0.5.8";
  };
  oauth2 = {
    dependencies = ["faraday" "jwt" "multi_json" "multi_xml" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q6q2kgpxmygk8kmxqn54zkw8cs57a34zzz5cxpsh1bj3ag06rk3";
      type = "gem";
    };
    version = "1.4.7";
  };
  oj = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fh73xl58n696akgarylfdfmv6l93rfwh3csjjbljr6gvhg4qrz9";
      type = "gem";
    };
    version = "3.13.2";
  };
  omniauth = {
    dependencies = ["hashie" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "002vi9gwamkmhf0dsj2im1d47xw2n1jfhnzl18shxf3ampkqfmyz";
      type = "gem";
    };
    version = "1.9.1";
  };
  omniauth-facebook = {
    dependencies = ["omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m7q38kjm94wgq6h7hk9546yg33wcs3vf1v6zp0vx7nwkvfxh2j4";
      type = "gem";
    };
    version = "9.0.0";
  };
  omniauth-github = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xbk0dbxqfpyfb33ghz6vrlz3m6442rp18ryf13gwzlnifcawhlb";
      type = "gem";
    };
    version = "1.4.0";
  };
  omniauth-google-oauth2 = {
    dependencies = ["jwt" "oauth2" "omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10pnxvb6wpnf58dja3yz4ja527443x3q13hzhcbays4amnnp8i4a";
      type = "gem";
    };
    version = "0.8.2";
  };
  omniauth-oauth = {
    dependencies = ["oauth" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yw2vzx633p9wpdkd4jxsih6mw604mj7f6myyfikmj4d95c8d9z7";
      type = "gem";
    };
    version = "1.2.0";
  };
  omniauth-oauth2 = {
    dependencies = ["oauth2" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ry65f309rnzhgdjvqybkd5i4qp9rpk1gbp4dz02h4l6bkk6ya10";
      type = "gem";
    };
    version = "1.7.2";
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
  openssl = {
    dependencies = ["ipaddr"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wkx3b598mxmr3idfbgas0cnrds54bfivnn1ip0d7z7kcr5vzbzn";
      type = "gem";
    };
    version = "2.2.1";
  };
  openssl-signature_algorithm = {
    dependencies = ["openssl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "173p9agv45hj62fdgl9bzqr9f6xg7hi2sf5iyd3ahiwbv220x332";
      type = "gem";
    };
    version = "1.1.1";
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
      sha256 = "1vg2chy1cfmdj6c1gryl8zvjhhmb3plwgyh1jfnpq4fnfqv7asrk";
      type = "gem";
    };
    version = "3.0.1";
  };
  parallel = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hkfpm78c2vs1qblnva3k1grijvxh87iixcnyd83s3lxrxsjvag4";
      type = "gem";
    };
    version = "1.21.0";
  };
  parallel_tests = {
    dependencies = ["parallel"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vsfsfd194xnzjz94ml157w61fnag8jg47b4bssc508kb3vmk20w";
      type = "gem";
    };
    version = "3.7.3";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08q20ckhn58m49lccf93p0yv7pkc7hymmcz3di762kb658d5fd38";
      type = "gem";
    };
    version = "3.1.0.0";
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
  progress = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wymdk40cwrqn32gwg1kw94s5p1n0z3n7ma7x1s62gd4vw3d63in";
      type = "gem";
    };
    version = "3.6.0";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iyw4q4an2wmk8v5rn2ghfy2jaz9vmw2nk8415nnpx2s866934qk";
      type = "gem";
    };
    version = "0.13.1";
  };
  pry-byebug = {
    dependencies = ["byebug" "pry"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "096y5vmzpyy4x9h4ky4cs4y7d19vdq9vbwwrqafbh5gagzwhifiv";
      type = "gem";
    };
    version = "3.9.0";
  };
  pry-rails = {
    dependencies = ["pry"];
    groups = ["default"];
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
      sha256 = "1xqcgkl7bwws1qrlnmxgh8g4g9m10vg60bhlw40fplninb3ng6d9";
      type = "gem";
    };
    version = "4.0.6";
  };
  puma = {
    dependencies = ["nio4r"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xblxnrs0c5m326v7kgr32k4m00cl2ipcf5m0qvyisrw62vd5dbn";
      type = "gem";
    };
    version = "5.5.2";
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
  racc = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0la56m0z26j3mfn1a9lf2l03qx1xifanndf9p3vx1azf6sqy7v9d";
      type = "gem";
    };
    version = "1.6.0";
  };
  rack = {
    groups = ["default" "development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i5vs0dph9i5jn8dfc6aqd6njcafmb20rwqngrf759c9cvmyff16";
      type = "gem";
    };
    version = "2.2.3";
  };
  rack-mini-profiler = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03hcvjw9nrv0w6yjy2zkv4ivin9xg2wr7xfcvx7rc2msv1gmjb6z";
      type = "gem";
    };
    version = "2.3.3";
  };
  rack-protection = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "159a4j4kragqh0z0z8vrpilpmaisnlz3n7kgiyf16bxkwlb3qlhz";
      type = "gem";
    };
    version = "2.1.0";
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
      sha256 = "09qrfi3pgllxb08r024lln9k0qzxs57v0slsj8616xf9c0cwnwbk";
      type = "gem";
    };
    version = "1.4.2";
  };
  rails_failover = {
    dependencies = ["activerecord" "concurrent-ruby" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g3snqmsbdl2jyf2h7q4ds333hizp0j89chca75xv10gv2lq6sa8";
      type = "gem";
    };
    version = "0.7.3";
  };
  rails_multisite = {
    dependencies = ["activerecord" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j44n1c19gbskzxskdipr5f6lgglpn398x9kcbpw452wwwav8rmf";
      type = "gem";
    };
    version = "4.0.0";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "method_source" "rake" "thor"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kwpm068cqys34p2g0j3l1g0cd5f3kxnsay5v7lmbd0sgarac0vy";
      type = "gem";
    };
    version = "6.1.4.1";
  };
  rainbow = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  raindrops = {
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "rbx";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wb2x51parf6v78w0cic90m33bdc92y5h8rj4wqs75dhw1b69hc7";
      type = "gem";
    };
    version = "0.20.0";
  };
  rake = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15whn7p9nrkxangbs9hh75q585yfn66lv0v2mhj6q6dl6x8bzr2w";
      type = "gem";
    };
    version = "13.0.6";
  };
  rb-fsevent = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qsx9c4jr11vr3a9s5j83avczx9qn9rjaf32gxpc2v451hvbc0is";
      type = "gem";
    };
    version = "0.11.0";
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
      sha256 = "0s8prj0klfgpmpfcpdzbf149qrrsdxgnb6w6kkqc9gyars4vyaqn";
      type = "gem";
    };
    version = "0.4.14";
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
      sha256 = "03r9739q3vq38g456snf3rk9hadf955bs5im6qs6m69h19mrz2yw";
      type = "gem";
    };
    version = "4.5.1";
  };
  redis-namespace = {
    dependencies = ["redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k65fr7f8ciq7d9nwc5ziw1d32zsxilgmqdlj3359rz5jgb0f5y8";
      type = "gem";
    };
    version = "1.8.1";
  };
  regexp_parser = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "008yn8j44414qxhn1c0nxp4a70rq0bqhz70hnjpgx8cjh2g0makp";
      type = "gem";
    };
    version = "2.2.0";
  };
  request_store = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cx74kispmnw3ljwb239j65a2j14n8jlsygy372hrsa8mxc71hxi";
      type = "gem";
    };
    version = "1.5.0";
  };
  rexml = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
  };
  rinku = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zcdha17s1wzxyc5814j6319wqg33jbn58pg6wmxpws36476fq4b";
      type = "gem";
    };
    version = "2.0.6";
  };
  rotp = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11q7rkjx40yi6lpylgl2jkpy162mjw7mswrcgcax86vgpbpjx6i3";
      type = "gem";
    };
    version = "6.2.0";
  };
  rqrcode = {
    dependencies = ["chunky_png" "rqrcode_core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0444sgvx3ahvgr3c9swpy32kcdpciwgcqahp3pb4m7d23xp1qjdc";
      type = "gem";
    };
    version = "2.1.0";
  };
  rqrcode_core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06ld6386hbdhy5h0k09axmgn424kavpc8f27k1vjhknjhbf8jjfg";
      type = "gem";
    };
    version = "1.2.0";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dwai7jnwmdmd7ajbi2q0k0lx1dh88knv5wl7c34wjmf94yv8w5q";
      type = "gem";
    };
    version = "3.10.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wwnfhxxvrlxlk1a3yxlb82k2f9lm0yn0598x7lk8fksaz4vv6mc";
      type = "gem";
    };
    version = "3.10.1";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qrj2j9jcd3m4aksk4kbv439882yl3z1harv2jrybrgjgdzdz7zs";
      type = "gem";
    };
    version = "3.10.2";
  };
  rspec-html-matchers = {
    dependencies = ["nokogiri" "rspec"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0883rqv77n2wawnk5lp3la48l7pckyz8l013qddngzmksi5p1v3f";
      type = "gem";
    };
    version = "0.9.4";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d13g6kipqqc9lmwz5b244pdwc97z15vcbnbq6n9rlf32bipdz4k";
      type = "gem";
    };
    version = "3.10.2";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "152yz205p8zi5nxxhs8z581rjdvvqsfjndklkvn11f2vi50nv7n9";
      type = "gem";
    };
    version = "5.0.2";
  };
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pjckrh8q6sqxy38xw7f4ziylq1983k84xh927s6352pps68zj35";
      type = "gem";
    };
    version = "3.10.3";
  };
  rss = {
    dependencies = ["rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b1zx07kr64kkpm4lssd4r1a1qyr829ppmfl85i4adcvx9mqfid0";
      type = "gem";
    };
    version = "0.2.9";
  };
  rswag-specs = {
    dependencies = ["activesupport" "json-schema" "railties"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dma3j5vfjhyclg8y0gsp44vs4wn9chf4jgfhc9r6ws018xrbxzd";
      type = "gem";
    };
    version = "2.4.0";
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
    dependencies = ["parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "141ff5mdqi8an8q00qw8kchzil7ck2dzalkk3vk176l0s6hljcbj";
      type = "gem";
    };
    version = "1.25.0";
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xrij42166a71ixfpfr1pildqdrcmc0cb4906h2s8sk4kqdyngih";
      type = "gem";
    };
    version = "1.15.1";
  };
  rubocop-discourse = {
    dependencies = ["rubocop" "rubocop-rspec"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01f4y7am9cq276zl8vsgv64w8wfmhpbzg7vzsifhgnnh92g6s04g";
      type = "gem";
    };
    version = "2.5.0";
  };
  rubocop-rspec = {
    dependencies = ["rubocop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d76haw5gjpxlfanfzicn7sb5gziyizaksm7i999p7p5dmy5vf9q";
      type = "gem";
    };
    version = "2.7.0";
  };
  ruby-prof = {
    groups = ["development"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r3xalp91l07m0cwllcxjzg6nkviiqnxkcbgg5qnzsdji6rgy65m";
      type = "gem";
    };
    version = "1.4.3";
  };
  ruby-progressbar = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02nmaw7yx9kl7rbaan5pl8x5nn0y4j5954mzrkzi9i3dhsrps4nc";
      type = "gem";
    };
    version = "1.11.0";
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
  ruby2_keywords = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyzip = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0grps9197qyxakbpw02pda59v45lfgbgiyw48i0mq9f2bn9y6mrz";
      type = "gem";
    };
    version = "2.3.2";
  };
  sanitize = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zq8pxmsd1abw18zz6mazsm2jfpwmbgdxbpawb7bmwvkb2c5yyc1";
      type = "gem";
    };
    version = "6.0.0";
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
      sha256 = "1d9djmwn36a5m8a83bpycs48g8kh1n2xkyvghn7dr6zwh4wdyksz";
      type = "gem";
    };
    version = "2.1.2";
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
  shoulda-matchers = {
    dependencies = ["activesupport"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01svmyma958sbqfz0v29lbqbr0ibvgcng352nhx6bsc9k5c207d0";
      type = "gem";
    };
    version = "5.1.0";
  };
  sidekiq = {
    dependencies = ["connection_pool" "rack" "redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k38cbwhcj9ncfzlgfmvq2zqfdvldln58w8s8v89m0jqlhnhsqhj";
      type = "gem";
    };
    version = "6.3.1";
  };
  simplecov = {
    dependencies = ["docile" "simplecov-html" "simplecov_json_formatter"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hrv046jll6ad1s964gsmcq4hvkr3zzr6jc7z1mns22mvfpbc3cr";
      type = "gem";
    };
    version = "0.21.2";
  };
  simplecov-html = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yx01bxa8pbf9ip4hagqkp5m0mqfnwnw2xk8kjraiywz4lrss6jb";
      type = "gem";
    };
    version = "0.12.3";
  };
  simplecov_json_formatter = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19r15hyvh52jx7fmsrcflb58xh8l7l0zx4sxkh3hqzhq68y81pjl";
      type = "gem";
    };
    version = "0.1.3";
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
      sha256 = "1b9i14qb27zs56hlcc2hf139l0ghbqnjpmfi0054dxycaxvk5min";
      type = "gem";
    };
    version = "3.4.2";
  };
  sshkey = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03bkn55qsng484iqwz2lmm6rkimj01vsvhwk661s3lnmpkl65lbp";
      type = "gem";
    };
    version = "2.0.0";
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
      sha256 = "06lz70k8c0r7fyxk1nc3idh14x7nvsr21ydm1bsmbj00jyhmfzsn";
      type = "gem";
    };
    version = "0.2.17";
  };
  test-prof = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vg0zjfgibdcgkzb4c25v0f4v6v8mvpzvgcag194rwglmkkyrwkx";
      type = "gem";
    };
    version = "1.0.7";
  };
  thor = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0inl77jh4ia03jw3iqm5ipr76ghal3hyjrd6r8zqsswwvi9j2xdi";
      type = "gem";
    };
    version = "1.2.1";
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
  tzinfo = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10qp5x7f9hvlc0psv9gsfbxg4a7s0485wsbq1kljkxq94in91l4z";
      type = "gem";
    };
    version = "2.0.4";
  };
  uglifier = {
    dependencies = ["execjs"];
    groups = ["assets"];
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
      sha256 = "0jmbimpnpjdzz8hlrppgl9spm99qh3qzbx0b81k3gkgwba8nk3yd";
      type = "gem";
    };
    version = "0.0.8";
  };
  unicode-display_width = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0csjm9shhfik0ci9mgimb7hf3xgh7nx45rkd9rzgdz6vkwr8rzxn";
      type = "gem";
    };
    version = "2.1.0";
  };
  unicorn = {
    dependencies = ["kgio" "raindrops"];
    groups = ["default"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "rbx";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h0gma14jjxiz6piyi6p99q7lya2mxrq79l03160hascvmx9ipa5";
      type = "gem";
    };
    version = "6.1.0";
  };
  uniform_notifier = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1614dqnky0f9f1znj0lih8i184vfps86md93dw0kxrg3af9gnqb4";
      type = "gem";
    };
    version = "1.14.2";
  };
  uri_template = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p8qbxlpmg3msw0ihny6a3gsn0yvydx9ksh5knn8dnq06zhqyb1i";
      type = "gem";
    };
    version = "0.7.0";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l8vh8p0g92cqcvv0ra3mblsa4nczh0rz8nbwbkc3g3yzbva85xk";
      type = "gem";
    };
    version = "3.14.0";
  };
  webpush = {
    dependencies = ["hkdf" "jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z9ma580q80czw46gi1bvsr2iwxr63aiyr7i9gilav6hbhg3sxv3";
      type = "gem";
    };
    version = "1.1.0";
  };
  xorcist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q7hr3qyn1hczv9fglqc2cbaax0fb37gjjr0y24x19mmp817csdn";
      type = "gem";
    };
    version = "1.1.2";
  };
  yaml-lint = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m9n4sg7i0334yac7dcrhnhv5rzvrccgnh687n9x77ba3awk4yx1";
      type = "gem";
    };
    version = "0.0.10";
  };
  zeitwerk = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lmg9x683gr9mkrbq9df2m0zb0650mdfxqna0bs10js44inv7znx";
      type = "gem";
    };
    version = "2.5.3";
  };
}
