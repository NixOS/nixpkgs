# This file is generated and should be updated with maintainers/scripts/update-ruby-packages.

{
  actioncable = {
    dependencies = [
      "actionpack"
      "activesupport"
      "nio4r"
      "websocket-driver"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g5kbrqvhwlliyrzd2bhc3kdiqm58df0x3w716bs0ygwyjil1gyk";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  actionmailbox = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activestorage"
      "activesupport"
      "mail"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hf59r6sk0qb5va0ga549rbadcb5n1a2ry8nlkszzcksr6039rx4";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  actionmailer = {
    dependencies = [
      "actionpack"
      "actionview"
      "activejob"
      "activesupport"
      "mail"
      "rails-dom-testing"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rq4aan18y6gwziabnj1q1486349k1v1i5m7ysv206pqqpavcy7m";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  actionpack = {
    dependencies = [
      "actionview"
      "activesupport"
      "cgi"
      "nokogiri"
      "racc"
      "rack"
      "rack-session"
      "rack-test"
      "rails-dom-testing"
      "rails-html-sanitizer"
      "useragent"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jp4w493wvfh9246wxk7g00m1a3vmzkvs0rznq62fwvjjdzzwsmn";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  actiontext = {
    dependencies = [
      "actionpack"
      "activerecord"
      "activestorage"
      "activesupport"
      "globalid"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qs350j3zm7sd6xxn61d93mv3lx1ravbjqja12c7nd7a0zs1h52v";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  actionview = {
    dependencies = [
      "activesupport"
      "builder"
      "cgi"
      "erubi"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z7zy6ibfpsdj9jbdm54bx3ws4dszcq7qa564jn645rr8dlbh6fy";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  activejob = {
    dependencies = [
      "activesupport"
      "globalid"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1n3fiwm1x3dxwj36n9pspd2bgffyw28ys9yd36hjvf3iwdy25i0b";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l60a6mqx1wgp15ki1cp68djci0czgrikpydii5bd877hndqdq9r";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
      "timeout"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pd0f1hy6rvyanmrklqir33xq0jb2my4jajz7hc38nysfpi175dq";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  activestorage = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activesupport"
      "marcel"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1azzbpfp726yigwzmj8g2jji149wisnwrgb86zix6mk25sj4w8hb";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  activesupport = {
    dependencies = [
      "base64"
      "benchmark"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "logger"
      "minitest"
      "securerandom"
      "tzinfo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d6bhg9cim83g8cypjd7cms45ng4p9ga69v26i3vp823d98yvsqi";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11ali533wx91fh93xlk88gjqq8w0p7kxw09nlh41hwc9wv5ly5fc";
      type = "gem";
    };
    version = "2.8.9";
  };
  algoliasearch = {
    dependencies = [
      "httpclient"
      "json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ly8zsgvih540xmxr098hsngv61cf119wf28q5hbvi1f7kgwvh96";
      type = "gem";
    };
    version = "1.27.5";
  };
  ansi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n36cqp65cq259n86wsbyf18iirsjq4ycj0k4x7gncldxb0a17mc";
      type = "gem";
    };
    version = "1.6.0";
  };
  ast = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10yknjyn0728gjn6b5syynvrvrwm66bhssbxq8mkhshxghaiailm";
      type = "gem";
    };
    version = "2.4.3";
  };
  atk = {
    dependencies = [
      "glib2"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01hvjzbkc6p401vbic8kr4qbggya2fs2n5fnjgy26r5a2gw36jd6";
      type = "gem";
    };
    version = "4.3.5";
  };
  atomos = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17vq6sjyswr5jfzwdccw748kgph6bdw30bakwnn6p8sl4hpv4hvx";
      type = "gem";
    };
    version = "0.1.3";
  };
  awesome_print = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vkq6c8y2jvaw03ynds5vjzl1v9wg608cimkd3bidzxc0jvk56z9";
      type = "gem";
    };
    version = "1.9.2";
  };
  backport = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xbzzjrgah0f8ifgd449kak2vyf30micpz6x2g82aipfv7ypsb4i";
      type = "gem";
    };
    version = "1.2.0";
  };
  bacon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1f06gdj77bmwzc1k5iragl1595hbn67yc7sqvs56ca8plrr2vmai";
      type = "gem";
    };
    version = "1.2.0";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
  };
  benchmark = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v1337j39w1z7x9zs4q7ag0nfv4vs4xlsjx2la0wpv8s6hig2pa6";
      type = "gem";
    };
    version = "0.5.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0612spks81fvpv2zrrv3371lbs6mwd7w6g5zafglyk75ici1x87a";
      type = "gem";
    };
    version = "3.3.1";
  };
  bindata = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n4ymlgik3xcg94h52dzmh583ss40rl3sn0kni63v56sq8g6l62k";
      type = "gem";
    };
    version = "2.5.1";
  };
  builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  byebug = {
    dependencies = [ "reline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pg05blj56sxdxq9d54386y9rlvj36vl95x21x9clh8rfpz3w9nj";
      type = "gem";
    };
    version = "13.0.0";
  };
  cairo = {
    dependencies = [
      "native-package-installer"
      "pkg-config"
      "red-colors"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02rd8zfzkq4nfv84y6jqmplc3ysygwladsnw1hfl44pgk9ync1ws";
      type = "gem";
    };
    version = "1.18.4";
  };
  cairo-gobject = {
    dependencies = [
      "cairo"
      "glib2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11r321vflqxc6kynmv2bw0xh9m6mnxdb788ha0na4xfffkhfs59z";
      type = "gem";
    };
    version = "4.3.5";
  };
  camping = {
    dependencies = [
      "mab"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q2a5x97pgnld0b8yziblp9fqkjyib4gfwv9gcyynyhswqwsldpf";
      type = "gem";
    };
    version = "2.1.532";
  };
  cf-uaa-lib = {
    dependencies = [
      "addressable"
      "base64"
      "httpclient"
      "json"
      "mutex_m"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dp89j7q4zllfn9yn5z0ld2v0sd8s6c9jkcbr6w1n0cy04lf2miw";
      type = "gem";
    };
    version = "4.0.9";
  };
  cf-uaac = {
    dependencies = [
      "cf-uaa-lib"
      "em-http-request"
      "eventmachine"
      "highline"
      "json"
      "launchy"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bh24pdbw9dh5a9lmbnn52ppvv2pgcy3d500mn5kk4xvmmk1gyzn";
      type = "gem";
    };
    version = "4.30.0";
  };
  CFPropertyList = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qa226xndfs9r6c7qj7zs6yhzrcbmicvvxsjn9x3svakh3cx169c";
      type = "gem";
    };
    version = "3.0.8";
  };
  cgi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s8qdw1nfh3njd47q154njlfyc2llcgi4ik13vz39adqd7yclgz9";
      type = "gem";
    };
    version = "0.5.1";
  };
  charlock_holmes = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c1dws56r7p8y363dhyikg7205z59a3bn4amnv2y488rrq8qm7ml";
      type = "gem";
    };
    version = "0.7.9";
  };
  childprocess = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v5nalaarxnfdm6rxb7q6fmc6nx097jd630ax6h9ch7xw95li3cs";
      type = "gem";
    };
    version = "5.1.0";
  };
  claide = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bpqhc0kqjp1bh9b7ffc395l9gfls0337rrhmab4v46ykl45qg3d";
      type = "gem";
    };
    version = "1.1.0";
  };
  clamp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p2abxshwvj3khg7k3cfg3kcghqj9jfz6yh9nmz48q4vbhp23v9g";
      type = "gem";
    };
    version = "1.5.2";
  };
  cld3 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16n57vzkhsyjsmkb46n6pk4drcfvpy1mg3j4an9k21akr67qadmp";
      type = "gem";
    };
    version = "3.7.0";
  };
  cocoapods = {
    dependencies = [
      "addressable"
      "claide"
      "cocoapods-core"
      "cocoapods-deintegrate"
      "cocoapods-downloader"
      "cocoapods-plugins"
      "cocoapods-search"
      "cocoapods-trunk"
      "cocoapods-try"
      "colored2"
      "escape"
      "fourflusher"
      "gh_inspector"
      "molinillo"
      "nap"
      "ruby-macho"
      "xcodeproj"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0phyvpx78jlrpvldbxjmzq92mfx6l66va2fz2s5xpwrdydhciw8g";
      type = "gem";
    };
    version = "1.16.2";
  };
  cocoapods-acknowledgements = {
    dependencies = [
      "cocoapods"
      "redcarpet"
      "xcodeproj"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04gaijs4djjkynan06wyaxxz48db0czzfrhh95jn3r201k2ypa7k";
      type = "gem";
    };
    version = "1.3.0";
  };
  cocoapods-art = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qxwlsqwg6wa2aa3acf4jvgi3vpxlpdj8qq35jyhkyl16n4hrr1b";
      type = "gem";
    };
    version = "1.1.1";
  };
  cocoapods-browser = {
    dependencies = [ "cocoapods" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mq9mcw3xnf2nqkmcjg874sx422dbmfa99vhw31c9jb0cd4j3m9p";
      type = "gem";
    };
    version = "0.1.5";
  };
  cocoapods-clean = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16zy8xl94clblxivlcrw2jf3dnvmwlr6jni6kz74rnc8wj42sf1w";
      type = "gem";
    };
    version = "0.0.1";
  };
  cocoapods-clean_build_phases_scripts = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0syya8l1kz36069y7cx4f37aihpmbm4yd5wvifs3j8qzz8bpxpfi";
      type = "gem";
    };
    version = "0.0.3";
  };
  cocoapods-core = {
    dependencies = [
      "activesupport"
      "addressable"
      "algoliasearch"
      "concurrent-ruby"
      "fuzzy_match"
      "nap"
      "netrc"
      "public_suffix"
      "typhoeus"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ay1dwjg79rfa6mbfyy96in0k364dgn7s8ps6v7n07k9432bbcab";
      type = "gem";
    };
    version = "1.16.2";
  };
  cocoapods-coverage = {
    dependencies = [
      "cocoapods-testing"
      "slather"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zaid3awk470igr5yilx1wvj1jnh88fbjl11hp93a4qic7j3i6ca";
      type = "gem";
    };
    version = "0.0.6";
  };
  cocoapods-deintegrate = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18pnng0lv5z6kpp8hnki0agdxx979iq6hxkfkglsyqzmir22lz2i";
      type = "gem";
    };
    version = "1.0.5";
  };
  cocoapods-dependencies = {
    dependencies = [ "ruby-graphviz" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10ssv98af44698kp4w0wfdrc7x3ccf2w9dhcva6i7hwlffjvcsz3";
      type = "gem";
    };
    version = "1.3.0";
  };
  cocoapods-deploy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qnhl54z0dqyn0sk7rgn3vwmfax0yr3sk2r464h888d2qjxz6v7j";
      type = "gem";
    };
    version = "0.0.12";
  };
  cocoapods-disable-podfile-validations = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0csgcp2kkmciavnic1yrb8z405dg4lqkzdlw2zscahvggpwr0j2p";
      type = "gem";
    };
    version = "0.2.0";
  };
  cocoapods-downloader = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ldnwwsx44i2xsdmsmyz9xrar19lfy5s5xslvral1p3674dvwvmv";
      type = "gem";
    };
    version = "2.1";
  };
  cocoapods-expert-difficulty = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19shjj4kj9rqg1a3pax568q0w9rkq8jcba2mycvq0szbv7bw6pgl";
      type = "gem";
    };
    version = "1.0.0";
  };
  cocoapods-fix-react-native = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jhgg3amman51hvk0x7h1xqqdb71kfmbzfziaip6fxkl7sjr43ix";
      type = "gem";
    };
    version = "2019.09.17.15";
  };
  cocoapods-generate = {
    dependencies = [ "cocoapods-disable-podfile-validations" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0216rwc4r0z0a1gvckphn7x9qk7zn00ivc49kv0hgafmrmaf2wy3";
      type = "gem";
    };
    version = "2.2.5";
  };
  cocoapods-git_url_rewriter = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cmyrj92d781pkq1b6qbvpmxvfx8k3l36cdqsi46w55icjm1jqbw";
      type = "gem";
    };
    version = "1.0.1";
  };
  cocoapods-keys = {
    dependencies = [
      "dotenv"
      "ruby-keychain"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zycjq1i3kqzpixngm1jp66r075yrb54qcd0xxxa8rmxngimqhff";
      type = "gem";
    };
    version = "2.3.1";
  };
  cocoapods-open = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z9x1cqrz4zc6yd08clawi8gg7ip8vbhkh9lkrdkzw7i6lqyrp0j";
      type = "gem";
    };
    version = "0.0.8";
  };
  cocoapods-plugins = {
    dependencies = [ "nap" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16na82sfyc8801qs1n22nwq486s4j7yj6rj7fcp8cbxmj371fpbj";
      type = "gem";
    };
    version = "1.0.0";
  };
  cocoapods-search = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12amy0nknv09bvzix8bkmcjn996c50c4ms20v2dl7v8rcw73n4qv";
      type = "gem";
    };
    version = "1.0.1";
  };
  cocoapods-testing = {
    dependencies = [ "xctasks" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03dqcz9pks7mbzq3zkfm2rzbjwkcwp8z3rip60d4pqs8b2bb61bg";
      type = "gem";
    };
    version = "0.0.6";
  };
  cocoapods-trunk = {
    dependencies = [
      "nap"
      "netrc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cgdx7z9psxxrsa13fk7qc9i6jskrwcafhrdz94avzia2y6dlnsz";
      type = "gem";
    };
    version = "1.6.0";
  };
  cocoapods-try = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1znyp625rql37ivb5rk9fk9564cmax8icxfr041ysivpdrn98nql";
      type = "gem";
    };
    version = "1.2.0";
  };
  cocoapods-try-release-fix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a7hbc5j0p507cyd9a0rd2mf2d525ia3gcnx7bdspxqnhl0a43bf";
      type = "gem";
    };
    version = "0.1.2";
  };
  cocoapods-update-if-you-dare = {
    dependencies = [ "colored2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nqvywrbfxiagip2vl9kj71h39g4idq1lshkxl5bqh1hq57g4k9q";
      type = "gem";
    };
    version = "0.2.0";
  };
  cocoapods-whitelist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kk4lkrzbnwb445hyidm64y8b9107gfxjxi5p2and53ixq0d31iy";
      type = "gem";
    };
    version = "0.6.1";
  };
  cocoapods-wholemodule = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03gr4r0aa9mrj8i27dd6l87jzq78sid3jbywmkazg3yrq6y38i21";
      type = "gem";
    };
    version = "0.0.1";
  };
  coderay = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  coffee-script = {
    dependencies = [
      "coffee-script-source"
      "execjs"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rc7scyk7mnpfxqv5yy4y5q1hx3i7q3ahplcp4bq2g5r24g2izl2";
      type = "gem";
    };
    version = "2.4.1";
  };
  coffee-script-source = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1907v9q1zcqmmyqzhzych5l7qifgls2rlbnbhy5vzyr7i7yicaz1";
      type = "gem";
    };
    version = "1.12.2";
  };
  colorator = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f7wvpam948cglrciyqd798gdc6z3cfijciavd0dfixgaypmvy72";
      type = "gem";
    };
    version = "1.1.0";
  };
  colored2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jlbqa9q4mvrm73aw9mxh23ygzbjiqwisl32d8szfb5fxvbjng5i";
      type = "gem";
    };
    version = "3.1.2";
  };
  commonmarker = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k9wa8fnfz08lyn86vpqhdv4jffznlxcx6p6qr11rdf7qy4jybfs";
      type = "gem";
    };
    version = "0.23.12";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1aymcakhzl83k77g2f2krz07bg1cbafbcd2ghvwr4lky3rz86mkb";
      type = "gem";
    };
    version = "1.3.6";
  };
  connection_pool = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02ifws3c4x7b54fv17sm4cca18d2pfw1saxpdji2lbd1f6xgbzrk";
      type = "gem";
    };
    version = "3.0.2";
  };
  cookiejar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1px0zlnlkwwp9prdkm2lamgy412y009646n2cgsa1xxsqk7nmc8i";
      type = "gem";
    };
    version = "0.3.4";
  };
  crabstone = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "154g3l1flndm5pvnhjnrn47ndnsxvfm8y1kv4zhnwiys28pv40nb";
      type = "gem";
    };
    version = "4.0.4";
  };
  crass = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    version = "1.0.6";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gz7r2kazwwwyrwi95hbnhy54kwkfac5swh2gy5p5vw36fn38lbf";
      type = "gem";
    };
    version = "3.3.5";
  };
  curb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ixcdcdiw13r5lgi313ysvpa8ijw55b592wanpnjns5xa2ncrsv4";
      type = "gem";
    };
    version = "1.2.2";
  };
  curses = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qkq83izdj0lzqwwf8c53b6dzcfcx47mzh5902yg9l1sabyjgkr6";
      type = "gem";
    };
    version = "1.6.0";
  };
  daemons = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07cszb0zl8mqmwhc8a2yfg36vi6lbgrp4pa5bvmryrpcz9v6viwg";
      type = "gem";
    };
    version = "1.4.1";
  };
  data_objects = {
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19fw1ckqc5f1wc4r72qrymy2k6cmd8azbxpn61ksbsjqhzc2bgqd";
      type = "gem";
    };
    version = "0.10.17";
  };
  date = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h0db8r2v5llxdbzkzyllkfniqw9gm092qn7cbaib73v9lw0c3bm";
      type = "gem";
    };
    version = "3.5.1";
  };
  dentaku = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ssmjs7x733n7x6zvcwkaq2rnl0sz1qslli19s730a7ny7pialqg";
      type = "gem";
    };
    version = "3.4.2";
  };
  dep-selector-libgecode = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09frwp3np5c64y8g5rnbl46n7riknmdjprhndsh6zzajkjr9m3xj";
      type = "gem";
    };
    version = "1.3.5";
  };
  diff-lcs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";
      type = "gem";
    };
    version = "1.6.2";
  };
  differ = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iayb71yqw5bgarq829fwchykw8lsqm8alnjc6c2m6k74fvnvkjy";
      type = "gem";
    };
    version = "0.1.2";
  };
  digest-sha3 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x8fcwqn6b1l227w38l4hy6i28cpbfbp2yrmklgfy8nb7hq2k1gk";
      type = "gem";
    };
    version = "1.0.2";
  };
  dip = {
    dependencies = [
      "json-schema"
      "public_suffix"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b3p0mjz6l4dya5k8z0nsq186r1yvkbkrwaqgrg23lr96l24r381";
      type = "gem";
    };
    version = "8.2.5";
  };
  dnsruby = {
    dependencies = [
      "base64"
      "logger"
      "simpleidn"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14p9i49ffm8y5vrzwhzgzjp11q8szycyiwz3nnnxws17zvsjgwvc";
      type = "gem";
    };
    version = "1.73.1";
  };
  do_sqlite3 = {
    dependencies = [ "data_objects" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gxz54qjgwg6a2mkqpai28m0i5swbyxpr4qmh9x1nwf20lysrgcf";
      type = "gem";
    };
    version = "0.10.17";
  };
  docile = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07pj4z3h8wk4fgdn6s62vw1lwvhj0ac0x10vfbdkr9xzk7krn5cn";
      type = "gem";
    };
    version = "1.4.1";
  };
  domain_name = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cyr2xm576gqhqicsyqnhanni47408w2pgvrfi8pd13h2li3nsaz";
      type = "gem";
    };
    version = "0.6.20240107";
  };
  dotenv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17b1zr9kih0i3wb7h4yq9i8vi6hjfq07857j437a8z7a44qvhxg3";
      type = "gem";
    };
    version = "3.2.0";
  };
  drb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wrkl7yiix268s2md1h6wh91311w95ikd8fy8m5gx589npyxc00b";
      type = "gem";
    };
    version = "2.2.3";
  };
  elftools = {
    dependencies = [ "bindata" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p96wj4sz3sfv9yxyl8z530554bkbf82vj24w6x7yf91qa1p8z6i";
      type = "gem";
    };
    version = "1.1.3";
  };
  em-http-request = {
    dependencies = [
      "addressable"
      "cookiejar"
      "em-socksify"
      "eventmachine"
      "http_parser.rb"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1azx5rgm1zvx7391sfwcxzyccs46x495vb34ql2ch83f58mwgyqn";
      type = "gem";
    };
    version = "1.1.7";
  };
  em-socksify = {
    dependencies = [
      "base64"
      "eventmachine"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vbl74x9m4hccmmhcnp36s50mn7d81annfj3fcqjdhdcm2khi3bx";
      type = "gem";
    };
    version = "0.3.3";
  };
  em-websocket = {
    dependencies = [
      "eventmachine"
      "http_parser.rb"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a66b0kjk6jx7pai9gc7i27zd0a128gy73nmas98gjz6wjyr4spm";
      type = "gem";
    };
    version = "0.5.3";
  };
  erb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ar4nmvk1sk7drjigqyh9nnps3mxg625b8chfk42557p8i6jdrlz";
      type = "gem";
    };
    version = "6.0.2";
  };
  erb-formatter = {
    dependencies = [ "syntax_tree" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nd46v4d6x5hr6afwx06rs7vqgjf1gb4rssnpa3a89wqgf4qilb4";
      type = "gem";
    };
    version = "0.7.3";
  };
  erubi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1naaxsqkv5b3vklab5sbb9sdpszrjzlfsbqpy7ncbnw510xi10m0";
      type = "gem";
    };
    version = "1.13.1";
  };
  escape = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sa1xkfc9jvkwyw1jbz3jhkq0ms1zrvswi6mmfiwcisg5fp497z4";
      type = "gem";
    };
    version = "0.0.4";
  };
  ethon = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17ix0mijpsy3y0c6ywrk5ibarmvqzjsirjyprpsy3hwax8fdm85v";
      type = "gem";
    };
    version = "0.16.0";
  };
  eventmachine = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  excon = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ddab9a8ry37nb9jl3h8kc9w5dbg15g6gd23h2dpsw8rlvnxin1j";
      type = "gem";
    };
    version = "1.4.2";
  };
  execjs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03a590q16nhqvfms0lh42mp6a1i41w41qpdnf39zjbq5y3l8pjvb";
      type = "gem";
    };
    version = "2.10.0";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "077n5ss3z3ds4vj54w201kd12smai853dp9c9n7ii7g3q7nwwg54";
      type = "gem";
    };
    version = "2.14.1";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v4hfmc7d4lrqqj2wl366rm9551gd08zkv2ppwwnjlnkc217aizi";
      type = "gem";
    };
    version = "3.4.2";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kqasqvy8d7r09ri4n6bkdwbk63j7afd9ilsw34nzlgh0qp69ldw";
      type = "gem";
    };
    version = "1.17.4";
  };
  ffi-compiler = {
    dependencies = [
      "ffi"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1844j58cdg2q6g0rqfwg4rrambnhf059h4yg9rfmrbrcs60kskx9";
      type = "gem";
    };
    version = "1.3.2";
  };
  ffi-rzmq-core = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0amkbvljpjfnv0jpdmz71p1i3mqbhyrnhamjn566w0c01xd64hb5";
      type = "gem";
    };
    version = "1.0.7";
  };
  fiddle = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vifygrkw22gcd4wzh8gc4pv6h1zpk6kll6mmprrf5174wvfxa3z";
      type = "gem";
    };
    version = "1.1.8";
  };
  fog-core = {
    dependencies = [
      "builder"
      "excon"
      "formatador"
      "mime-types"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rjv4iqr64arxv07bh84zzbr1y081h21592b5zjdrk937al8mq1z";
      type = "gem";
    };
    version = "2.6.0";
  };
  fog-dnsimple = {
    dependencies = [
      "fog-core"
      "fog-json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lbzkc0w96a62ahjw0b7mfbqgg9x2jp7khg5hvpbgw0kfs5xza63";
      type = "gem";
    };
    version = "2.1.0";
  };
  fog-json = {
    dependencies = [
      "fog-core"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zj8llzc119zafbmfa4ai3z5s7c4vp9akfs0f9l2piyvcarmlkyx";
      type = "gem";
    };
    version = "1.2.0";
  };
  formatador = {
    dependencies = [ "reline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "156qa2wiizmdalz6cim04yaasdz1q6c6k7yhnpdnrhn26f0qkyhr";
      type = "gem";
    };
    version = "1.2.3";
  };
  forwardable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f78rjpnhm4lgp1qzadnr6kr02b6afh1lvy7w607k4qjk3641kgi";
      type = "gem";
    };
    version = "1.4.0";
  };
  forwardable-extended = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15zcqfxfvsnprwm8agia85x64vjzr2w0xn9vxfnxzgcv8s699v0v";
      type = "gem";
    };
    version = "2.6.0";
  };
  fourflusher = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1afabh3g3gwj0ad53fs62waks815xcckf7pkci76l6vrghffcg8v";
      type = "gem";
    };
    version = "2.3.1";
  };
  fuzzy_match = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19gw1ifsgfrv7xdi6n61658vffgm1867f4xdqfswb2b5h6alzpmm";
      type = "gem";
    };
    version = "2.0.4";
  };
  gdk3 = {
    dependencies = [
      "cairo-gobject"
      "gdk_pixbuf2"
      "pango"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0al8pjkh6fnlgk6rsglc0vgkc7b55yfjnp01kql81l47c34q5xr7";
      type = "gem";
    };
    version = "4.3.5";
  };
  gdk_pixbuf2 = {
    dependencies = [
      "gio2"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qm63ssza25m768rsf4c9fg9w506gwvx183wd7lnwiycxb75a8pb";
      type = "gem";
    };
    version = "4.3.5";
  };
  gemoji = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vgklpmhdz98xayln5hhqv4ffdyrglzwdixkn5gsk9rj94pkymc0";
      type = "gem";
    };
    version = "3.0.1";
  };
  gettext = {
    dependencies = [
      "erubi"
      "locale"
      "prime"
      "racc"
      "text"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x1wpyy5mgn0523f4pyv7lpxs8b4s6pfvyi24nymd7vym9cjr85d";
      type = "gem";
    };
    version = "3.5.2";
  };
  gh_inspector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f8r9byajj3bi2c7c5sqrc7m0zrv3nblfcd4782lw5l73cbsgk04";
      type = "gem";
    };
    version = "1.1.3";
  };
  gio2 = {
    dependencies = [
      "fiddle"
      "gobject-introspection"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kr0nizlx4q9lfiwra1343n9b8fvkv03lfvgj7p4drxag35pbmc3";
      type = "gem";
    };
    version = "4.3.5";
  };
  git = {
    dependencies = [
      "activesupport"
      "addressable"
      "process_executer"
      "rchardet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01r9a8wbqwzg5ca7qvq8rvgcp98wc7i36333vjgdv35vfdjp1c53";
      type = "gem";
    };
    version = "4.3.2";
  };
  github-pages = {
    dependencies = [
      "github-pages-health-check"
      "jekyll"
      "jekyll-avatar"
      "jekyll-coffeescript"
      "jekyll-commonmark-ghpages"
      "jekyll-default-layout"
      "jekyll-feed"
      "jekyll-gist"
      "jekyll-github-metadata"
      "jekyll-include-cache"
      "jekyll-mentions"
      "jekyll-optional-front-matter"
      "jekyll-paginate"
      "jekyll-readme-index"
      "jekyll-redirect-from"
      "jekyll-relative-links"
      "jekyll-remote-theme"
      "jekyll-sass-converter"
      "jekyll-seo-tag"
      "jekyll-sitemap"
      "jekyll-swiss"
      "jekyll-theme-architect"
      "jekyll-theme-cayman"
      "jekyll-theme-dinky"
      "jekyll-theme-hacker"
      "jekyll-theme-leap-day"
      "jekyll-theme-merlot"
      "jekyll-theme-midnight"
      "jekyll-theme-minimal"
      "jekyll-theme-modernist"
      "jekyll-theme-primer"
      "jekyll-theme-slate"
      "jekyll-theme-tactile"
      "jekyll-theme-time-machine"
      "jekyll-titles-from-headings"
      "jemoji"
      "kramdown"
      "kramdown-parser-gfm"
      "liquid"
      "mercenary"
      "minima"
      "nokogiri"
      "rouge"
      "terminal-table"
      "webrick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11r22g1j9x2gjaxjk78z2nm5wkirsjlz8iswwi67wqi7fcyljh1b";
      type = "gem";
    };
    version = "232";
  };
  github-pages-health-check = {
    dependencies = [
      "addressable"
      "dnsruby"
      "octokit"
      "public_suffix"
      "typhoeus"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gc431xd6vwrh1p7pc3gp3xn7sy1w7dr7f95hmz4fqa1b97kv2fz";
      type = "gem";
    };
    version = "1.18.2";
  };
  gitlab-markup = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bm0zccj88aavy23vqy1pkz4gmbw6gdb40n0wqlz7a332j3iq6lm";
      type = "gem";
    };
    version = "2.0.0";
  };
  glib2 = {
    dependencies = [
      "native-package-installer"
      "pkg-config"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05ai4zylpag3lcpwv413cjpf4cakag18dz9bapp7a7172b0a1wpm";
      type = "gem";
    };
    version = "4.3.5";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04gzhqvsm4z4l12r9dkac9a75ah45w186ydhl0i4andldsnkkih5";
      type = "gem";
    };
    version = "1.3.0";
  };
  gobject-introspection = {
    dependencies = [ "glib2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vdzw1jk5m3x4giycjsff8y6489gav0my95000lqrdhprd1qsvpd";
      type = "gem";
    };
    version = "4.3.5";
  };
  gpgme = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1amb4f0hgwdlz9dzblfpsidays3mb4cg65plwr0m6x1vp0pgvsqs";
      type = "gem";
    };
    version = "2.0.26";
  };
  gtk3 = {
    dependencies = [
      "atk"
      "gdk3"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16cda0r9z741gsbj5v6b2pwfhnlf16vm2avxam6h5pacajb2azhg";
      type = "gem";
    };
    version = "4.3.5";
  };
  haml = {
    dependencies = [
      "temple"
      "thor"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nnmzj6g2wynxbrp9j885zab4nkzfryhl2bv6cj1gazyyxqjpzc7";
      type = "gem";
    };
    version = "7.2.0";
  };
  hashie = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w1qrab701d3a63aj2qavwc2fpcqmkzzh1w2x93c88zkjqc4frn2";
      type = "gem";
    };
    version = "5.1.0";
  };
  highline = {
    dependencies = [ "reline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jmvyhjp2v3iq47la7w6psrxbprnbnmzz0hxxski3vzn356x7jv7";
      type = "gem";
    };
    version = "3.1.2";
  };
  hike = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hbhmchyhm1xf632cczmyg3fsbn7zly988q3fjpi8l3nb4cn40xj";
      type = "gem";
    };
    version = "2.1.3";
  };
  hitimes = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bx09c9zfjhp3pbyvsf8il9sdn64mnydcxs13mqk574ngvccmhm9";
      type = "gem";
    };
    version = "3.1.0";
  };
  hpricot = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jn8x9ch79gqmnzgyz78kppavjh5lqx0y0r6frykga2b86rz9s6z";
      type = "gem";
    };
    version = "0.8.6";
  };
  html-pipeline = {
    dependencies = [
      "activesupport"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "180kjksi0sdlqb0aq0bhal96ifwqm25hzb3w709ij55j51qls7ca";
      type = "gem";
    };
    version = "2.14.3";
  };
  htmlbeautifier = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nrqvgja3pbmz4v27zc5ir58sk4mv177nq7hlssy2smawbvhhgdl";
      type = "gem";
    };
    version = "1.4.3";
  };
  http = {
    dependencies = [
      "addressable"
      "http-cookie"
      "http-form_data"
      "llhttp-ffi"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z8x4c2bcg05x7ffrjy47cwarfqzlg8kcfxchk5jcfdyx7c04265";
      type = "gem";
    };
    version = "5.3.1";
  };
  http-accept = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09m1facypsdjynfwrcv19xcb1mqg8z6kk31g8r33pfxzh838c9n6";
      type = "gem";
    };
    version = "1.7.0";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06dvmngd4hwrr6k774i1h6c50h2l8nww9f1id0wvrvi72l6yd99q";
      type = "gem";
    };
    version = "1.1.0";
  };
  http-form_data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wx591jdhy84901pklh1n9sgh74gnvq1qyqxwchni1yrc49ynknc";
      type = "gem";
    };
    version = "2.3.0";
  };
  "http_parser.rb" = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yh924g697spcv4hfigyxgidhyy6a7b9007rnac57airbcadzs4s";
      type = "gem";
    };
    version = "0.8.1";
  };
  httpclient = {
    dependencies = [ "mutex_m" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j4qwj1nv66v3n9s4xqf64x2galvjm630bwa5xngicllwic5jr2b";
      type = "gem";
    };
    version = "2.9.0";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1994i044vdmzzkyr76g8rpl1fq1532wf0sb21xg5r1ilj5iphmr8";
      type = "gem";
    };
    version = "1.14.8";
  };
  iconv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "039md3wq0hb6zigqgb8y2p9h0dqdz5ig47ndyhc3mvfic3hbkhka";
      type = "gem";
    };
    version = "1.1.1";
  };
  idn-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dy04jx3n1ddz744b80mg7hp87miysnjp0h21lqr43hpmhdglxih";
      type = "gem";
    };
    version = "0.1.5";
  };
  indieweb-endpoints = {
    dependencies = [
      "http"
      "link-header-parser"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yqy5clqrqwprmk8vwzni0vdgyvbzm5x36bj33qhv5b11kgskbwp";
      type = "gem";
    };
    version = "8.0.0";
  };
  io-console = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k0lk3pwadm2myvpg893n8jshmrf2sigrd4ki15lymy7gixaxqyn";
      type = "gem";
    };
    version = "0.8.2";
  };
  irb = {
    dependencies = [
      "pp"
      "prism"
      "rdoc"
      "reline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bishrxfn2anwlagw8rzly7i2yicjnr947f48nh638yqjgdlv30n";
      type = "gem";
    };
    version = "1.17.0";
  };
  jaro_winkler = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nja0hjdn9kil7m0y8c0km0haz6ln25alp66q4kpvgq5rnjhbald";
      type = "gem";
    };
    version = "1.7.0";
  };
  jbuilder = {
    dependencies = [
      "actionview"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hmvz9lhx37x43gnms17hfczjwfj7i9xfvzxnh611vv0zxv67cjf";
      type = "gem";
    };
    version = "2.14.1";
  };
  jekyll = {
    dependencies = [
      "addressable"
      "colorator"
      "csv"
      "em-websocket"
      "i18n"
      "jekyll-sass-converter"
      "jekyll-watch"
      "kramdown"
      "liquid"
      "mercenary"
      "pathutil"
      "rouge"
      "safe_yaml"
      "webrick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "144dvgqffkkp34763hj0wh1qabd0fq22sx7bk7afgpy73mv3n8f4";
      type = "gem";
    };
    version = "3.10.0";
  };
  jekyll-archives = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xkm6f0zvb7mb89nyqncids1rqm6a90smjg23zlaryqj4bi8rg9d";
      type = "gem";
    };
    version = "2.3.0";
  };
  jekyll-avatar = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jzxmfcljfvjz21wls2w5mr2m5qp0mq9c80j009s4m6yq9vn4wza";
      type = "gem";
    };
    version = "0.8.0";
  };
  jekyll-coffeescript = {
    dependencies = [
      "coffee-script"
      "coffee-script-source"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "040i6cyv20qmxlpm74kh5hfci8208ja4903yxdv4x0qs0z172kl9";
      type = "gem";
    };
    version = "1.2.2";
  };
  jekyll-commonmark = {
    dependencies = [ "commonmarker" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i281yiwqiim6jzh7b8hgg8zifs5mn1qz1z6f4109kh9zrcfcc8p";
      type = "gem";
    };
    version = "1.4.0";
  };
  jekyll-commonmark-ghpages = {
    dependencies = [
      "commonmarker"
      "jekyll"
      "jekyll-commonmark"
      "rouge"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19544wfdcdh52qw76m6ayv6zbdabqv9wdfp1wqjmdr4k6gr24rym";
      type = "gem";
    };
    version = "0.5.1";
  };
  jekyll-default-layout = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1br08grgv7h36jhlvzfaa3ikp1zz4b6s57ak4fhzrsjx997bw9n6";
      type = "gem";
    };
    version = "0.1.5";
  };
  jekyll-favicon = {
    dependencies = [
      "jekyll"
      "mini_magick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gxz6db4gdz2x305xlfxi3lanndbx2nagqfl8qjnjzshxzq7zdyr";
      type = "gem";
    };
    version = "0.2.9";
  };
  jekyll-feed = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hzwmjrxi57x68i7jx5rxi8qlcbqcbg3di55wywrp53pr0bap6k8";
      type = "gem";
    };
    version = "0.17.0";
  };
  jekyll-gist = {
    dependencies = [ "octokit" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03wz9j6yq3552nzf4g71qrdm9pfdgbm68abml9sjjgiaan1n8ns9";
      type = "gem";
    };
    version = "1.5.0";
  };
  jekyll-github-metadata = {
    dependencies = [
      "jekyll"
      "octokit"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k2vnq6ns0x3iwnp8pw9lbxds924wmqswzy0gd57f95gpn49kwjc";
      type = "gem";
    };
    version = "2.16.1";
  };
  jekyll-include-cache = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01d2l6qrmjc42664ns83cv36jbvalcxqbkmj5i22fakka7jvkm67";
      type = "gem";
    };
    version = "0.2.1";
  };
  jekyll-mentions = {
    dependencies = [
      "html-pipeline"
      "jekyll"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1n8y67plydfmay3jn865igvgb3h6s2crk8kq7ydk3wmn9h103s1r";
      type = "gem";
    };
    version = "1.6.0";
  };
  jekyll-optional-front-matter = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06vnxcmgkxm5nvrpv89qq0afjlxmadv63nh4ryglcwhlf4fhdp7c";
      type = "gem";
    };
    version = "0.3.2";
  };
  jekyll-paginate = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r7bcs8fq98zldih4787zk5i9w24nz5wa26m84ssja95n3sas2l8";
      type = "gem";
    };
    version = "1.1.0";
  };
  jekyll-readme-index = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0chybr1zgnrmc7zf6psszcqnlrcy2jar8h77kci51lxj8vgc8k6p";
      type = "gem";
    };
    version = "0.3.0";
  };
  jekyll-redirect-from = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nz6kd6qsa160lmjmls4zgx7fwcpp8ac07mpzy80z6zgd7jwldb6";
      type = "gem";
    };
    version = "0.16.0";
  };
  jekyll-relative-links = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vfx90ajxyj24lz406k3pqknlbzy8nqs7wpz0in4ps9rggsh24yi";
      type = "gem";
    };
    version = "0.6.1";
  };
  jekyll-remote-theme = {
    dependencies = [
      "addressable"
      "jekyll"
      "jekyll-sass-converter"
      "rubyzip"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h2bwl42dig0282366kpxazxb8xafnppnd4yvq2dzcsg90kfgzfk";
      type = "gem";
    };
    version = "0.4.3";
  };
  jekyll-sass-converter = {
    dependencies = [ "sass" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "008ikh5fk0n6ri54mylcl8jn0mq8p2nfyfqif2q3pp0lwilkcxsk";
      type = "gem";
    };
    version = "1.5.2";
  };
  jekyll-seo-tag = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0638mqhqynghnlnaz0xi1kvnv53wkggaq94flfzlxwandn8x2biz";
      type = "gem";
    };
    version = "2.8.0";
  };
  jekyll-sitemap = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0622rwsn5i0m5xcyzdn86l68wgydqwji03lqixdfm1f1xdfqrq0d";
      type = "gem";
    };
    version = "1.4.0";
  };
  jekyll-spaceship = {
    dependencies = [
      "gemoji"
      "jekyll"
      "nokogiri"
      "rainbow"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "142bp48vq9aqwpqig54anbv7ncwqv1h78mbqhckmnx0glnqlkyzh";
      type = "gem";
    };
    version = "0.10.2";
  };
  jekyll-swiss = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18w893f2snpbvgl80jnmq3xxsl5yi5a5qm11iy3gx0d8viasi6f2";
      type = "gem";
    };
    version = "1.0.0";
  };
  jekyll-theme-architect = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h04zxlcdsb73qxh08xmsc36gmj95plwxr9g5zwzqd3bmbfd6xbj";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-theme-cayman = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ajzhqhnj8gc5ns7i69kh69mzidvxkjs7yblrhzb13iaqzwi8prw";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-theme-dinky = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z1clccf4q0g2zzhl1hfy3x2rcdjs6bzs9ab76lkmpphj5q2a2vj";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-theme-hacker = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12ppp0bxffy838p4my79nppq112fazifr3cxwvhv3l6yjbwzjsw1";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-theme-leap-day = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lf7bbpr2s2rir2nf07rnh2g9mjy6zidpacs3j45la70b8qah7lj";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-theme-merlot = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ifmvq44vwmkp6sb79ys8lx5w24gn3dhdr32bg562da2c8dv5wnb";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-theme-midnight = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1plindxr5vrk98frzxbnkashgnqs86xkg26rjmhgz0qf6mkz77q0";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-theme-minimal = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10idwpbqjqfc5i895ijf74ac79lccxpz30bvwp4x4fjp6l6229d2";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-theme-modernist = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kzvdnk1vw8y6x8gy340mhnxipxh9p1h1h20br68clyxbsy7brsb";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-theme-primer = {
    dependencies = [
      "jekyll"
      "jekyll-github-metadata"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cq7lfwa3xs8hkx3cmv2ics7cr4r2azv66m0gfav0zi1k0kjh9yf";
      type = "gem";
    };
    version = "0.6.0";
  };
  jekyll-theme-slate = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f9l7kaafab2cphkx8gh4b12d8zzbg2ig7x2qzxvxfqjwyfr0h2y";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-theme-tactile = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0li64hnjp4qw7fwsdx0767z7mwxn3kri6sqlg9fkicnmmr41p1mp";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-theme-time-machine = {
    dependencies = [
      "jekyll"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qjgsw2n3zny345h540n6rm9600mad7rs33qf6k4rhngxjkr0d5w";
      type = "gem";
    };
    version = "0.2.0";
  };
  jekyll-titles-from-headings = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10c4sa3gwyidmkcs8h6223lmqpw3h09mn7w8hxfppsk1wda6fdkp";
      type = "gem";
    };
    version = "0.5.3";
  };
  jekyll-watch = {
    dependencies = [ "listen" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qd7hy1kl87fl7l0frw5qbn22x7ayfzlv9a5ca1m59g0ym1ysi5w";
      type = "gem";
    };
    version = "2.2.1";
  };
  jekyll-webmention_io = {
    dependencies = [
      "activesupport"
      "htmlbeautifier"
      "jekyll"
      "json"
      "jsonpath"
      "openssl"
      "uglifier"
      "webmention"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03xq3fkjx1wb2cfix8yngpmzxrpbhw6rivh0jsr0kkla2ahc5s1q";
      type = "gem";
    };
    version = "4.1.0";
  };
  jemoji = {
    dependencies = [
      "gemoji"
      "html-pipeline"
      "jekyll"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z4yabsvqdb8x1rr60yyzbaf950cyzv984n3jwwvgcmv5j73wk2x";
      type = "gem";
    };
    version = "0.13.0";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      type = "gem";
    };
    version = "1.6.2";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0il6qxkxqql7n7sgrws5bi5a36v51dswqcxb6j6gm8aj62shp6r8";
      type = "gem";
    };
    version = "2.19.3";
  };
  json-schema = {
    dependencies = [
      "addressable"
      "bigdecimal"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ma0k5889hzydba2ci8lqg87pxsh9zabz7jchm9cbacwsw7axgk0";
      type = "gem";
    };
    version = "5.2.2";
  };
  json_pure = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kks889ymaq5xqvj18qamar3il8m3dnnaf6cij0a0kwxp8lpk1va";
      type = "gem";
    };
    version = "2.8.1";
  };
  jsonpath = {
    dependencies = [ "multi_json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xxklfvmwz8z6l08704x65gnq6r8r1pb9qk125qjbndnb1zz6fsp";
      type = "gem";
    };
    version = "1.0.7";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dfm4bhl4fzn076igh0bmh2v1vphcrxdv6ldc46hdd3bkbqr2sdg";
      type = "gem";
    };
    version = "3.1.2";
  };
  keystone-engine = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0waz2bj1dsl63416k1n0vvrwva425rm94gsza7ci49mm1wjdabh2";
      type = "gem";
    };
    version = "0.9.0";
  };
  kramdown = {
    dependencies = [ "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ic14hdcqxn821dvzki99zhmcy130yhv5fqfffkcf87asv5mnbmn";
      type = "gem";
    };
    version = "2.4.0";
  };
  kramdown-parser-gfm = {
    dependencies = [ "kramdown" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a8pb3v951f4x7h968rqfsa19c8arz21zw1vaj42jza22rap8fgv";
      type = "gem";
    };
    version = "1.1.0";
  };
  kramdown-rfc2629 = {
    dependencies = [
      "base64"
      "differ"
      "json_pure"
      "kramdown"
      "kramdown-parser-gfm"
      "net-http-persistent"
      "ostruct"
      "unicode-blocks"
      "unicode-name"
      "unicode-scripts"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vm9wbvw33xiwp42vl2slaby41rqf7l0c2zya6rvf7j37cfww8b5";
      type = "gem";
    };
    version = "1.7.35";
  };
  language_server-protocol = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k0311vah76kg5m6zr7wmkwyk5p2f9d9hyckjpn3xgr83ajkj7px";
      type = "gem";
    };
    version = "3.17.0.5";
  };
  launchy = {
    dependencies = [
      "addressable"
      "childprocess"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17h522xhwi5m4n6n9m22kw8z0vy8100sz5f3wbfqj5cnrjslgf3j";
      type = "gem";
    };
    version = "3.1.1";
  };
  libxml-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16jfgrgb3ys7lk4b7m6s5kg3jdd5w976k6hmf1fmbpw254ahgg7i";
      type = "gem";
    };
    version = "5.0.5";
  };
  link-header-parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bm32imabc12rjjw8ysca55c99flcsichynfflphxy8gda07dj9x";
      type = "gem";
    };
    version = "5.1.1";
  };
  lint_roller = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11yc0d84hsnlvx8cpk4cbj6a4dz9pk0r1k29p0n1fz9acddq831c";
      type = "gem";
    };
    version = "1.1.0";
  };
  liquid = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1czxv2i1gv3k7hxnrgfjb0z8khz74l4pmfwd70c7kr25l2qypksg";
      type = "gem";
    };
    version = "4.0.4";
  };
  listen = {
    dependencies = [
      "logger"
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ln9c0vx165hkfbn2817qw4m6i77xcxh6q0r5v6fqfhlcbdq5qf6";
      type = "gem";
    };
    version = "3.10.0";
  };
  llhttp-ffi = {
    dependencies = [
      "ffi-compiler"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g57iw0l3y7x50132x6a1jyssxa6pw7srh69g0d6j7ri37yaf9cs";
      type = "gem";
    };
    version = "0.5.1";
  };
  locale = {
    dependencies = [ "fiddle" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x1fnf4knvyzb9br6ja7b1nvy0860nax0i8rx4ljrnvbmbl06s0w";
      type = "gem";
    };
    version = "2.1.5";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  loofah = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "011fdngxzr1p9dq2hxqz7qq1glj2g44xnhaadjqlf48cplywfdnl";
      type = "gem";
    };
    version = "2.25.1";
  };
  mab = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0manxbilpx0hdi19lhdsr4ncvbzgmwh279b64j8w60dg0p0i4b4j";
      type = "gem";
    };
    version = "0.0.3";
  };
  magic = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18vkdq2748wxg0kr923fbhx92wikh2dwv2hp8xind57qs7gn26pr";
      type = "gem";
    };
    version = "0.2.9";
  };
  mail = {
    dependencies = [
      "logger"
      "mini_mime"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ha9sgkfqna62c1basc17dkx91yk7ppgjq32k4nhrikirlz6g9kg";
      type = "gem";
    };
    version = "2.9.0";
  };
  marcel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vhb1sbzlq42k2pzd9v0w5ws4kjx184y8h4d63296bn57jiwzkzx";
      type = "gem";
    };
    version = "1.1.0";
  };
  markaby = {
    dependencies = [ "builder" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vizqpa9pks5nlqj0jjx2d1q6f9vfmjjbb774v1kp591pq5nhmcm";
      type = "gem";
    };
    version = "0.9.4";
  };
  matrix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nscas3a4mmrp1rc07cdjlbbpb2rydkindmbj3v3z5y1viyspmd0";
      type = "gem";
    };
    version = "0.4.3";
  };
  mercenary = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10la0xw82dh5mqab8bl0dk21zld63cqxb1g16fk8cb39ylc4n21a";
      type = "gem";
    };
    version = "0.3.6";
  };
  method_source = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1igmc3sq9ay90f8xjvfnswd1dybj1s3fi0dwd53inwsvqk4h24qq";
      type = "gem";
    };
    version = "1.1.0";
  };
  mime-types = {
    dependencies = [
      "logger"
      "mime-types-data"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mjyxl7c0xzyqdqa8r45hqg7jcw2prp3hkp39mdf223g4hfgdsyw";
      type = "gem";
    };
    version = "3.7.0";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19cpbiwrfib7ai83l16az1gfyl3n5v2k430v40mjwlvjmhgjp579";
      type = "gem";
    };
    version = "3.2026.0331";
  };
  mini_magick = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1i2ilgjfjqc6sw4cwa4g9w3ngs41yvvazr9y82vapp5sfvymsf99";
      type = "gem";
    };
    version = "5.3.1";
  };
  mini_mime = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12f2830x7pq3kj0v8nz0zjvaw02sv01bqs1zwdrc04704kwcgmqc";
      type = "gem";
    };
    version = "2.8.9";
  };
  minima = {
    dependencies = [
      "jekyll"
      "jekyll-feed"
      "jekyll-seo-tag"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gk7jmriiswda1ykjzpsw9cpiya4m9n0yrh0h6xnrc8zcfy543jj";
      type = "gem";
    };
    version = "2.5.1";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mbpz92ml19rcxxfjrj91gmkif9khb1xpzyw38f81rvglgw1ffrd";
      type = "gem";
    };
    version = "5.27.0";
  };
  molinillo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p846facmh1j5xmbrpgzadflspvk7bzs3sykrh5s7qi4cdqz5gzg";
      type = "gem";
    };
    version = "0.8.0";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cnpnbn2yivj9gxkh8mjklbgnpx6nf7b8j2hky01dl0040hy0k76";
      type = "gem";
    };
    version = "1.8.0";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1drisvysgvnjlz49a0qcbs294id6mvj3i8iik5rvym68ybwfzvvs";
      type = "gem";
    };
    version = "1.19.1";
  };
  mustermann = {
    dependencies = [ "ruby2_keywords" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08ma2fmxlm6i7lih4mc3har2fzsbj1pl4hhva65kljf6nfvdryl5";
      type = "gem";
    };
    version = "3.0.4";
  };
  mutex_m = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l875dw0lk7b2ywa54l0wjcggs94vb7gs8khfw9li75n2sn09jyg";
      type = "gem";
    };
    version = "0.3.0";
  };
  mysql2 = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ywxbvx2blswi6zfjxsqz8jz1c0giivin2h4j9qqmbm02pjys2ds";
      type = "gem";
    };
    version = "0.5.7";
  };
  nanaimo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08q73nchv8cpk28h1sdnf5z6a862fcf4mxy1d58z25xb3dankw7s";
      type = "gem";
    };
    version = "0.4.0";
  };
  nap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xm5xssxk5s03wjarpipfm39qmgxsalb46v1prsis14x1xk935ll";
      type = "gem";
    };
    version = "1.1.0";
  };
  native-package-installer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bvr9q7qwbmg9jfg85r1i5l7d0yxlgp0l2jg62j921vm49mipd7v";
      type = "gem";
    };
    version = "1.1.9";
  };
  ncursesw = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x06374njjl4xfxwkp6nq71akhazmqp9fyhkgxf6gac81p5wwdk6";
      type = "gem";
    };
    version = "1.4.13";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15k96fj6qwbaiv6g52l538ass95ds1qwgynqdridz29yqrkhpfi5";
      type = "gem";
    };
    version = "0.9.1";
  };
  net-http-persistent = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rk03449disq3azyiymv1c3qnpqr6cxawgq556rkf5b9klqyhggg";
      type = "gem";
    };
    version = "4.0.8";
  };
  net-imap = {
    dependencies = [
      "date"
      "net-protocol"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bgjhb65r1bl52wdym6wpbb0r3j7va8s44grggp0jvarfvw7bawv";
      type = "gem";
    };
    version = "0.6.3";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wyz41jd4zpjn0v1xsf9j778qx1vfrl24yc20cpmph8k42c4x2w4";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a32l4x73hz200cm587bc29q8q9az278syw3x6fkc9d1lv5y0wxa";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-scp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p8s7l4pr6hkn0l6rxflsc11alwi1kfg5ysgvsq61lz5l690p6x9";
      type = "gem";
    };
    version = "4.1.0";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dh7nzjp0fiaqq1jz90nv4nxhc2w359d7c199gmzq965cfps15pd";
      type = "gem";
    };
    version = "0.5.1";
  };
  net-ssh = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m1d6rs40rjvdb6df34fi3za1c2ajdiydv4jzpjj03iq7hhrw0k5";
      type = "gem";
    };
    version = "7.3.2";
  };
  netrc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  nio4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18fwy5yqnvgixq3cn0h63lm8jaxsjjxkmj8rhiv8wpzv9271d43c";
      type = "gem";
    };
    version = "2.7.5";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mhp90nf3g3yy5vgjnwd34czi6rbi0p7057vgngfmmdkknsxiz9q";
      type = "gem";
    };
    version = "1.19.2";
  };
  numo-narray = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "95c05257349b954c027c2284834408736244662a";
      sha256 = "0babqazhasc4df8iccl6wrabdq2mlls9fj694g7fjw99zzrbmghj";
      type = "git";
      url = "https://github.com/ruby-numo/numo-narray.git";
    };
    version = "0.9.2.1";
  };
  observer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b2h1642jy1xrgyakyzz6bkq43gwp8yvxrs8sww12rms65qi18yq";
      type = "gem";
    };
    version = "0.1.2";
  };
  octokit = {
    dependencies = [
      "faraday"
      "sawyer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15lvy06h276jryxg19258b2yqaykf0567sp0n16yipywhbp94860";
      type = "gem";
    };
    version = "4.25.1";
  };
  og-corefoundation = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xmz13rb92xy55askn5f3kkmz14qwyyhkdsikk2gd1ydicnaqkh8";
      type = "gem";
    };
    version = "0.2.3";
  };
  one_gadget = {
    dependencies = [ "elftools" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v079xkzzr1bjff5z2wlzs0k11nk4b04kgy1p63lwhbl12jl7qz1";
      type = "gem";
    };
    version = "1.7.4";
  };
  open3 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lirpxrqk2bw02m3p4g8r50h37qkr0ssmh9q2hh52qsj2chpsbcf";
      type = "gem";
    };
    version = "0.2.1";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v0grpg9gi59zr3imxy1745k9rp3dd095mkir8gvxi69blhh2kkz";
      type = "gem";
    };
    version = "3.3.2";
  };
  optimist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kp3f8g7g7cbw5vfkmpdv71pphhpcxk3lpc892mj9apkd7ys1y4c";
      type = "gem";
    };
    version = "3.2.1";
  };
  opus-ruby = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lyf2a8f1w1jk0qrl8h0gsydfalbh19g5k2c6xlq8j1sfzb0ij4d";
      type = "gem";
    };
    version = "1.0.1";
  };
  os = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gwd20smyhxbm687vdikfh1gpi96h8qb1x28s2pdcysf6dm6v0ap";
      type = "gem";
    };
    version = "1.1.4";
  };
  ostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04nrir9wdpc4izqwqbysxyly8y7hsfr4fsv69rw91lfi9d5fv8lm";
      type = "gem";
    };
    version = "0.6.3";
  };
  ovirt-engine-sdk = {
    dependencies = [ "json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14b8mgq7zgryxpq5jvrcls4hqjg1i2lqxakhgipdg4s3zr4sidvf";
      type = "gem";
    };
    version = "4.6.1";
  };
  pandocomatic = {
    dependencies = [
      "logger"
      "optimist"
      "paru"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y3cs1c6bvrbpdwdvjhs8qx256xkipfmr1418bxr23k63qqqjz23";
      type = "gem";
    };
    version = "2.2.0";
  };
  pango = {
    dependencies = [
      "cairo-gobject"
      "gobject-introspection"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13cgixfb5dxcpwiv2jp3f6r7pf5l4fdc66psacgvz9hrnwh9mjqa";
      type = "gem";
    };
    version = "4.3.5";
  };
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c719bfgcszqvk9z47w2p8j2wkz5y35k48ywwas5yxbbh3hm3haa";
      type = "gem";
    };
    version = "1.27.0";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0m2xqvn1la62hji1mn04y59giikww95p2hs0r4y2rrz3mdxcwyni";
      type = "gem";
    };
    version = "3.3.11.1";
  };
  paru = {
    dependencies = [ "csv" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ackpk4z2y11llvzb88q85k2177yki3vkp73sah5zwn4ikmr298k";
      type = "gem";
    };
    version = "1.5.2";
  };
  pastel = {
    dependencies = [ "tty-color" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xash2gj08dfjvq4hy6l1z22s5v30fhizwgs10d6nviggpxsj7a8";
      type = "gem";
    };
    version = "0.8.0";
  };
  pathutil = {
    dependencies = [ "forwardable-extended" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12fm93ljw9fbxmv2krki5k5wkvr7560qy8p4spvb9jiiaqv78fz4";
      type = "gem";
    };
    version = "0.16.2";
  };
  patron = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "029vmc5kbhd9qmq3v2nz7yjhm5xy34gaf69g3ra751q29903gbn4";
      type = "gem";
    };
    version = "0.13.4";
  };
  pcaprub = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ag6p7n5s1s3mcsqw8rzafz5dlanwwqfkh7sb44qlp0dq8bvh73v";
      type = "gem";
    };
    version = "0.13.3";
  };
  pg = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16caca7lcz5pwl82snarqrayjj9j7abmxqw92267blhk7rbd120k";
      type = "gem";
    };
    version = "1.6.3";
  };
  pkg-config = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cy75ssbwjzi9z3zwfx2zq3b8xvpy9rbdf1rnhi3v612acfgiy9k";
      type = "gem";
    };
    version = "1.6.5";
  };
  polyglot = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
      type = "gem";
    };
    version = "0.3.5";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xlxmg86k5kifci1xvlmgw56x88dmqf04zfzn7zcr4qb8ladal99";
      type = "gem";
    };
    version = "0.6.3";
  };
  prettier = {
    dependencies = [
      "syntax_tree"
      "syntax_tree-haml"
      "syntax_tree-rbs"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iavhgs7iahjz28sks5kkml9gr43fx5rpq5l0ql81pkmfv3i0cbi";
      type = "gem";
    };
    version = "4.0.4";
  };
  prettier_print = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ybgks9862zmlx71zd4j20ky86fsrp6j6m0az4hzzb1zyaskha57";
      type = "gem";
    };
    version = "1.2.1";
  };
  prettyprint = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14zicq3plqi217w6xahv7b8f7aj5kpxv1j1w98344ix9h5ay3j9b";
      type = "gem";
    };
    version = "0.2.0";
  };
  prime = {
    dependencies = [
      "forwardable"
      "singleton"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pi2g9sd9ssyrpvbybh4skrgzqrv0rrd1q7ylgrsd519gjzmwxad";
      type = "gem";
    };
    version = "0.1.4";
  };
  prism = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11ggfikcs1lv17nhmhqyyp6z8nq5pkfcj6a904047hljkxm0qlvv";
      type = "gem";
    };
    version = "1.9.0";
  };
  process_executer = {
    dependencies = [ "track_open_instances" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w9shxwkavrza37plgwkmp2kxqr6cc7kda3kr50l412hsi3bcgn7";
      type = "gem";
    };
    version = "4.0.2";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
      "reline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kh5nv8v74k1ccy6gc7nd04aaf1cjkbk7g8pwy2izvcqaq36jv6p";
      type = "gem";
    };
    version = "0.16.0";
  };
  pry-byebug = {
    dependencies = [
      "byebug"
      "pry"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dyi2dr5zp08s4bp9ik44v84wc0kdvinmcy7six0lfd8x150jkjr";
      type = "gem";
    };
    version = "3.12.0";
  };
  pry-doc = {
    dependencies = [
      "pry"
      "yard"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13id4bmq39fm8176b7a9mz0cira5qfa4zr24chf48m1b0vn9znka";
      type = "gem";
    };
    version = "1.7.0";
  };
  psych = {
    dependencies = [
      "date"
      "stringio"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x0r3gc66abv8i4dw0x0370b5hrshjfp6kpp7wbp178cy775fypb";
      type = "gem";
    };
    version = "5.3.1";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1f3knlwfwm05sfbaihrxm4g772b79032q14c16q4b38z8bi63qcb";
      type = "gem";
    };
    version = "4.0.7";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a3jd9qakasizrf7dkq5mqv51fjf02r2chybai2nskjaa6mz93mz";
      type = "gem";
    };
    version = "7.2.0";
  };
  pwntools = {
    dependencies = [
      "crabstone"
      "dentaku"
      "elftools"
      "keystone-engine"
      "method_source"
      "one_gadget"
      "rainbow"
      "ruby2ruby"
      "rubyserial"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pxc3lcgnywglv0skzj1r8i4p8mwcj27hlwzwqf8sj2mn3iqyjnd";
      type = "gem";
    };
    version = "1.2.1";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hhjy9gcp52dzij05gmidqac8g28ski5xm67prwmdqmjfcgqxmsy";
      type = "gem";
    };
    version = "3.2.6";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "logger"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b4bamcbpk29i7jvly3i7ayfj69yc1g03gm4s7jgamccvx12hvng";
      type = "gem";
    };
    version = "4.2.1";
  };
  rack-session = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sg4laz2qmllxh1c5sqlj9n1r7scdn08p3m4b0zmhjvyx9yw0v8b";
      type = "gem";
    };
    version = "2.1.1";
  };
  rack-test = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qy4ylhcfdn65a5mz2hly7g9vl0g13p5a0rmm6sc0sih5ilkcnh0";
      type = "gem";
    };
    version = "2.2.0";
  };
  rackup = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s48d2a0z5f0cg4npvzznf933vipi6j7gmk16yc913kpadkw4ybc";
      type = "gem";
    };
    version = "2.3.1";
  };
  rails = {
    dependencies = [
      "actioncable"
      "actionmailbox"
      "actionmailer"
      "actionpack"
      "actiontext"
      "actionview"
      "activejob"
      "activemodel"
      "activerecord"
      "activestorage"
      "activesupport"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "155skqkjrckvzj1qy37lrnafrillc47qhf3l80g3zvw100ba1h4n";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  rails-dom-testing = {
    dependencies = [
      "activesupport"
      "minitest"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07awj8bp7jib54d0khqw391ryw8nphvqgw4bb12cl4drlx9pkk4a";
      type = "gem";
    };
    version = "2.3.0";
  };
  rails-html-sanitizer = {
    dependencies = [
      "loofah"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "128y5g3fyi8fds41jasrr4va1jrs7hcamzklk1523k7rxb64bc98";
      type = "gem";
    };
    version = "1.7.0";
  };
  railties = {
    dependencies = [
      "actionpack"
      "activesupport"
      "cgi"
      "irb"
      "rackup"
      "rake"
      "thor"
      "tsort"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0np1m8xqb4wbzwpg66yjnqjban0di92lbjzcrgnwwhq2w4z3k8xf";
      type = "gem";
    };
    version = "7.2.3.1";
  };
  rainbow = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "175iisqb211n0qbfyqd8jz2g01q6xj038zjf4q0nm8k6kz88k7lc";
      type = "gem";
    };
    version = "13.3.1";
  };
  rake-compiler-dock = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hpq52ab86s70yv5hk56f0z14izhh59af95nlv73bsrksln1zdga";
      type = "gem";
    };
    version = "1.11.0";
  };
  rb-fsevent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zmf31rnpm8553lqwibvv3kkx0v7majm1f341xbxc0bk5sbhp423";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vmy8xgahixcz6hzwy4zdcyn2y6d6ri8dqv5xccgzc1r292019x0";
      type = "gem";
    };
    version = "0.11.1";
  };
  rb-readline = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14w79a121czmvk1s953qfzww30mqjb2zc0k9qhi0ivxxk3hxg6wy";
      type = "gem";
    };
    version = "0.5.5";
  };
  rb_sys = {
    dependencies = [
      "json"
      "rake-compiler-dock"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a00xy1gk6rdlmggq8c8gaj6jy3nlk94iddsn7nhfz5ggvhd9vql";
      type = "gem";
    };
    version = "0.9.125";
  };
  rbnacl = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q4si2n6m719clr5acb77p6fcryyy9a9xnm90f67n2ir7glk7165";
      type = "gem";
    };
    version = "7.1.2";
  };
  rbs = {
    dependencies = [
      "logger"
      "tsort"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s2wgrmzqz82lchpjbigliy80si0mbq3162j7cda2cdvwi5pqzdi";
      type = "gem";
    };
    version = "3.10.4";
  };
  rchardet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03rr05qam5d6gcsnsjs85bnwg80qww484xql347j42kj3bb2xsnm";
      type = "gem";
    };
    version = "1.10.0";
  };
  rdoc = {
    dependencies = [
      "erb"
      "psych"
      "tsort"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14iiyb4yi1chdzrynrk74xbhmikml3ixgdayjma3p700singfl46";
      type = "gem";
    };
    version = "7.2.0";
  };
  re2 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12axapfwxlgg18w5abnc5gznx0gms369rambq50x1pzdlavlr4fh";
      type = "gem";
    };
    version = "2.25.0";
  };
  red-colors = {
    dependencies = [
      "json"
      "matrix"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16lj0h6gzmc07xp5rhq5b7c1carajjzmyr27m96c99icg2hfnmi3";
      type = "gem";
    };
    version = "0.4.0";
  };
  redcarpet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iglapqs4av4za9yfaac0lna7s16fq2xn36wpk380m55d8792i6l";
      type = "gem";
    };
    version = "3.6.1";
  };
  redis = {
    dependencies = [ "redis-client" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bpsh5dbvybsa8qnv4dg11a6f2zn4sndarf7pk4iaayjgaspbrmm";
      type = "gem";
    };
    version = "5.4.1";
  };
  redis-client = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jw2xjzz24dwn85y8v1jf1vzzpsnypsvs06f1qfa91w7rpwr5248";
      type = "gem";
    };
    version = "0.28.0";
  };
  redis-rack = {
    dependencies = [
      "rack-session"
      "redis-store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10438w0y1jbgr205zndvmz6md0mrqazh2j9fr88lvb8hms10pddb";
      type = "gem";
    };
    version = "3.0.0";
  };
  redis-store = {
    dependencies = [ "redis" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "197d1088jw3wl3lfcdj4w4c4da13wsqyd12mj3czvlfw77ig7i7d";
      type = "gem";
    };
    version = "1.11.0";
  };
  regexp_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "192mzi0wgwl024pwpbfa6c2a2xlvbh3mjd75a0sakdvkl60z64ya";
      type = "gem";
    };
    version = "2.11.3";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d8q5c4nh2g9pp758kizh8sfrvngynrjlm0i1zn3cnsnfd4v160i";
      type = "gem";
    };
    version = "0.6.3";
  };
  rest-client = {
    dependencies = [
      "http-accept"
      "http-cookie"
      "mime-types"
      "netrc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qs74yzl58agzx9dgjhcpgmzfn61fqkk33k1js2y5yhlvc5l19im";
      type = "gem";
    };
    version = "2.1.0";
  };
  reverse_markdown = {
    dependencies = [ "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bxqlpwnixn8x4bnna958w6m6qkdkbnd23b9j6ib3nrrrs9bp3l1";
      type = "gem";
    };
    version = "3.0.2";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hninnbvqd2pn40h863lbrn9p11gvdxp928izkag5ysx8b1s5q0r";
      type = "gem";
    };
    version = "3.4.4";
  };
  rice = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10j8dfky3hpppd1z42v68ydisi4fjgh69bw7i7k7diw4iljdnv64";
      type = "gem";
    };
    version = "4.7.1";
  };
  rmagick = {
    dependencies = [
      "observer"
      "pkg-config"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17snhs2cqkfl9nzmpyc7fg92b3lqlqpy2jn4p944rn0kyp6929vr";
      type = "gem";
    };
    version = "6.2.0";
  };
  rmate = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01qyw345yg3n9z3xm98p9hqmgqri6yfhdd6d2kfqkg3ha8mi3xh5";
      type = "gem";
    };
    version = "1.5.9";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dnfkrk8xx2m8r3r9m2p5xcq57viznyc09k7r3i4jbm758i57lx3";
      type = "gem";
    };
    version = "3.30.0";
  };
  rpam2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zvli3s4z1hf2l7gyfickm5i3afjrnycc3ihbiax6ji6arpbyf33";
      type = "gem";
    };
    version = "4.0.2";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11q5hagj6vr694innqj4r45jrm8qcwvkxjnphqgyd66piah88qi0";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bcbh9yv6cs6pv299zs4bvalr8yxa51kcdd1pjl60yv625j3r0m8";
      type = "gem";
    };
    version = "3.13.6";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dl8npj0jfpy31bxi6syc7jymyd861q277sfr6jawq2hv6hx791k";
      type = "gem";
    };
    version = "3.13.5";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iqxmw0knjiz5nf6pgr8ihs6cjzh89f0ppj3fqiz8cvms79x6sh8";
      type = "gem";
    };
    version = "3.13.8";
  };
  rspec-support = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z64h5rznm2zv21vjdjshz4v0h7bxvg02yc6g7yzxakj11byah06";
      type = "gem";
    };
    version = "3.13.7";
  };
  rubocop = {
    dependencies = [
      "json"
      "language_server-protocol"
      "lint_roller"
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pxzipl8a1bv62jdfykh7j4ymdr4aiffjvwsny6drwv886jwx4jn";
      type = "gem";
    };
    version = "1.84.2";
  };
  rubocop-ast = {
    dependencies = [
      "parser"
      "prism"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dahfpnzz63hyqxa03x8rypnrxzwyvh4i5a8ri34bzpnf3pg64j4";
      type = "gem";
    };
    version = "1.49.1";
  };
  rubocop-performance = {
    dependencies = [
      "lint_roller"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d0qyyw1332afi9glwfjkb4bd62gzlibar6j55cghv8rzwvbj6fd";
      type = "gem";
    };
    version = "1.26.1";
  };
  ruby-graphviz = {
    dependencies = [ "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "010m283gk4qgzxkgrldlnrglh8d5fn6zvrzm56wf5abd7x7b8aqw";
      type = "gem";
    };
    version = "1.2.5";
  };
  ruby-keychain = {
    dependencies = [
      "ffi"
      "og-corefoundation"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g57fr1r39bfh1r887hp87mawfg3miidagvpqyqq3l0152ya43wr";
      type = "gem";
    };
    version = "0.4.0";
  };
  ruby-libvirt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r0igmwr22pi3dkkg1p79hjf8mr178qnz83q8fnaj87x7zk3qfyg";
      type = "gem";
    };
    version = "0.8.4";
  };
  ruby-lsp = {
    dependencies = [
      "language_server-protocol"
      "prism"
      "rbs"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0aa1mg6bdl23wgrxd98wycq3963jfpnh9z0yh976p9q03h01r81k";
      type = "gem";
    };
    version = "0.26.9";
  };
  ruby-lxc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08pnghqp15fwylq6w2qh7x1ikkiq87irpy0z03n0gma4gdzzx2qa";
      type = "gem";
    };
    version = "1.2.3";
  };
  ruby-macho = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jgmhj4srl7cck1ipbjys6q4klcs473gq90bm59baw4j1wpfaxch";
      type = "gem";
    };
    version = "2.5.1";
  };
  ruby-progressbar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  ruby-terminfo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rl4ic5pzvrpgd42z0c1s2n3j39c9znksblxxvmhkzrc0ckyg2cm";
      type = "gem";
    };
    version = "0.1.1";
  };
  ruby-vips = {
    dependencies = [
      "ffi"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x2k5x272m2zs0vmznl2jac14bj9a2g0365xxcnr2s9rq41fr1g6";
      type = "gem";
    };
    version = "2.3.0";
  };
  ruby2_keywords = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  ruby2ruby = {
    dependencies = [ "sexp_processor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "000szrcq2pw3m26fpgfm4zdgxr7csn46gjmfl7szcb10wphbmz8i";
      type = "gem";
    };
    version = "2.6.1";
  };
  rubyserial = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vj5yan6srbvkf5vfp9d9b9z8wyygd0zxcy54c35yhkjl6kwd22q";
      type = "gem";
    };
    version = "0.6.0";
  };
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05an0wz87vkmqwcwyh5rjiaavydfn5f4q1lixcsqkphzvj7chxw5";
      type = "gem";
    };
    version = "2.4.1";
  };
  rugged = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b7gcf6pxg4x607bica68dbz22b4kch33yi0ils6x3c8ql9akakz";
      type = "gem";
    };
    version = "1.9.0";
  };
  safe_yaml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j7qv63p0vqcd838i2iy2f76c3dgwzkiz1d1xkg7n0pbnxj2vb56";
      type = "gem";
    };
    version = "1.0.5";
  };
  safetensors = {
    dependencies = [ "rb_sys" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gghs4ds9jwwmyk8c5lj1wx7dzh9nn35ydxhfagl47n8632035sn";
      type = "gem";
    };
    version = "0.2.2";
  };
  sass = {
    dependencies = [ "sass-listen" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p95lhs0jza5l7hqci1isflxakz83xkj97lkvxl919is0lwhv2w0";
      type = "gem";
    };
    version = "3.7.4";
  };
  sass-listen = {
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";
      type = "gem";
    };
    version = "4.0.0";
  };
  sassc = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gpqv48xhl8mb8qqhcifcp0pixn206a7imc07g48armklfqa4q2c";
      type = "gem";
    };
    version = "2.4.0";
  };
  sawyer = {
    dependencies = [
      "addressable"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hayryyz46nlkcb6j0ij0kxq6i3ryiigwfc6ccvp0108hhlij3qd";
      type = "gem";
    };
    version = "0.9.3";
  };
  scrypt = {
    dependencies = [
      "ffi-compiler"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bx61brivcgn0ps755f8hslf8pzrmi1c5savdj8gxdz3qxdy7zb7";
      type = "gem";
    };
    version = "3.1.0";
  };
  seccomp-tools = {
    dependencies = [
      "logger"
      "os"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w12yvg1zdd6kkmgcwnblnj5s8jr4qzjh7nfffbibxi066nb8vn2";
      type = "gem";
    };
    version = "1.6.2";
  };
  securerandom = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cd0iriqfsf1z91qg271sm88xjnfd92b832z49p1nd542ka96lfc";
      type = "gem";
    };
    version = "0.4.1";
  };
  semian = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yvwyfi2gxlr1rnqk2ymxpb49qk18hxshbpjvk55agz78pancib4";
      type = "gem";
    };
    version = "0.28.1";
  };
  sequel = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0saswmna49yvyclcx1a5rabjqhl3aawyhahsqm7p51f59hvj7gsi";
      type = "gem";
    };
    version = "5.103.0";
  };
  sequel_pg = {
    dependencies = [
      "pg"
      "sequel"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ww2i94r8cz40b0nljgy554b60885gqxr58z3nrhlb7aqq4lsf6g";
      type = "gem";
    };
    version = "1.19.0";
  };
  sexp_processor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03igwdnh4nw1swacv7w7ql92wpx0nwv9hxg8bi35sg9mk2x4haxf";
      type = "gem";
    };
    version = "4.17.5";
  };
  simplecov = {
    dependencies = [
      "docile"
      "simplecov-html"
      "simplecov_json_formatter"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "198kcbrjxhhzca19yrdcd6jjj9sb51aaic3b0sc3pwjghg3j49py";
      type = "gem";
    };
    version = "0.22.0";
  };
  simplecov-html = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ikjfwydgs08nm3xzc4cn4b6z6rmcrj2imp84xcnimy2wxa8w2xx";
      type = "gem";
    };
    version = "0.13.2";
  };
  simplecov_json_formatter = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a5l0733hj7sk51j81ykfmlk2vd5vaijlq9d5fn165yyx3xii52j";
      type = "gem";
    };
    version = "0.1.4";
  };
  simpleidn = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a9c1mdy12y81ck7mcn9f9i2s2wwzjh1nr92ps354q517zq9dkh8";
      type = "gem";
    };
    version = "0.2.3";
  };
  sinatra = {
    dependencies = [
      "logger"
      "mustermann"
      "rack"
      "rack-protection"
      "rack-session"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "103h6wjpcqp3i034hi44za2v365yz7qk9s5df8lmasq43nqvkbmp";
      type = "gem";
    };
    version = "4.2.1";
  };
  singleton = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y2pc7lr979pab5n5lvk3jhsi99fhskl5f2s6004v8sabz51psl3";
      type = "gem";
    };
    version = "0.3.0";
  };
  slather = {
    dependencies = [
      "CFPropertyList"
      "activesupport"
      "clamp"
      "nokogiri"
      "xcodeproj"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03hhwrjdq3gnh6irzxg15iwsfbg14pwdmxadc5amqg7gx08l5s6x";
      type = "gem";
    };
    version = "2.8.5";
  };
  slop = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iyrjskgxyn8i1679qwkzns85p909aq77cgx2m4fs5ygzysj4hw4";
      type = "gem";
    };
    version = "4.10.1";
  };
  snappy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l6dvcyids2kra4sm6mkjwnsv45893hl22pvqa5b4z5gsqj04p4k";
      type = "gem";
    };
    version = "0.5.1";
  };
  snmp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fikr2yjkbxi6hh97706ilpqrm6xxp89d3vxc1krhzlv91q4yb74";
      type = "gem";
    };
    version = "1.3.4";
  };
  solargraph = {
    dependencies = [
      "ast"
      "backport"
      "benchmark"
      "diff-lcs"
      "jaro_winkler"
      "kramdown"
      "kramdown-parser-gfm"
      "logger"
      "observer"
      "open3"
      "ostruct"
      "parser"
      "prism"
      "rbs"
      "reverse_markdown"
      "rubocop"
      "thor"
      "tilt"
      "yard"
      "yard-activesupport-concern"
      "yard-solargraph"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s9fzq4rax47nvypwq84k4mr0g9pf6gdibf4na1j7ryi4z4zvgny";
      type = "gem";
    };
    version = "0.58.3";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cbkgb5s3qsfjgnp75habwxsi97711jg90yh52ihcssbf58430c6";
      type = "gem";
    };
    version = "2.9.2";
  };
  standard = {
    dependencies = [
      "language_server-protocol"
      "lint_roller"
      "rubocop"
      "standard-custom"
      "standard-performance"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0001x9klgvq3kj140fr3916sidpf1xplig03iwy0i4wq7pw0hjvs";
      type = "gem";
    };
    version = "1.54.0";
  };
  standard-custom = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0av55ai0nv23z5mhrwj1clmxpgyngk7vk6rh58d4y1ws2y2dqjj2";
      type = "gem";
    };
    version = "1.0.2";
  };
  standard-performance = {
    dependencies = [
      "lint_roller"
      "rubocop-performance"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wp3i2f6w6vgxh5b9iq3458c4xmmviyfdrc03nar50j4pqqksj29";
      type = "gem";
    };
    version = "1.9.0";
  };
  stringio = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q92y9627yisykyscv0bdsrrgyaajc2qr56dwlzx7ysgigjv4z63";
      type = "gem";
    };
    version = "3.2.0";
  };
  syntax_tree = {
    dependencies = [ "prettier_print" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ggi6p7xxjsj42q8pp0yz6z7dbwlbr6fjbs4qnafr667jab5mqjn";
      type = "gem";
    };
    version = "6.3.0";
  };
  syntax_tree-haml = {
    dependencies = [
      "haml"
      "prettier_print"
      "syntax_tree"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nb335cn093qnc3hyb8s4vbgn8apwz019m4dj15hz2y2gmkpdxnw";
      type = "gem";
    };
    version = "4.0.3";
  };
  syntax_tree-rbs = {
    dependencies = [
      "prettier_print"
      "rbs"
      "syntax_tree"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g9n2i99y6b5l3x3vp2nk0fss2x0b2gd1h5hynbs2y4ab35jhrsr";
      type = "gem";
    };
    version = "1.0.0";
  };
  taglib-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bmirkz9lfhbykj3x48z1gv0jl1bfz60yscpl0hmjxrdmcihzfai";
      type = "gem";
    };
    version = "2.0.0";
  };
  temple = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b7pzx45f1vg6f53midy70ndlmb0k4k03zp4nsq8l0q9dx5yk8dp";
      type = "gem";
    };
    version = "0.10.4";
  };
  terminal-table = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hbmzfr17ji5ws5x5z3kypmb5irwwss7q7kkad0gs005ibqrxv0a";
      type = "gem";
    };
    version = "1.6.0";
  };
  text = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x6kkmsr49y3rnrin91rv8mpc3dhrf3ql08kbccw8yffq61brfrg";
      type = "gem";
    };
    version = "1.3.1";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wsy88vg2mazl039392hqrcwvs5nb9kq8jhhrrclir2px1gybag3";
      type = "gem";
    };
    version = "1.5.0";
  };
  thrift = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y2xpdpj8rm9xgx2w9l8liwb6hqcwqxnmhnhkvw15y4saabs2i3s";
      type = "gem";
    };
    version = "0.22.0";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cvaikq1dcbfl008i16c1pi1gmdax7vfkvmhch64jdkakyk9nnqd";
      type = "gem";
    };
    version = "2.7.0";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jxcji88mh6xsqz0mfzwnxczpg7cyniph7wpavnavfz7lxl77xbq";
      type = "gem";
    };
    version = "0.6.1";
  };
  tiny_tds = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rm9bjby47pd2y9125c9k11gc8avbc79b7l1cmn1h2rqpy80m1si";
      type = "gem";
    };
    version = "3.3.0";
  };
  tokenizers = {
    dependencies = [ "rb_sys" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "153rcngyzprwvlfwlbdl3yzma1v84k5n2636zrn5ysckd3lbhxnb";
      type = "gem";
    };
    version = "0.6.3";
  };
  torch-rb = {
    dependencies = [ "rice" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kw4q3s5693rynvczajbwinh08z3qjmm4iy4pbmchm82b4wrp8ka";
      type = "gem";
    };
    version = "0.22.2";
  };
  track_open_instances = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a9hbhxrqf8b2ly8i14w5b13g29h7rcb23x4m8fqhk3b3s14h3kz";
      type = "gem";
    };
    version = "0.1.15";
  };
  transformers-rb = {
    dependencies = [
      "logger"
      "numo-narray"
      "safetensors"
      "tokenizers"
      "torch-rb"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fr8lv7jbk1dm7aka4wrv6rkd1gsprifbqz1h9sjqj2f3rscqlpa";
      type = "gem";
    };
    version = "0.1.7";
  };
  treetop = {
    dependencies = [ "polyglot" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nl3q5ai7ikaa5sjdbspfa4njbrdvf7898zkplmalln6y4r3y153";
      type = "gem";
    };
    version = "1.6.18";
  };
  tsort = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17q8h020dw73wjmql50lqw5ddsngg67jfw8ncjv476l5ys9sfl4n";
      type = "gem";
    };
    version = "0.2.0";
  };
  tty-color = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0aik4kmhwwrmkysha7qibi2nyzb4c8kp42bd5vxnf8sf7b53g73g";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-command = {
    dependencies = [ "pastel" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14hi8xiahfrrnydw6g3i30lxvvz90wp4xsrlhx8mabckrcglfv0c";
      type = "gem";
    };
    version = "0.10.1";
  };
  tty-option = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "019ir4bcr8fag7dmq7ph6ilpvwjbv4qalip0bz7dlddbd6fk4vjs";
      type = "gem";
    };
    version = "0.3.0";
  };
  typhoeus = {
    dependencies = [ "ethon" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z7gamf6s83wy0yqms3bi4srirn3fc0lc7n65lqanidxcj1xn5qw";
      type = "gem";
    };
    version = "1.4.1";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  uglifier = {
    dependencies = [ "execjs" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1apmqsad2y1avffh79f4lfysfppz94fvpyi7lkkj3z8bn60jpm3m";
      type = "gem";
    };
    version = "4.2.1";
  };
  unf_ext = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sf6bxvf6x8gihv6j63iakixmdddgls58cpxpg32chckb2l18qcj";
      type = "gem";
    };
    version = "0.0.9.1";
  };
  unicode-blocks = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cfvhzgisi7znvzj2hxj5wjk4lry81v79hvhn3aam7mafq8b3f40";
      type = "gem";
    };
    version = "1.11.0";
  };
  unicode-display_width = {
    dependencies = [ "unicode-emoji" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hiwhnqpq271xqari6mg996fgjps42sffm9cpk6ljn8sd2srdp8c";
      type = "gem";
    };
    version = "3.2.0";
  };
  unicode-emoji = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03zqn207zypycbz5m9mn7ym763wgpk7hcqbkpx02wrbm1wank7ji";
      type = "gem";
    };
    version = "4.2.0";
  };
  unicode-name = {
    dependencies = [ "unicode-types" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pfvpq5v2pf164sfafx764rby3spg202wisws258qx03npgdql5k";
      type = "gem";
    };
    version = "1.14.0";
  };
  unicode-scripts = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1f9g68irh2nvjhmsb95f1dmzy8hq4xav2i77da1207fwd0zcz937";
      type = "gem";
    };
    version = "1.12.0";
  };
  unicode-types = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ybns4spibnw11am52h7bx7bnl9sp7mpw7j7hndsh3r6fc921lc1";
      type = "gem";
    };
    version = "1.11.0";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ijpbj7mdrq7rhpq2kb51yykhrs2s54wfs6sm9z3icgz4y6sb7rp";
      type = "gem";
    };
    version = "1.1.1";
  };
  useragent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i1q2xdjam4d7gwwc35lfnz0wyyzvnca0zslcfxm9fabml9n83kh";
      type = "gem";
    };
    version = "0.16.11";
  };
  uuid4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qlcxzn8pnql34pcdrkd20kdla3k6n2sspaxp3lwwx8a87jnzbc3";
      type = "gem";
    };
    version = "0.2.0";
  };
  webmention = {
    dependencies = [
      "http"
      "indieweb-endpoints"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ag06gal14r3rlcv0c951w1a9wb0d04mk5pz2v0f71q9fzwxwwmi";
      type = "gem";
    };
    version = "7.0.0";
  };
  webrick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ca1hr2rxrfw7s613rp4r4bxb454i3ylzniv9b9gxpklqigs3d5y";
      type = "gem";
    };
    version = "1.9.2";
  };
  websocket-driver = {
    dependencies = [
      "base64"
      "websocket-extensions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qj9dmkmgahmadgh88kydb7cv15w13l1fj3kk9zz28iwji5vl3gd";
      type = "gem";
    };
    version = "0.8.0";
  };
  websocket-extensions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
  };
  whois = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mk2b5ycj9f3yybik2wqwp71670frk5j8yaxb9irws1sgqns8y9q";
      type = "gem";
    };
    version = "6.0.3";
  };
  xcodeproj = {
    dependencies = [
      "CFPropertyList"
      "atomos"
      "claide"
      "colored2"
      "nanaimo"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lslz1kfb8jnd1ilgg02qx0p0y6yiq8wwk84mgg2ghh58lxsgiwc";
      type = "gem";
    };
    version = "1.27.0";
  };
  xctasks = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jmxq0dv2q4qs628cykrhsm9piysjsacbq5blsf35a0fj015bw7l";
      type = "gem";
    };
    version = "0.2.2";
  };
  yard = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03q1hf12csqy5q2inafzi44179zaq9n5yrb0k2j2llqhzcmbh7vj";
      type = "gem";
    };
    version = "0.9.38";
  };
  yard-activesupport-concern = {
    dependencies = [ "yard" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vwhhgkkrw57anbbsyv5aihmhhxpr255jqvhcy3jwgn2xyq0qydy";
      type = "gem";
    };
    version = "0.0.1";
  };
  yard-solargraph = {
    dependencies = [ "yard" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03lklm47k6k294ww97x6zpvlqlyjm5q8jidrixhil622r4cld6m1";
      type = "gem";
    };
    version = "0.1.0";
  };
  zeitwerk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pbkiwwla5gldgb3saamn91058nl1sq1344l5k36xsh9ih995nnq";
      type = "gem";
    };
    version = "2.7.5";
  };
  zookeeper = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hc87pbmgc53lksa1aql61kxn9d2kjzmlhnjxa5rcn01qhm3pkvg";
      type = "gem";
    };
    version = "1.5.5";
  };
}
