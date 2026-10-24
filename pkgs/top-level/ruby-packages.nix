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
      sha256 = "0mvb7hkrbg1nrb0xy347f1wb2vlf61kc3gs3yi2swawl34axkzq4";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "19ccdmx2l8rdz698686n7yzlkwlry4qaiqacw68w6c5nqnc6x7yi";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "0ndpcw5q3hyxwkncg6wf37qlzyn8qcvd4q19inrcsrr8hwkc79j5";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "0av5562qr6f7lddlr4ipycp2qk54q8pl3caa0vp7690gvz2b3yy1";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "1c7h6fyyi8q1kqgclcdr55vrm28v7swriam9ara6m5xb0wm7xaqr";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "00fw5sqg71zjw5bgk5l620l05aj07kbl6clzz8fjg4qc0ikdkgs2";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "0fm9fghq86z09xdrsdqq1z8bbasxsb8w1f2c1hzq44c9i5qa0gxq";
      type = "gem";
    };
    version = "7.2.3.2";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09v987j1jy4821s06cpm3h50ldybv89k0ll70grn05fxv1yccxrp";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "1iw5f93c6rq080xphy4776lamc4iahibjbhjxlj0v0jzgsx28bg6";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "1z6v9rz1lvqdn2x28vbcbyq6m1gvzqwvkp9apramal433frb8g46";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "04ikxwixhpnv2dih9hy3af45qgra7kz0fd70miw6s248vl8hvjfx";
      type = "gem";
    };
    version = "7.2.3.2";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1by7h2lwziiblizpd5yx87jsq8ppdhzvwf08ga34wzqgcv1nmpvz";
      type = "gem";
    };
    version = "2.9.0";
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
      sha256 = "0s9lxaz66x45mkc1zac8bhi6q9lca73hwk0jjsha6ihmvkjkpm7n";
      type = "gem";
    };
    version = "4.3.9";
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
      "pkg-config"
      "red-colors"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08x6f2idyfnylq0b66mqi8lf5mjvff2y2q02n5hq0x4i3ha5cwz5";
      type = "gem";
    };
    version = "1.18.5";
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
      sha256 = "1j45dmxyjr3cpjgm2cfmlv4a0qaw67ivi4b6863xv3l928c974zh";
      type = "gem";
    };
    version = "4.3.9";
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
      "logger"
      "mutex_m"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xx0zqnivlwjvh6x864r128rbk5bf1zk0pkzv0a6ajyylb6chn6a";
      type = "gem";
    };
    version = "4.0.11";
  };
  cf-uaac = {
    dependencies = [
      "cf-uaa-lib"
      "highline"
      "json"
      "launchy"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pmba1nf7zndrw9a5gif42nrsr3cagnkkk5j3fnfl1vz2qpqmydx";
      type = "gem";
    };
    version = "5.1.0";
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
      sha256 = "1fzqwshg1xzbdm97havskfp6wifsgbjii00dzba0y6bih4lk1jk1";
      type = "gem";
    };
    version = "0.5.2";
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
      sha256 = "1bw4ybyppcjx2ifkhpzrmh526db9c5dlh9nkdl7dc01vmh8nzkys";
      type = "gem";
    };
    version = "1.17.0";
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
      sha256 = "0nxgbm2hyg5fwb410q1wy4bi45yrr8apmmrnaa9lh6xb6vfx1qx9";
      type = "gem";
    };
    version = "1.17.0";
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
      sha256 = "1yvl90g6619ykjk2nmmm8fdk9jchyh7kwwifw6xjqqzn3c95pjkx";
      type = "gem";
    };
    version = "0.6.2";
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
      sha256 = "1qfi2ns3zwkgq616fc127xiqhan7g7m7gqpwriwcr34nds1vxwdj";
      type = "gem";
    };
    version = "1.3.8";
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
      sha256 = "15djj19ynz3sbw54fsf8n7y3sha8a333f2mgvjfwhr46jhcqg1ll";
      type = "gem";
    };
    version = "1.0.7";
  };
  creole = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00rcscz16idp6dx0dk5yi5i0fz593i3r6anbn5bg2q07v3i025wm";
      type = "gem";
    };
    version = "0.5.0";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mj4kq4wwpc7c8ll52q30hsir1jrcd5kq7yb8lyz0rksa1z1x9mb";
      type = "gem";
    };
    version = "3.3.6";
  };
  curb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rzqkryn2w73nj9qsfdr01bjzy2m6lh11vj3xg93hg5lcddhnnd0";
      type = "gem";
    };
    version = "1.4.0";
  };
  curses = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mvh67ijv03cvnwbkjxh6vrg9nhyndii4wyjd1ni7gabf0qgy965";
      type = "gem";
    };
    version = "1.7.0";
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
      sha256 = "00i8xxb64mixbr8ilrnx2iggwxhdr5kbgbzj91imjqqq0d0fhvdx";
      type = "gem";
    };
    version = "8.4.0";
  };
  dnsimple = {
    dependencies = [ "httparty" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12i2z1psgyqalx8gd69m66ay2xryni979cb3m0fz7xn1yiq58z6s";
      type = "gem";
    };
    version = "13.1.0";
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
      sha256 = "14v554cb5b14wikzlkhfbr8ms97rjx5ysci0bs8v8qlffrn770vs";
      type = "gem";
    };
    version = "1.74.0";
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
  domain_name = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vgfimffni6yryk76k7grvixisaikbhc925fs3z07rpsd6gr8ddk";
      type = "gem";
    };
    version = "0.6.20260921";
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
      sha256 = "14pfj6zn0p1hxj6s6s0r7d424wap8zl9zxf89nj79y8fbg16vjn5";
      type = "gem";
    };
    version = "6.0.7";
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
      sha256 = "0sd5i4hra1zf0gfpvbr33qlnfmsx6ayjmicwww6z0d7i41sb2mr5";
      type = "gem";
    };
    version = "1.7.2";
  };
  execjs = {
    dependencies = [ "json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "122c49fafd5lrhbw71b11ynbgyixk1x8mf7xz3gwzh2hkssg4v26";
      type = "gem";
    };
    version = "2.10.2";
  };
  expression_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1938z3wmmdabqxlh5d5c56xfg1jc6z15p7zjyhvk7364zwydnmib";
      type = "gem";
    };
    version = "0.9.0";
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
      sha256 = "0vmb5wpiz7mf2r6vjvhvfp38rrfvqjzmv7m3max0s6v28j641d4v";
      type = "gem";
    };
    version = "2.14.4";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "125m3qri52vwh5v9dhq0dkqxf8629cxrf99yyc01pva72wasyy0f";
      type = "gem";
    };
    version = "3.4.4";
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
      sha256 = "0vhjv98f9rjdzdxfsyyk19sfb45dcxc57ynsdmvn8vzdkifrvmm9";
      type = "gem";
    };
    version = "1.4.2";
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
      "dnsimple"
      "fog-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p5nmrm9zb0a5w71ddrvx3kp4h04dx55jp85ij2w1zkyq5sggl95";
      type = "gem";
    };
    version = "3.0.0";
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
      sha256 = "0mgm0kbk52i0jyhiajcj666zkaacfc5jz50ncv8kj35z632y4hrz";
      type = "gem";
    };
    version = "4.3.9";
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
      sha256 = "1g1wdf0vcqlzn3a0bw47v59rl292pk8ra61mdgpxrm773nrg4y0v";
      type = "gem";
    };
    version = "4.3.9";
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
      sha256 = "1k0azkgnlc7jim5ms2zb39a94qzlvjcaa77xzhr07cmy0pnbmp3d";
      type = "gem";
    };
    version = "4.3.9";
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
      sha256 = "0qsksv5ag2xhzkd96blmqmhp40pvyqhbaiqrdjp08a5iabijf0pi";
      type = "gem";
    };
    version = "5.6.0";
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
    dependencies = [
      "RedCloth"
      "creole"
      "org-ruby"
      "rdoc"
      "wikicloth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bzkml8rslv3vsv7chn37dk5rxsfckjyqfx698sis6hrc79c0lnk";
      type = "gem";
    };
    version = "2.1.0";
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
      sha256 = "1ka9jmipfa1adf47l8831mflmjz20chiybz6z4s5wbl1gr2dph9j";
      type = "gem";
    };
    version = "4.3.9";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09zl0rkskfq0cwfrk9ypjvflvzanfg3xbhh1slaa1myry7xi4zq3";
      type = "gem";
    };
    version = "1.4.0";
  };
  gobject-introspection = {
    dependencies = [ "glib2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sympmqqfh9hcfc2hiig0c5raiiaz1r33si87xl73cczp5lhx72h";
      type = "gem";
    };
    version = "4.3.9";
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
      sha256 = "0zy78xzpdn2zg54qiixbm3cbikxmj1pwjvd2vcl98fyqb6s6p6w9";
      type = "gem";
    };
    version = "4.3.9";
  };
  haml = {
    dependencies = [
      "prism"
      "temple"
      "thor"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11y2mlwa5zaqm8yab2lmb4s410hjr3w2v391qqn08cjxv0yq9ici";
      type = "gem";
    };
    version = "7.5.1";
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
      sha256 = "1q03gsy76sqzvv4r90aq7g22c7yhn2vp7hx28y5686wjc1djp74l";
      type = "gem";
    };
    version = "3.2.0";
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
      "http-cookie"
      "llhttp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09idshq01jz2vxasfj2ncxrwmlzqi9k1r27i4ja31a4y901gjs1p";
      type = "gem";
    };
    version = "6.0.4";
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
      sha256 = "1aga7z4p0dka4zcqw9i05wa4ab1q7h7cgnj328ldqqfycjz84jxs";
      type = "gem";
    };
    version = "1.1.6";
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
  httparty = {
    dependencies = [
      "csv"
      "mini_mime"
      "multi_xml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lh0bbdpq5axqblwsw5qqdk43sd6zkfl0qg56kcbzmbhr8lwz5aw";
      type = "gem";
    };
    version = "0.24.3";
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
      sha256 = "1dfikmmd9dllirsfq0kjiyxpmlq0afkxm5sslsr97r9g85ifpy80";
      type = "gem";
    };
    version = "1.15.2";
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
      "nokogiri-html-ext"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b629049d8fnmr46yw0rv5sh7rx502lkwdfwzminfxym361p4nlh";
      type = "gem";
    };
    version = "10.1.0";
  };
  io-console = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cgvhm0d4awr8j42b8v1nl1jfgx45ihv8mylargfi3lj697k00x4";
      type = "gem";
    };
    version = "0.9.4";
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
      sha256 = "1qs8a9vprg7s8krgq4s0pygr91hclqqyz98ik15p0m1sf2h5956y";
      type = "gem";
    };
    version = "1.18.0";
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
      sha256 = "0dvn8m8lnah6id60r0fb7hq3rg6qz6f01cbmb35vmkmhiz1bwc14";
      type = "gem";
    };
    version = "2.15.1";
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
      sha256 = "0gb9a0g7609fnn0455qaq79w0sc0jc53bjdnwjwg0vxv7qw5f37c";
      type = "gem";
    };
    version = "4.2.0";
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
      sha256 = "0shwgjqbj856mb6m9kgkpy08nhym2gdvc2yaprlimfmky9y3n78z";
      type = "gem";
    };
    version = "2.21.2";
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
      sha256 = "1ghxjcs9rss0fd43yqnc3ab6fhnm4qrkvv34p0xcjb9s35kh9xr9";
      type = "gem";
    };
    version = "1.1.5";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ip59r7z8mjwy1rq0pp53kxhvkjb5d942rpn7hiliha1qgxk9k24";
      type = "gem";
    };
    version = "3.3.0";
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
      sha256 = "1rm8vk5x21cmw11mlbf0b698di6lbsc88rcxa10aq6p1m10pm66h";
      type = "gem";
    };
    version = "1.7.43";
  };
  language_server-protocol = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w5p8c2145lmqzr25bxh4ikzjm6k8y1k5lriqqdpw9pq730w1wjy";
      type = "gem";
    };
    version = "3.17.0.6";
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
      sha256 = "1i6sm561mc70p7ykczg6gcmw6znn1h8w3zcm14fmkvld066lbnd9";
      type = "gem";
    };
    version = "6.0.0";
  };
  link-header-parser = {
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ayfijl4804pcxikc2znfdyq4lhxga9rf0v2xhr3zynlgfciz66h";
      type = "gem";
    };
    version = "7.0.1";
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
      sha256 = "0g3q0hnxnskhlchlyghxdc5dk41pzxr27pd4gms4iwspas2k4gsc";
      type = "gem";
    };
    version = "3.10.1";
  };
  llhttp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10j909ja0qbznas0s3zbj5d8yicpyrw38aa55ymr858yzfm5jg1w";
      type = "gem";
    };
    version = "0.6.2";
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
      sha256 = "062r891hxis58j5q735kk9sj5srxx0rv813f8m95bilsjm3gf1r0";
      type = "gem";
    };
    version = "2.25.2";
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
      sha256 = "1s30l5z7jkazgi4m6l6mh80rgsyhh2pp1pa5h70xclsj8z54wmq6";
      type = "gem";
    };
    version = "2.9.1";
  };
  marcel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17w53z6vka8ddmxvi936biqv443d5yg0503wj7xfmy9j1qvfjy0n";
      type = "gem";
    };
    version = "1.2.1";
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
      sha256 = "0bxfwiafwy50qlq5pz9kc61mcx21jg8gj1afb29z8mzqzprp6yb5";
      type = "gem";
    };
    version = "3.2026.1006";
  };
  mini_magick = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y0xs51dlzqlbd0x30pmv2qjn4axc1xacdbzqm9frm4y3mcay87i";
      type = "gem";
    };
    version = "5.4.0";
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
      sha256 = "1fhpfl9fznn6wi39xh05crswigywvyiw3rn0cbjf7prmgfm9whcp";
      type = "gem";
    };
    version = "1.8.5";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13pabgwf4qd5qn4sl7ci15g5ql038n5z0psip9xabnsbypm32m94";
      type = "gem";
    };
    version = "1.21.2";
  };
  multi_xml = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0msflv26i6i3jr9w761k4qdl7cp9zbhymjkn57b1w90pkjsndrvw";
      type = "gem";
    };
    version = "0.9.1";
  };
  mustermann = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "163i29mdcr1h0nximk3d51a1fgp7vz3sfasn8p1rjm2d4g3p0qac";
      type = "gem";
    };
    version = "3.1.1";
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
      sha256 = "0q1nq8mx22v9sn1296s45nm6dni42y3m3s1f4pg5dn3mx4xmgjdm";
      type = "gem";
    };
    version = "0.6.7";
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
      sha256 = "0ly8x39gr23blbmfwfyy14lb2v9kg8bj5x0b2r2llyb4dy60rygr";
      type = "gem";
    };
    version = "0.4.0";
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
      sha256 = "0g4gcydr0hza3wiizny0p5q4phl3fkhfsa4r5xir8bbb9p03q41m";
      type = "gem";
    };
    version = "0.5.2";
  };
  net-ssh = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jyf11l0p7nqkd5hwwz46gkshwfqh049gbhj3qigbfajwzfdwr1k";
      type = "gem";
    };
    version = "7.3.6";
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
  nkf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15c8b3ipdwagcfpky90w98wnl1s6cla6bxihb6vjgdrqpaz8syim";
      type = "gem";
    };
    version = "0.3.0";
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
      sha256 = "1d9safb4dly6qmc2g06444l0zifby52yy6j1a5fa1g4j3ihm3jah";
      type = "gem";
    };
    version = "1.19.4";
  };
  nokogiri-html-ext = {
    dependencies = [
      "addressable"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vdr34dkkmdhrzw8awxxyg1h7mh7k54wghldcj5wwad60b311wb9";
      type = "gem";
    };
    version = "1.7.0";
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
      sha256 = "1hj7wwp4r3jhvnyd8ik85wbs25cq1w61r28pv6ddyn5fd0lasdqh";
      type = "gem";
    };
    version = "4.0.2";
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
  org-ruby = {
    dependencies = [ "rubypants" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x69s7aysfiwlcpd9hkvksfyld34d8kxr62adb59vjvh8hxfrjwk";
      type = "gem";
    };
    version = "0.9.12";
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
      sha256 = "050qsy2bcd04yi1w1g6mlibjr32mhh29swcm3rlnza3lwza9d64f";
      type = "gem";
    };
    version = "2.2.1";
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
      sha256 = "163scygydszb5njajq97h2bxa793jiwwi9pnsy9ddwy7vqx04yqz";
      type = "gem";
    };
    version = "4.3.9";
  };
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vvs2sar7wnw70j1jc1kv1k23m5grc0ci3bbrcf6mkh18683wnpp";
      type = "gem";
    };
    version = "2.3.0";
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
      sha256 = "0a4q5h2hcihk79dbr20scgkm56l79qp7fsvfvkxlv8nmapvxg9i1";
      type = "gem";
    };
    version = "3.3.12.0";
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
      sha256 = "1yval9rdbc0p01dmf8zwm953w1hk0ggdp1pgr7a87s442983ddgp";
      type = "gem";
    };
    version = "1.7.0";
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
      sha256 = "0w5mha75hs8gdj75g8vl0sxpyp8rzvwq8a4jcmi4ah8cf370zjyz";
      type = "gem";
    };
    version = "0.6.4";
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
      sha256 = "0vkqy4lc4qn8adbs50xrk28x6hw33mw8884958l98k4qxcj3ds82";
      type = "gem";
    };
    version = "4.1.1";
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
      sha256 = "02ka2nx3k1sqxf2347gfwh82n1kb3ay6wxpfrkw8s8zks2xmn92b";
      type = "gem";
    };
    version = "5.5.0";
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
      sha256 = "1yw6nvkvddriacmva8hm0za0961d6j96dm7zm6748rmyzcfqgvf8";
      type = "gem";
    };
    version = "8.0.2";
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
      sha256 = "1dwgab330lsv4qppw3f52mc4ihr8lagxgll53mkmcdgr4hf3xqck";
      type = "gem";
    };
    version = "3.2.7";
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
      sha256 = "1s7zcxlmg88a6dam4aqbgk9xkpy6dkdfqmmcszkkliy3q3w38m2r";
      type = "gem";
    };
    version = "2.1.2";
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
      sha256 = "0g0iq4i93h24fzccp55aggg9agv1myi57y8ljpvv01chkxkr14i7";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "1hi25xz5ijz3kjx4vsiywqbq05mlkas7di8pwc3p6mhyn34sg5z7";
      type = "gem";
    };
    version = "1.7.1";
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
      sha256 = "17n2zx2ryjqq8a95pzin7v4k92b49ancy6cn2ddzia80rkgwc9pn";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "009p524zl0p0kfa65nii8wdmaigkmawv9pbvlcffky7islmmp0nb";
      type = "gem";
    };
    version = "13.4.2";
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
      "prism"
      "tsort"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x067q8cdam4kv5dc09iq2nzca8qm2kdl0dr22gc0ny0vj3bixsi";
      type = "gem";
    };
    version = "4.2.0";
  };
  rchardet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0csz2dybi0y1w22dzxpllkcnr5dmr1w0y4xb947c2ka6bwcwnhg0";
      type = "gem";
    };
    version = "1.10.2";
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
      sha256 = "1dq2bani47fzyqpb4psizfmzxiznvzlajmdikdgik67wd3jx8l0g";
      type = "gem";
    };
    version = "6.17.0";
  };
  re2 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03fijb9j41nmmh97wb2ih5jzrqpdhhzxdipjgxh4yc4sfj1z6bwx";
      type = "gem";
    };
    version = "2.28.0";
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
      sha256 = "06ddk6dr7h3w3qvz18795md3nbh2c52bm1bl8vz3ac44s41zccqa";
      type = "gem";
    };
    version = "0.5.0";
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
  RedCloth = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15r2h7rfp4bi9i0bfmvgnmvmw0kl3byyac53rcakk4qsv7yv4caj";
      type = "gem";
    };
    version = "4.3.4";
  };
  redis = {
    dependencies = [ "redis-client" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19ndpji1plvkvb0x180lfkpc1fb3ig8cszpcb6vqcs8hvl7c2wfy";
      type = "gem";
    };
    version = "6.0.0";
  };
  redis-client = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0baj2r8wa6imzfndyz6cj732v8nq02wy7nicfciqdr5zgdfbqlai";
      type = "gem";
    };
    version = "0.30.1";
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
      sha256 = "1nnk26gd6wg0yp6d95qli83dwy6w7dmda6vn6hcrjbb0k8zyv9xy";
      type = "gem";
    };
    version = "1.12.0";
  };
  regexp_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jxl6c5cagjz5i5n9jplhdy2izad6wapmwgfhqggb22nqfvvdvas";
      type = "gem";
    };
    version = "2.13.1";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gaq2lc463ap1srz7y5kh2p4dxazs7vjrpiby58d9yfvan72s0av";
      type = "gem";
    };
    version = "0.7.0";
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
  rinku = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zcdha17s1wzxyc5814j6319wqg33jbn58pg6wmxpws36476fq4b";
      type = "gem";
    };
    version = "2.0.6";
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
      sha256 = "1g37nxnvs2aw3j92mvmafzql9ra68x4g37a5hrqdpn6w0ypsnv0l";
      type = "gem";
    };
    version = "7.1.7";
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
      sha256 = "1l4nh82hq54nxgyisdcf8vbkpzm149p9kff5k0vpwp8w76zvg0lw";
      type = "gem";
    };
    version = "1.91.0";
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
      sha256 = "1nw84xk6vc2ls8sxqvyhxs2agh4l0jrws85d4bi3x0501lq8ijmr";
      type = "gem";
    };
    version = "1.50.0";
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
      sha256 = "0gaq685p1zizhsbax8gakraq46lhvy8m82v86688rzrpf9cg3j2c";
      type = "gem";
    };
    version = "0.26.11";
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
      sha256 = "0859xi0shidwb9cfbczxsk8qrbi3qkmkp9xzyca1xzp0gmzv7ni3";
      type = "gem";
    };
    version = "4.1.0";
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
  ruby2ruby = {
    dependencies = [ "sexp_processor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06qbjnfipy52b5ym7i4mbphjp9plsk7bkc7cwj5mg5x5g6p1pyb3";
      type = "gem";
    };
    version = "2.6.2";
  };
  rubypants = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kv2way45d2dz3h5b7wxyw36clvlwrz7ydf6699d0za5vm56gsrh";
      type = "gem";
    };
    version = "0.7.1";
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
      sha256 = "1iyk4gz5jyipj47mhxjcbm3szmm81cl0w18d2gv1kpqwwm855r66";
      type = "gem";
    };
    version = "1.9.6";
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
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "036nlabvh2hrb1dpvkh6nwidvnjiqrwqfzcqjr89flf85xj14mys";
      type = "gem";
    };
    version = "1.7.1";
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
      sha256 = "1akbndx7p77v3xjzz4jyk6mzchbm1qmlmwa90pacb7dayxz3dr6d";
      type = "gem";
    };
    version = "0.28.4";
  };
  sequel = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zpzbsjpm1xj2j01n18r0n97g8n31hf8bx6pjy20qqid8isd9lg0";
      type = "gem";
    };
    version = "5.109.0";
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
      sha256 = "18ikpnndanqxqp37ij8122l98iy3w4zkmyi8m5a7gc2crya802i3";
      type = "gem";
    };
    version = "1.20.0";
  };
  sexp_processor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07vc5ih82b64bd8swf6h1gnkkqjcn6ndnlfv0vganxv3n2fhwp9w";
      type = "gem";
    };
    version = "4.17.6";
  };
  simplecov = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "118fdpg7h1ny1fz6kmiyz6gccvwmb23h6bhsi1hdpf7ib4byq8ia";
      type = "gem";
    };
    version = "1.3.2";
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
      sha256 = "0z20lz4y794x7xd5ih32w811sarvq50c77vkcf1fxajc95n14wg7";
      type = "gem";
    };
    version = "0.59.2";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13nh4kd96d28dv3habjv2fiap30ccb73lz8mqx5d0834jl3fcvwm";
      type = "gem";
    };
    version = "2.9.6";
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
      sha256 = "0n18b7419mrxm9dc6qlgbcrrpxrw14b1xaadnmzzgfhz8a9flraa";
      type = "gem";
    };
    version = "1.57.0";
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
      sha256 = "1h6rgsjzgpzybsq5jlwwnay19xid4g19ja13rrs4clxnmmhfb7rn";
      type = "gem";
    };
    version = "0.10.7";
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
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xp6g7fkdwd694acs8djvi4sd2sd9mb0kd8psb9k9z08s8dgxjzw";
      type = "gem";
    };
    version = "0.25.0";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19d3k8ym9bj9j98zmc0pbjnwqdg4mqabnh8hm7lrdfhb5383amys";
      type = "gem";
    };
    version = "2.9.0";
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
      sha256 = "121ncml1z2yajpqskqa050rx76gd5avsb9j791kscbsbrisi8gml";
      type = "gem";
    };
    version = "3.4.0";
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
      sha256 = "00n7s0svfg7ybi7hb2q4pcac36vmf2xsyx9237zv7b624yc4bfyl";
      type = "gem";
    };
    version = "1.12.0";
  };
  unicode-display_width = {
    dependencies = [ "unicode-emoji" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04xnl0zwpjjvxipd6rdnxkm11pfhbhhi3179yzv51nqi9dmacyjb";
      type = "gem";
    };
    version = "3.3.0";
  };
  unicode-emoji = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kp89lja8ii7l6f0bq5vdxq1p3kxr3a2qmmhdc38qdwh6akjzh0i";
      type = "gem";
    };
    version = "4.3.0";
  };
  unicode-name = {
    dependencies = [ "unicode-types" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xm3rm9vvqx8djy8h3bha6h04bb1ld1lvxx4hjgpj95w2k5f7wmq";
      type = "gem";
    };
    version = "1.15.1";
  };
  unicode-scripts = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jmnzv0rlgj0il563r17fivlw7s7ynw721ay5c02sp1aln2k7q23";
      type = "gem";
    };
    version = "1.13.0";
  };
  unicode-types = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xk38f9phcvgyhlmwp7jm4f5hcmp6kw3syd34l1sbhpc5hss89ky";
      type = "gem";
    };
    version = "1.12.0";
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
      sha256 = "0h5q6a4g3an89w70z1rgzindwlxj6dc50nb6dq9m592fjq2nkm5p";
      type = "gem";
    };
    version = "9.1.0";
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
      sha256 = "0ij19k6034x0c4hw0ywa7wnk5s912r8aq0hhjss10d5z36q5dicp";
      type = "gem";
    };
    version = "0.8.2";
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
  wikicloth = {
    dependencies = [
      "builder"
      "expression_parser"
      "rinku"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jp6c2yzyqbap8jdiw8yz6l08sradky1llhyhmrg934l1b5akj3s";
      type = "gem";
    };
    version = "0.8.1";
  };
  xcodeproj = {
    dependencies = [
      "CFPropertyList"
      "atomos"
      "base64"
      "claide"
      "colored2"
      "nanaimo"
      "nkf"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p6dnpjqf50klc4br8121q2qdk01xzb8kb17r8bri7bk007nf4kg";
      type = "gem";
    };
    version = "1.28.1";
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
      sha256 = "0lfwngmsz3xq9k9la9890cqpm4vk3rda4171yzms7f3w7x4i3qjj";
      type = "gem";
    };
    version = "0.9.45";
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
      sha256 = "1rcjpgyzmdxp8rdw466156fmr588k9q1wg8j42g0dkk7hid1519c";
      type = "gem";
    };
    version = "2.8.3";
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
