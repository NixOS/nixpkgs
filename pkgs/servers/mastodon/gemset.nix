{
  actioncable = {
    dependencies = ["actionpack" "nio4r" "websocket-driver"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09m0ndy4hvb7m2qm81kbx6q9n0z0h968ixnz8zkv1lhv6z3rghlp";
      type = "gem";
    };
    version = "5.2.4.3";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fxv67z83r5dx80s4ajcksb8qq29ff2ziypark7b8rrg6jz0lwh6";
      type = "gem";
    };
    version = "5.2.4.3";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10sjvcyvl1gqg0czg2finipcnm7lw33k7igbbwxa4vzi45560m9d";
      type = "gem";
    };
    version = "5.2.4.3";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lzlhrci8kqi3yifhwsa43l2as5w8zvd30g7nqmv25rb37cnrdyj";
      type = "gem";
    };
    version = "5.2.4.3";
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
      sha256 = "1ray2ias3k8kmhn4sn2bqhfl2yin9vjbzvdq70v1910mdgbs91jm";
      type = "gem";
    };
    version = "5.2.4.3";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "171y3cx5a1bgzqpwyq1m0mb7k0yrfmr8nymg9cqmwh01iw2qyq85";
      type = "gem";
    };
    version = "5.2.4.3";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rf71wszvn4ga361gzif1vw04kfmgwp4ckb71yqwxzscbblbd1zq";
      type = "gem";
    };
    version = "5.2.4.3";
  };
  activestorage = {
    dependencies = ["actionpack" "activerecord" "marcel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0prr7h1zmjh1r0csw88g6ybmyz2imm9y8wayblq8i9qh4maiq8pg";
      type = "gem";
    };
    version = "5.2.4.3";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02fdawr3wyvpzpja3r7mvb8lmn2mm5jdw502bx3ncr2sy2nw1kx6";
      type = "gem";
    };
    version = "5.2.4.3";
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
      sha256 = "1dxrfppwfg13vqmambbs56xjj8qsdgcy58r2yc44vvy3z1g5yflw";
      type = "gem";
    };
    version = "3.1.1";
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
      sha256 = "1l3468czzjmxl93ap40hp7z94yxp4nbag0bxqs789bm30md90m2a";
      type = "gem";
    };
    version = "2.4.1";
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
      sha256 = "1hyl4fs5jrh5irphaaq7lk6v06wlpva9bsza2y298jir6237jvd9";
      type = "gem";
    };
    version = "1.338.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04vrlxp5nlwj70q52dsd8w6bd80yyh268394gg7hvi0m697mjr0c";
      type = "gem";
    };
    version = "3.103.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rpwpj4f4q9wdrbgiqngzwfdaaqyz0iif8sv16z6z0mm6y3cb06q";
      type = "gem";
    };
    version = "1.36.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yzwf03f9a7fna35r6z89n74pczn828s2hjpv1iq5mqry86cwayp";
      type = "gem";
    };
    version = "1.73.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aknh3q37rq3ixxa84x2p26g8a15zmiig2rm1pmailsb9vqhfh3j";
      type = "gem";
    };
    version = "1.2.1";
  };
  bcrypt = {
    groups = ["default" "pam_authentication"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ai0m15jg3n0b22mimk09ppnga316dc7dyvz06w8rrqh5gy1lslp";
      type = "gem";
    };
    version = "3.1.13";
  };
  better_errors = {
    dependencies = ["coderay" "erubi" "rack"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kn7rv81i2r462k56v29i3s8abcmfcpfj9axia736mwjvv0app2k";
      type = "gem";
    };
    version = "2.7.1";
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
      sha256 = "0bz62p9vc7lcrmzhiz4pf7myww086mq287cw3jjj7fyc7jhmamw0";
      type = "gem";
    };
    version = "1.4.6";
  };
  brakeman = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v3xy3s1sssnl2h2yn5vbfb4m16hw6qi17zkg0bw98xljsc3dgyp";
      type = "gem";
    };
    version = "4.8.2";
  };
  browser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q1yzvbqp0mykswipq3w00ljw9fgkhjfrij3hkwi7cx85r14n6gw";
      type = "gem";
    };
    version = "4.2.0";
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
      sha256 = "04l9rs56rlvihbr2ybkrigjajgd3swa98lxvmdl8iylj1g5m7n0j";
      type = "gem";
    };
    version = "0.7.0.1";
  };
  byebug = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nx3yjf4xzdgb8jkmk2344081gqr22pgjqnmjg2q64mj5d6r9194";
      type = "gem";
    };
    version = "11.1.3";
  };
  capistrano = {
    dependencies = ["airbrussh" "i18n" "rake" "sshkit"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13k2k29y8idcacr0r4ycixpb7mvv2v88dilwzdmaw9r08wc8y9bl";
      type = "gem";
    };
    version = "3.14.1";
  };
  capistrano-bundler = {
    dependencies = ["capistrano"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rkdhsbgi72d1330n54wfkb1mf7nnsygnvkxf8kj07djxg71sb51";
      type = "gem";
    };
    version = "1.6.0";
  };
  capistrano-rails = {
    dependencies = ["capistrano" "capistrano-bundler"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d4d479n7yxhbr6pm44lzw8cgqv3mlb5jn45dgj2akpb4lfznwah";
      type = "gem";
    };
    version = "1.5.0";
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
      sha256 = "0ji9kyb01dpnjbvpyb0c481cpnisd6wx6div6rywi9fihk66627w";
      type = "gem";
    };
    version = "3.33.0";
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
      sha256 = "04hwr44m7x7vv55lc4vk5zcd6zq98c2asvzl3dh2adg1fhpk29nr";
      type = "gem";
    };
    version = "3.3.0";
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
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  color_diff = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01dpvqlzybpb3pkcwd9ik5sbjw283618ywvdphxslhiy8ps3kp4r";
      type = "gem";
    };
    version = "0.1";
  };
  concurrent-ruby = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "094387x4yasb797mv07cs3g6f08y56virc2rjcpb1k79rzaj3nhl";
      type = "gem";
    };
    version = "1.1.6";
  };
  connection_pool = {
    groups = ["default" "test"];
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
      sha256 = "0kbcq9z05la2nlv4sy1arxpxd75h31c62bqyrv8zay3b98fifhid";
      type = "gem";
    };
    version = "4.7.2";
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
      sha256 = "0m925b8xc6kbpnif9dldna24q1szg4mk0fvszrki837pfn46afmz";
      type = "gem";
    };
    version = "1.4.4";
  };
  discard = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zq7wjmknz8fd1pw169xpwf6js4280gnphy6mw8m3xiz1715bcig";
      type = "gem";
    };
    version = "1.2.0";
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
      sha256 = "105yr9gy60z0pyh85pbc6gazanm6jmb5c6agd7p1mzrc21hmrzrk";
      type = "gem";
    };
    version = "5.4.0";
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
  ed25519 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f5kr8za7hvla38fc0n9jiv55iq62k5bzclsa5kdb14l3r4w6qnw";
      type = "gem";
    };
    version = "1.2.4";
  };
  elasticsearch = {
    dependencies = ["elasticsearch-api" "elasticsearch-transport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mhp2fp5rdwlcjm62czqxl9p3jagzrjdbvl75gmbkbmw486zj4sw";
      type = "gem";
    };
    version = "7.8.0";
  };
  elasticsearch-api = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "138f6ayqlxhizzzg60mszxjirrdhbsbaipzscynfzwn4jxm2gj0p";
      type = "gem";
    };
    version = "7.8.0";
  };
  elasticsearch-dsl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d2qr5hvqcr5r78djzrw5fjkaggvw080sdixnnq8cf8yriwhsvnf";
      type = "gem";
    };
    version = "0.1.9";
  };
  elasticsearch-transport = {
    dependencies = ["faraday" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ikljnn0w1jw20wsy1g19abilkkki8g7hglkn1cf60qqgs8cqlvl";
      type = "gem";
    };
    version = "7.8.0";
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
      sha256 = "0xr8i8ql4xzx17d12590i3j299hj6vc0ja2j29dy12i5nlchxrvp";
      type = "gem";
    };
    version = "1.2.4";
  };
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14f8rm470w04p4y1yk971jgwdjdwwx8d2gxdgpd7j9i44asnvsjh";
      type = "gem";
    };
    version = "0.75.0";
  };
  fabrication = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pdrl55xf76pbc5kjzp7diawxxvgbk2cm38532in6df823431n6z";
      type = "gem";
    };
    version = "2.21.1";
  };
  faker = {
    dependencies = ["i18n"];
    groups = ["test"];
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
      sha256 = "11j18h61d3p0pcp9k5346lbj1lahab1dqybkrx9338932lmjn7ap";
      type = "gem";
    };
    version = "0.3.10";
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
      sha256 = "0vswnyf3x42r2kfw95a4q6md48gssvib0xyrgzzf8p19xxivsziw";
      type = "gem";
    };
    version = "1.3.6";
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
      sha256 = "0z8vmvnkrllkpzsxi94284di9r63g9v561a16an35izwak8g245y";
      type = "gem";
    };
    version = "4.4.1";
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
      sha256 = "1wx591jdhy84901pklh1n9sgh74gnvq1qyqxwchni1yrc49ynknc";
      type = "gem";
    };
    version = "2.3.0";
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
      sha256 = "1mq67if5lq388raxa5rh43z6g5zlqh9yixcja4s81p9dzrsj4i3x";
      type = "gem";
    };
    version = "1.4.3";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10nq1xjqvkhngiygji831qx9bryjwws95r4vrnlq9142bzkg670s";
      type = "gem";
    };
    version = "1.8.3";
  };
  i18n-tasks = {
    dependencies = ["activesupport" "ast" "erubi" "highline" "i18n" "parser" "rails-i18n" "rainbow" "terminal-table"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04am9452ihm8fcq2si44bba0msz0014wfg50ksxs5dpb2l065abg";
      type = "gem";
    };
    version = "0.9.31";
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
      sha256 = "1k1r8wgk6syvpsl3j5qfh5az5w4zdvk0pvpjl7qspznfdbp2mn71";
      type = "gem";
    };
    version = "0.3.5";
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
      sha256 = "158fawfwmv2sq4whqqaksfykkiad2xxrrj0nmpnc6vnlzi1bp7iz";
      type = "gem";
    };
    version = "2.3.1";
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
      sha256 = "19qavnlaxvrxr15lzdpyh6sn9lfrlw9f51dn68lqnlj5pakhfbxa";
      type = "gem";
    };
    version = "3.1.4";
  };
  json-ld-preloaded = {
    dependencies = ["json-ld" "rdf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f8vham63wy689d4jp2j9rani0n10h40dpymgishf3na8cjj0lix";
      type = "gem";
    };
    version = "3.1.3";
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
      sha256 = "01zg1vp3lyl3flyjdkrcc93ghf833qgfgh2p1biqfhkzz11r129c";
      type = "gem";
    };
    version = "2.2.1";
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
      sha256 = "1s9hq8bpn6g5vqr3nzyirn3agn7x8agan6151zvq5vmkf6rvmyb2";
      type = "gem";
    };
    version = "2.6.0";
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
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      type = "gem";
    };
    version = "1.0.0";
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
      sha256 = "1z75svngyhsglx0y2f9rnil2j08f9ab54b3l95bpgz67zq2if753";
      type = "gem";
    };
    version = "3.2020.0512";
  };
  mimemagic = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qfqb9w76kmpb48frbzbyvjc0dfxh5qiw1kxdbv2y2kp6fxpa1kf";
      type = "gem";
    };
    version = "0.3.5";
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
      sha256 = "09bz9nsznxgaf06cx3b5z71glgl0hdw469gqx3w7bqijgrb55p5g";
      type = "gem";
    };
    version = "5.14.1";
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
      sha256 = "0b4h3ip8d1gkrc0znnw54hbxillk73mdnaf5pz330lmrcl1wiilg";
      type = "gem";
    };
    version = "3.0.0";
  };
  net-ssh = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jp3jgcn8cij407xx9ldb5h9c6jv13jc4cf6kk2idclz43ww21c9";
      type = "gem";
    };
    version = "6.1.0";
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
      sha256 = "12j76d0bp608932xkzmfi638c7aqah57l437q8494znzbj610qnm";
      type = "gem";
    };
    version = "1.10.9";
  };
  nokogumbo = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sxjnpjvrn10gdmfw2dimhch861lz00f28hvkkz0b1gc2rb65k9s";
      type = "gem";
    };
    version = "2.0.2";
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
      sha256 = "1zik71a9dj2c0cnbqxjfzgrg6r2l3f7584813z6asl50nfdbf7jw";
      type = "gem";
    };
    version = "3.10.6";
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
      sha256 = "0ab7qs54f3k0qsvnwwn1vsxd2kdcdi9ffgydynwxkwjc070f2da0";
      type = "gem";
    };
    version = "1.10.2";
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
      sha256 = "03yjblhamjwafzwrxmxsvrldpg61hl4y5h7y7ng3b51nshnhk7yf";
      type = "gem";
    };
    version = "2.13.2";
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
      sha256 = "17b127xxmm2yqdz146qwbs57046kn0js1h8synv01dwqz2z1kp2l";
      type = "gem";
    };
    version = "1.19.2";
  };
  parallel_tests = {
    dependencies = ["parallel"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06jzqqx1chx204zmryv8n0kkaznhkl6iahg2iiparvdblisi782v";
      type = "gem";
    };
    version = "3.0.0";
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
  parslet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01pnw6ymz6nynklqvqxs4bcai25kcvnd5x4id9z3vd1rbmlk0lfl";
      type = "gem";
    };
    version = "2.0.0";
  };
  pastel = {
    dependencies = ["equatable" "tty-color"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vpy0i108by2lhpilprad1nw8smkvsznj6aia01c5ir4a7x2cfyc";
      type = "gem";
    };
    version = "0.7.4";
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
  pghero = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14yjqgcnvwr1j8xdxk8ch4llqlxfjzjd1g57g6fxh0f5n6p51dfa";
      type = "gem";
    };
    version = "2.5.1";
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
      sha256 = "0q23clzqgzxcg1jld7hn5jy2yqxvana3iw66vmjgzz7y4ylf97b6";
      type = "gem";
    };
    version = "1.11.1";
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
      sha256 = "0iyw4q4an2wmk8v5rn2ghfy2jaz9vmw2nk8415nnpx2s866934qk";
      type = "gem";
    };
    version = "0.13.1";
  };
  pry-byebug = {
    dependencies = ["byebug" "pry"];
    groups = ["development" "test"];
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
      sha256 = "0cly51sqlz4ydpi5cshbrgjqgmysy26yca01lpnvhqvfvb4y9gl8";
      type = "gem";
    };
    version = "4.3.5";
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
      sha256 = "08lhfc0dbqfyd6fmgfi7i4w7sclqzw3821l6y3aml36sm876ivyk";
      type = "gem";
    };
    version = "1.3.1";
  };
  rack = {
    groups = ["default" "development" "pam_authentication" "production" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i5vs0dph9i5jn8dfc6aqd6njcafmb20rwqngrf759c9cvmyff16";
      type = "gem";
    };
    version = "2.2.3";
  };
  rack-attack = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zzyiiif9w67v43rv0hg7nxbwp1ish1f02x61kx0rmz8sy1j7wnn";
      type = "gem";
    };
    version = "6.3.1";
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
      sha256 = "1yq3fmgh9bs6v9c6ai0vlwxix1rijnv44zzii0lhqh9kx8nnp77j";
      type = "gem";
    };
    version = "5.2.4.3";
  };
  rails-controller-testing = {
    dependencies = ["actionpack" "actionview" "activesupport"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "151f303jcvs8s149mhx2g5mn67487x0blrf9dzl76q1nb7dlh53l";
      type = "gem";
    };
    version = "1.0.5";
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
      sha256 = "1vks7ywa9b7l6ixg1j29jrzmh0rzp3z6a2xcnz1slgp04ll6m2bk";
      type = "gem";
    };
    version = "5.2.4.3";
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
      sha256 = "0ldwvhwc2fqvr9j4rrgpd3isypjf00ig6ac825hfby2xfns709q3";
      type = "gem";
    };
    version = "3.1.4";
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
      sha256 = "19hm66kw5vx1lmlh8bj7rxlddyj0vfp11ajw9njhrmn8173d0vb5";
      type = "gem";
    };
    version = "4.2.1";
  };
  redis-actionpack = {
    dependencies = ["actionpack" "redis-rack" "redis-store"];
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c2276zzc0044zh37a8frx1v7hnra7z7k126154ps7njbqngfdv3";
      type = "gem";
    };
    version = "5.2.0";
  };
  redis-activesupport = {
    dependencies = ["activesupport" "redis-store"];
    groups = ["default" "production"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14a3z8810j02ysvg53f3mvcfb4rw34m91yfd19zy9y5lb3yv2g59";
      type = "gem";
    };
    version = "5.2.0";
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
      sha256 = "0ldw5sxyd80pv0gr89kvn6ziszlbs8lv1a573fkm6d0f11fps413";
      type = "gem";
    };
    version = "2.1.2";
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
      sha256 = "14kjykc6rpdh24sshg9savqdajya2dislc1jmbzg91w9967f4gv1";
      type = "gem";
    };
    version = "3.0.1";
  };
  rexml = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mkvkcw9fhpaizrhca0pdgjcrbns48rlz4g6lavl5gjjq3rk2sq3";
      type = "gem";
    };
    version = "3.2.4";
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
      sha256 = "071jqmhk3hf0grsvi0jx5sl449pf82p40ls5b3likbq4q516zc0j";
      type = "gem";
    };
    version = "0.1.2";
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
  rspec-sidekiq = {
    dependencies = ["rspec-core" "sidekiq"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1spzw3sc2p0n9qfb89y1v8igd60y7c5z9w2hjqqbbgbyjvy0agp8";
      type = "gem";
    };
    version = "3.1.0";
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
  rspec_junit_formatter = {
    dependencies = ["rspec-core"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aynmrgnv26pkprrajvp7advb8nbh0x4pkwk6jwq8qmwzarzk21p";
      type = "gem";
    };
    version = "0.4.1";
  };
  rubocop = {
    dependencies = ["parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jl3ghxw1bpj272s5s3gl07l2rbd1vwr9z9jmlxxaa2faldn9gms";
      type = "gem";
    };
    version = "0.86.0";
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14qz2p4c2ghixk7x5pddm9z51dlx4gmi3djzvkzp1zfb0yywzh7y";
      type = "gem";
    };
    version = "0.1.0";
  };
  rubocop-rails = {
    dependencies = ["activesupport" "rack" "rubocop"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fahxffxgv3swlyl8wlbzqgcsgis9f9b0c25ybbia7zr0b1zfv3l";
      type = "gem";
    };
    version = "2.6.0";
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
      sha256 = "0ps79g3f39iy6dpc9z4z5wwxdkbaciqjfbi0pfl7dbkz1d8q14qi";
      type = "gem";
    };
    version = "1.11.0";
  };
  rufus-scheduler = {
    dependencies = ["fugit"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bcr8y9nq0anw0gkkpl0zvzgzhhsamw2swp9jwwffd33n8fxg76c";
      type = "gem";
    };
    version = "3.6.0";
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
      sha256 = "18m3zcf207gcrmghx288w3n2kpphc22lbmbc1wdx1nzcn8g2yddh";
      type = "gem";
    };
    version = "5.2.1";
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
  sidekiq = {
    dependencies = ["connection_pool" "rack" "redis"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vfs29z65x3cxhbamxrbzj318jfy7yc6qz439170pyj8x9x2l0hc";
      type = "gem";
    };
    version = "6.1.0";
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
    dependencies = ["e2mmap" "redis" "rufus-scheduler" "sidekiq" "thwait" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ycwmpf17mdd762l5q9w01b4ms5fqrr6hb7s4ndi3nwz8pcngw91";
      type = "gem";
    };
    version = "3.0.1";
  };
  sidekiq-unique-jobs = {
    dependencies = ["concurrent-ruby" "sidekiq" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jpydmmz0hxzsqzfpx6s4fwf6bjnblyf4pcvgjvvf622wikvlxv2";
      type = "gem";
    };
    version = "6.0.22";
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
      sha256 = "1lrjww05nn7h1gzqgn6ww4yd3gi1nfjds0k3rv9hlpqhq05xaxda";
      type = "gem";
    };
    version = "5.0.2";
  };
  simplecov = {
    dependencies = ["docile" "simplecov-html"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ycx5q699ycbjhp28sjbkrd62vwxlrb7fh4v2m7sjsp2qhi6cf6r";
      type = "gem";
    };
    version = "0.18.5";
  };
  simplecov-html = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v7b4mf7njw8kv4ghl4q7mwz3q0flbld7v8blp4m4m3n3aq11bn9";
      type = "gem";
    };
    version = "0.12.2";
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
      sha256 = "1gfglybqjw6g6hccqvh2yjfqlvdy4hwad8mcjdc7zjm5swncfxwz";
      type = "gem";
    };
    version = "1.21.0";
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
      sha256 = "1mszx4xw06qihr211wcy7hbfn1kiylwmxdw3sngb0hrjzk36i662";
      type = "gem";
    };
    version = "0.6.8";
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
      sha256 = "0czbnp19cfnf5zwdd22payhqjv57mgi3gj5n726s20vyq3br6bsp";
      type = "gem";
    };
    version = "0.5.1";
  };
  tty-cursor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j5zw041jgkmn605ya1zc151bxgxl6v192v2i26qhxx7ws2l2lvr";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-prompt = {
    dependencies = ["necromancer" "pastel" "tty-reader"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02frsm7lhhmnxgy2si69pyiwjvhw2dkbjqhclq5n0d1gw93l5sxb";
      type = "gem";
    };
    version = "0.21.0";
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
      sha256 = "0vwmdndbym9vcqr89m6i1mcp24a3bq0a3gsgizg3xpp3nxjxavxx";
      type = "gem";
    };
    version = "0.8.0";
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
      sha256 = "1i3jh086w1kbdj3k5l60lc3nwbanmzdf8yjj3mlrx9b2gjjxhi9r";
      type = "gem";
    };
    version = "1.2.7";
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
      sha256 = "12cmphc9mj4y339nz6wzwjz3cyp725w813dh96v7kp7sz2ci5fwj";
      type = "gem";
    };
    version = "5.1.1";
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
      sha256 = "1wal2lfkd0zf19vgaxcs95ndnfgp3sfwz8f35kf8cgigccnrlfc8";
      type = "gem";
    };
    version = "0.7.2";
  };
  websocket-extensions = {
    groups = ["default"];
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