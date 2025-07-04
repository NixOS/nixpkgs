{
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g5iGH57ixGcag1erOemzigRf1lb2aFo91YkMJBnb/a8=";
      type = "gem";
    };
    version = "7.2.2.1";
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
      hash = "sha256-eaMfccMtUThxfCEE4P8QX12CkiJHyFvcoUTycg5n+rk=";
      type = "gem";
    };
    version = "7.2.2.1";
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
      hash = "sha256-hCvL+Kkpd/gPtHUGYaI3z13U/dRCBms8NeiK+0iGR/U=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
  async = {
    dependencies = [
      "console"
      "fiber-annotation"
      "io-event"
      "metrics"
      "traces"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gyPzlCBG/PIG6sJWlUtBnwkzpEnZl7D8qSb50RjrSVw=";
      type = "gem";
    };
    version = "2.23.0";
  };
  async-dns = {
    dependencies = [
      "async"
      "io-endpoint"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AkINGo2UJFoh7sDo2yVfLocgI8YCgsGq23UKupZL31s=";
      type = "gem";
    };
    version = "1.4.1";
  };
  async-http = {
    dependencies = [
      "async"
      "async-pool"
      "io-endpoint"
      "io-stream"
      "metrics"
      "protocol-http"
      "protocol-http1"
      "protocol-http2"
      "traces"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+1/w23u3ex7jUsrWJIi+TH93uidxN1eyZux3ZrQAGoA=";
      type = "gem";
    };
    version = "0.87.0";
  };
  async-io = {
    dependencies = [ "async" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iS6vCkJ6L6/pmL+KfLfviPQ/RpofS4kGnABcq9fNXsc=";
      type = "gem";
    };
    version = "1.43.2";
  };
  async-pool = {
    dependencies = [ "async" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tUL53sw0/T1tBURXZAi7edbS0qqcpGenW1RqxFdlAIo=";
      type = "gem";
    };
    version = "0.10.3";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  benchmark = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DxL4xJVUXjcQw+TwSA9j8GtMhCzJTOx/M6lW9RgOh0o=";
      type = "gem";
    };
    version = "0.4.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/x0IDFSGtacLfyBWpjkJqIwo9Iq6sGZWCanXav62Mw=";
      type = "gem";
    };
    version = "3.1.9";
  };
  chars = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TSOeDKp7s4xbJr18NAhAUhqPTRSLuiKuo48+gkOct+4=";
      type = "gem";
    };
    version = "0.3.3";
  };
  combinatorics = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-J5yj4KaiQrqlDmIMRn0iILAFFfIflUJ8QYXSweGYky8=";
      type = "gem";
    };
    version = "0.5.0";
  };
  command_kit = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5X8pz1ruT1ccIQBB2RD/h/hXSeQt/nUTnFfMk9hK+pA=";
      type = "gem";
    };
    version = "0.6.0";
  };
  command_mapper = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Fvra2vJngrfMehImw/e7FQ/XscO01TKK5kxS6HZhoiM=";
      type = "gem";
    };
    version = "0.3.2";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gTs+N6ym3yoho7nx1Jf4y6skorlMqzJb/+Ze4PbL68Y=";
      type = "gem";
    };
    version = "1.3.5";
  };
  connection_pool = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IzuS+NOOA4wTSczqZd03cnJ9Zp1tLnH5iXyL9c1T6/w=";
      type = "gem";
    };
    version = "2.5.0";
  };
  console = {
    dependencies = [
      "fiber-annotation"
      "fiber-local"
      "json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rZVNhhnVjAfqhAJfqWcJ8tqz8Ruo9pQtS1AfldlCbQE=";
      type = "gem";
    };
    version = "1.29.3";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b/DBNeZeSF0YZN3mwXA7YNNMyeGb7YRSg0oLKKUZvU4=";
      type = "gem";
    };
    version = "3.3.2";
  };
  date = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vyaOFO9xWACb/q7EC1+jxycZBuiLGW2VionUtAir5k8=";
      type = "gem";
    };
    version = "3.4.1";
  };
  drb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6dRyv3hfVYuWslNYuuEVZG2g2/1FEHrYWLC8DZNcs0A=";
      type = "gem";
    };
    version = "2.2.1";
  };
  dry-configurable = {
    dependencies = [
      "dry-core"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iC2GKFhWf8EhDSVJ1MCQ80Nw/Bu3xcGTPeP+eS4Yr6g=";
      type = "gem";
    };
    version = "1.3.0";
  };
  dry-core = {
    dependencies = [
      "concurrent-ruby"
      "logger"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CQOCGpcHZJp9pUWizYjiDzpmOrHFKIq9f5FPp3UasZU=";
      type = "gem";
    };
    version = "1.1.0";
  };
  dry-inflector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IvXQtQ/VcHSuV+LKF+OzAOV1ZMIYJp3Pgv8+QtPzjy4=";
      type = "gem";
    };
    version = "1.2.0";
  };
  dry-initializer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-N9WXmPkS3Aoe/hSk20qTBpiQB7MC3NXyXQoqIMFmxOM=";
      type = "gem";
    };
    version = "3.2.0";
  };
  dry-logic = {
    dependencies = [
      "bigdecimal"
      "concurrent-ruby"
      "dry-core"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2m/tvA+Q/EH5sMx+bwX11SnR7672yNzI4HM/aFdFzqI=";
      type = "gem";
    };
    version = "1.6.0";
  };
  dry-schema = {
    dependencies = [
      "concurrent-ruby"
      "dry-configurable"
      "dry-core"
      "dry-initializer"
      "dry-logic"
      "dry-types"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7EBhXhIgQFl8uy8oayN/Wajx9VjgBxJQeIpTwSX3Qqk=";
      type = "gem";
    };
    version = "1.14.0";
  };
  dry-struct = {
    dependencies = [
      "dry-core"
      "dry-types"
      "ice_nine"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QgCROiSjaTLVMdcmoABn9ye0vQPVEdJn9YujqGvuU64=";
      type = "gem";
    };
    version = "1.7.1";
  };
  dry-types = {
    dependencies = [
      "bigdecimal"
      "concurrent-ruby"
      "dry-core"
      "dry-inflector"
      "dry-logic"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yE6a2mlBnHJ8OxLhkeDtfSxtWNBA1V556hbg6/iz7A8=";
      type = "gem";
    };
    version = "1.8.2";
  };
  dry-validation = {
    dependencies = [
      "concurrent-ruby"
      "dry-core"
      "dry-initializer"
      "dry-schema"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cJALtaLZEciqtWbT42DGv/OJuL+S6o4EiFzlHEH/gIU=";
      type = "gem";
    };
    version = "1.11.1";
  };
  fake_io = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tjZqUhkmlQUnUVgXSjGYHeGdQf+grYgophQz0SxLpYA=";
      type = "gem";
    };
    version = "0.1.0";
  };
  ferrum = {
    dependencies = [
      "addressable"
      "base64"
      "concurrent-ruby"
      "webrick"
      "websocket-driver"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zubzhSQTan50M4Rbft1tZKFzzirYuSdY6jZ2P47KjdM=";
      type = "gem";
    };
    version = "0.16";
  };
  fiber-annotation = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-er+t8dEZ9QiGfUEDvyMcA1TQGcw5pXOJRd7C7a2vbAM=";
      type = "gem";
    };
    version = "0.2.0";
  };
  fiber-local = {
    dependencies = [ "fiber-storage" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yIX5TyEPubBXN95l1RETbqYC4AxRBZU3SKoPh5NInwY=";
      type = "gem";
    };
    version = "1.1.0";
  };
  fiber-storage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uAoyPx4LleebEcHU339lTb5RfBGjRMkPKkPexnulq38=";
      type = "gem";
    };
    version = "1.0.0";
  };
  hexdump = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-c0uD5E4erx0X87DjcGz/j78Sp+1X1nsWALHKFwsycfM=";
      type = "gem";
    };
    version = "1.0.1";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zrpXP4E4/ywJFUJ/H8W99Ko6uK6IyM4lXrPs8KEaXQ8=";
      type = "gem";
    };
    version = "1.14.7";
  };
  ice_nine = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XVBqfScj1VktwSG5ko5JMXQnMBMfIqGjdknfHB4uY9s=";
      type = "gem";
    };
    version = "0.11.2";
  };
  io-console = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zWqfrLxphx1pssuLkm/G6n7wbwblBegaZPFKRw/d76I=";
      type = "gem";
    };
    version = "0.8.0";
  };
  io-endpoint = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Hn6Qu2g5RSiAdbQ6xQWroRRgooFgAja1+PvCEM+HjyU=";
      type = "gem";
    };
    version = "0.15.2";
  };
  io-event = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TCYrZhCtZDor516JITWspPpn7cZ9GUTArmtuXdc/T8E=";
      type = "gem";
    };
    version = "1.9.0";
  };
  io-stream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RSDwwUEt/SZOmrDTY+msqQpDVBhQIgtH8evVSZrS6W8=";
      type = "gem";
    };
    version = "0.6.1";
  };
  irb = {
    dependencies = [
      "pp"
      "rdoc"
      "reline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2bynRaxCB6i3KKUrmLdmypCbhv8aUEvN49b4yE+q6JA=";
      type = "gem";
    };
    version = "1.15.1";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3ciK2Robrz8AOMF08lOvOwhtMNx02xfKQlm73pgvlNw=";
      type = "gem";
    };
    version = "2.10.1";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3WGNJOY3cVRycy5+7QLjPPvfVt6q0iXt0PH4nTgCQBc=";
      type = "gem";
    };
    version = "1.6.6";
  };
  metrics = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QuyO6tuSpXVJpyvdG6+G1CcAibxZiRe5PPnLb5X8wpw=";
      type = "gem";
    };
    version = "0.12.1";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkcTbNrATOgXULtsCXM7N4lb8GliVU5LQFbXgWjXCnU=";
      type = "gem";
    };
    version = "2.8.8";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nPLK4lrE38kMmI68O5F/U8BUl4tnMnPaG9ILywd4+Uc=";
      type = "gem";
    };
    version = "5.25.4";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H9BBOLbkqQAX6NG4BMA5AxOZhm/z+6u3girqNnx4YV0=";
      type = "gem";
    };
    version = "1.15.0";
  };
  mustermann = {
    dependencies = [ "ruby2_keywords" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0fjpui3a7UcVDd+B9qfqBGgmtkxnL7yS2DvOa3Blfog=";
      type = "gem";
    };
    version = "3.0.3";
  };
  net-ftp = {
    dependencies = [
      "net-protocol"
      "time"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KNY+QHp+25c5wyCk+q7FFeQ+ljgVJI0GQYq6MiR4h08=";
      type = "gem";
    };
    version = "0.3.8";
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
      hash = "sha256-Ht6ASO5oihQgYGC/N6cW0Yy26gCFX2ybFdrul+5R++U=";
      type = "gem";
    };
    version = "0.5.6";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hItOmCATwVsvA4J5Imh2O3SMzpHJ6R42sPJ+0mQg3/M=";
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
      hash = "sha256-qnPgy6ahJTad6YN7jY74KmGEk2DroFIZAOLDcTqhYqg=";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Zagr2PFJPzrSymw01IZXDDYLdkWpC8Dxio6cOW3BzY=";
      type = "gem";
    };
    version = "0.5.1";
  };
  nio4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2V3uaOC7JRuP+QrDQjpRHjt4QSTl23/19IE6IgrnPKk=";
      type = "gem";
    };
    version = "2.7.4";
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
      hash = "sha256-a5/DsU/Qzt0h9srYz1ZRI7p0AeVrXQrsGAwjzcoo/Vo=";
      type = "gem";
    };
    version = "1.18.3";
  };
  nokogiri-diff = {
    dependencies = [
      "nokogiri"
      "tdiff"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0g+mksBCpQCGyvr21a7yeXX0P/gK5ivgYApHt/55JvU=";
      type = "gem";
    };
    version = "0.3.0";
  };
  nokogiri-ext = {
    dependencies = [ "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-adJjm72fs6PFw1y5PZyjnGeUWdIUBZoIS94WWNtsTw4=";
      type = "gem";
    };
    version = "0.1.1";
  };
  open_namespace = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tEO8F9HTBaUERtQoUn+tl73Bz7wniy/vfZW4ufZI4Ew=";
      type = "gem";
    };
    version = "0.4.2";
  };
  pagy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OyQY55vWerusgg3dr2/XZmW6xBcLL+8PSmAaZADvGgc=";
      type = "gem";
    };
    version = "6.5.0";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lH7DEgxvkhlfjuiqJaeyxSl7sQbYO0G6oCmDaGV3tv8=";
      type = "gem";
    };
    version = "0.6.2";
  };
  prettyprint = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K8nhVYGpR0IGSjzIsPudRarj0Dobqm74CSJiegdm8ZM=";
      type = "gem";
    };
    version = "0.2.0";
  };
  protocol-hpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b+yiOLgHjaHNKVZ31vMGxgAa+S11/gZD0z5pVsvDrZE=";
      type = "gem";
    };
    version = "1.5.1";
  };
  protocol-http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tUGapg6nSRLbJljRZyLyPuNyKcpJex0UE/UPbAT1d7c=";
      type = "gem";
    };
    version = "0.49.0";
  };
  protocol-http1 = {
    dependencies = [ "protocol-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lJKWGkzKaQn+TSPWDiysNrj+ubTBKcRCj7zz+XPKw2o=";
      type = "gem";
    };
    version = "0.30.0";
  };
  protocol-http2 = {
    dependencies = [
      "protocol-hpack"
      "protocol-http"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kZZucIPnkum1T9WmKJGlkHjf6OHPAWLOWLOH24Esp2g=";
      type = "gem";
    };
    version = "0.22.1";
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
      hash = "sha256-hKVLuVLRRgT+oi2Zk4NIgUZ4eC9YsSZI/N+k0vzoWe4=";
      type = "gem";
    };
    version = "5.2.3";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YdROHKtcu75bMQaEgc8Wl23Q3BtrB72VYX74xePgDG8=";
      type = "gem";
    };
    version = "6.0.1";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8lwGhz6z1d5fCk68eDrMgaTM/lgMdgz+MjSXeYAYrYc=";
      type = "gem";
    };
    version = "6.6.0";
  };
  python-pickle = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TmoXgf6hNsyzThfESeFx1pkVEwvkB1BJZ4gWy6nnZto=";
      type = "gem";
    };
    version = "0.2.0";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QkxJr/oZCB6SVdZdhh8te8fYOI7cDLYItebK8d1Ju4o=";
      type = "gem";
    };
    version = "2.2.11";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PHS6f8WQZkU9Ya+by6W2/nqbPatvRFQY07OR1eqO+/8=";
      type = "gem";
    };
    version = "3.2.0";
  };
  rack-session = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oCEV5UILTeA2g5uYEeP3ln1zRGpVS0KqRRBq8zWFHXY=";
      type = "gem";
    };
    version = "1.0.2";
  };
  rack-user_agent = {
    dependencies = [
      "rack"
      "woothee"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Z5vAK0Z+MJbm9+gsYpXI6DeuFPEaJsR6mwS80DviL9A=";
      type = "gem";
    };
    version = "0.5.3";
  };
  rdoc = {
    dependencies = [ "psych" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fW9wbgcL/6XRikSPJAdsv7NJI6mcHquEKqGObKafVuA=";
      type = "gem";
    };
    version = "6.12.0";
  };
  redis = {
    dependencies = [ "redis-client" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eYkA2GlBip/Dl3+RZXg3W0XDgkelVrYdWMumuwL30Gs=";
      type = "gem";
    };
    version = "5.4.0";
  };
  redis-client = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4zurZoLIFVz++V5t0paTa7nCmBqJ+1eKziegdvooNvo=";
      type = "gem";
    };
    version = "0.23.2";
  };
  redis-namespace = {
    dependencies = [ "redis" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6RoaorLYiLbeodSrjTnhrm+sNCYWH+udkd1cylmKIjk=";
      type = "gem";
    };
    version = "1.11.0";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-V2IDddy+VuwJuscZK/t0YMcWu/AFTclDReyqVDjlOdI=";
      type = "gem";
    };
    version = "0.6.0";
  };
  robots = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WtqhcXIVcKWqioLi5vINIiSGJ4Iet0H/bYCJzGDcL5A=";
      type = "gem";
    };
    version = "0.10.1";
  };
  ronin = {
    dependencies = [
      "async-io"
      "open_namespace"
      "ronin-app"
      "ronin-code-asm"
      "ronin-code-sql"
      "ronin-core"
      "ronin-db"
      "ronin-dns-proxy"
      "ronin-exploits"
      "ronin-fuzzer"
      "ronin-listener"
      "ronin-masscan"
      "ronin-nmap"
      "ronin-payloads"
      "ronin-recon"
      "ronin-repos"
      "ronin-support"
      "ronin-vulns"
      "ronin-web"
      "ronin-wordlists"
      "rouge"
      "wordlist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nJN7aLIWu3hNstAPtwHQmBHdVQOnR0PnIAF4JTvCFP4=";
      type = "gem";
    };
    version = "2.1.1";
  };
  ronin-app = {
    dependencies = [
      "dry-schema"
      "dry-struct"
      "dry-validation"
      "pagy"
      "puma"
      "redis"
      "redis-namespace"
      "ronin-core"
      "ronin-db"
      "ronin-db-activerecord"
      "ronin-exploits"
      "ronin-masscan"
      "ronin-nmap"
      "ronin-payloads"
      "ronin-recon"
      "ronin-repos"
      "ronin-support"
      "ronin-vulns"
      "ronin-web-spider"
      "sidekiq"
      "sinatra"
      "sinatra-contrib"
      "sinatra-flash"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cXgmak/Hkllr4STZq3NYcMgxvYHo3Hco63sjzAHLtLQ=";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-code-asm = {
    dependencies = [ "ruby-yasm" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9kW2RbWguD47NMYTg9QSwH0MUIKVL6Ft/hFYqulJFgc=";
      type = "gem";
    };
    version = "1.0.1";
  };
  ronin-code-sql = {
    dependencies = [ "ronin-support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3OT8W11z+D8g43CqGRnraU4atcsrIF19m397CL06q6U=";
      type = "gem";
    };
    version = "2.1.1";
  };
  ronin-core = {
    dependencies = [
      "command_kit"
      "csv"
      "irb"
      "reline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-S8SAP+EkAJsNY070Gkn+8fjAlzI2ZWJZ6LlAR1Zpv0A=";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-db = {
    dependencies = [
      "ronin-core"
      "ronin-db-activerecord"
      "ronin-support"
      "sqlite3"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-45d1ejglKF6joLgTZ7XZke29mAhqDSCPJ3kqJQbXMx8=";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-db-activerecord = {
    dependencies = [
      "activerecord"
      "uri-query_params"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-V/0dTgYOMMskxXubiLgGH41b58I153Mt+7Wr9LeBxIE=";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-dns-proxy = {
    dependencies = [
      "async-dns"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2CoX9+YDiMvoXILgVgUyOCvrpYBU5ptDi0gKxsxa1VI=";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-exploits = {
    dependencies = [
      "csv"
      "ronin-code-sql"
      "ronin-core"
      "ronin-payloads"
      "ronin-post_ex"
      "ronin-repos"
      "ronin-support"
      "ronin-vulns"
      "uri-query_params"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Qu9JXIB4orFQ+ZgIqHwCkcnHcdLoU2B1U0GdyWbM8eo=";
      type = "gem";
    };
    version = "1.1.1";
  };
  ronin-fuzzer = {
    dependencies = [
      "combinatorics"
      "ronin-core"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ftJOcybykFkmhGnZwsK3U2w8gf39ucM5uekH1Y/3e8Y=";
      type = "gem";
    };
    version = "0.2.0";
  };
  ronin-listener = {
    dependencies = [
      "ronin-core"
      "ronin-listener-dns"
      "ronin-listener-http"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-irRn75b6id82q0apTGAVOyxZUskD+LQBD9NRKUCFWkU=";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-listener-dns = {
    dependencies = [ "async-dns" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vCxBoPdNHtOnPlXk0PbsaMGsmanveou/vVnC6StICdo=";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-listener-http = {
    dependencies = [ "async-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4mckItSVfzMYxNL2CzMDApAQE0U8LO5YerkpGmwwD1s=";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-masscan = {
    dependencies = [
      "csv"
      "ronin-core"
      "ronin-db"
      "ruby-masscan"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xBCOvqdCRPK4nBTMiWQw9+zDD/UzPG1RbjVnjE3Amzw=";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-nmap = {
    dependencies = [
      "csv"
      "ronin-core"
      "ronin-db"
      "ruby-nmap"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pD1LCTLZeNsfb46MHcD8mOz9ZDmYQtLrpInu0XqDx3U=";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-payloads = {
    dependencies = [
      "ronin-code-asm"
      "ronin-core"
      "ronin-post_ex"
      "ronin-repos"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/QgMoNn+oQAjLzGiHQeQqDvanqvUN6tcHOTcUIcf/C8=";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-post_ex = {
    dependencies = [
      "fake_io"
      "hexdump"
      "ronin-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-h4MOARyMWb01ODvS14rthzI1yoMT/dRKlRJHiz61lzU=";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-recon = {
    dependencies = [
      "async-dns"
      "async-http"
      "async-io"
      "ronin-core"
      "ronin-db"
      "ronin-masscan"
      "ronin-nmap"
      "ronin-repos"
      "ronin-support"
      "ronin-web-spider"
      "thread-local"
      "wordlist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0Dnz+TVZKm5ZQs1gndIxAqDh+BTO/VRz+nyyNiiU2IU=";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-repos = {
    dependencies = [ "ronin-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-njOuoEOYZ9YhXa3Adj3hQlI5vB9bv2pfGSIZIDEw15Y=";
      type = "gem";
    };
    version = "0.2.0";
  };
  ronin-support = {
    dependencies = [
      "addressable"
      "base64"
      "chars"
      "combinatorics"
      "hexdump"
      "uri-query_params"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LuVVOXaOPxhi9Kq1aA5vdqdBQduiww/Z1O27HH1BzjU=";
      type = "gem";
    };
    version = "1.1.1";
  };
  ronin-support-web = {
    dependencies = [
      "nokogiri"
      "nokogiri-ext"
      "ronin-support"
      "websocket"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DBO/uxwfN1HWOXgtCEqXB+amseDAuq919ji9q+oX7yU=";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-vulns = {
    dependencies = [
      "base64"
      "ronin-core"
      "ronin-db"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PQcv+EIbYcUhsqg6j/BC6gDhXyQ/myfAmY2bNw7t9YY=";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-web = {
    dependencies = [
      "nokogiri"
      "nokogiri-diff"
      "open_namespace"
      "robots"
      "ronin-core"
      "ronin-support"
      "ronin-support-web"
      "ronin-vulns"
      "ronin-web-browser"
      "ronin-web-server"
      "ronin-web-session_cookie"
      "ronin-web-spider"
      "ronin-web-user_agents"
      "wordlist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MfU2AGF8akuzjsoM8bS7Pm/9iClxiT+fNzbsMX7krSc=";
      type = "gem";
    };
    version = "2.0.1";
  };
  ronin-web-browser = {
    dependencies = [
      "ferrum"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z7t8VG/HpAPFFxh4ulUjCHq4NKHR7n+BQmroV3glDTQ=";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-web-server = {
    dependencies = [
      "rack"
      "rack-user_agent"
      "ronin-support"
      "sinatra"
      "webrick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EIMQJl+Y/wQ5KTY4C6P0PcqjlCB5P297xaD7AjgKYN8=";
      type = "gem";
    };
    version = "0.1.2";
  };
  ronin-web-session_cookie = {
    dependencies = [
      "base64"
      "python-pickle"
      "rack-session"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-90UeccrpdyjDbpULsq/pw04W+dDf0uDvDuocTeHkJW8=";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-web-spider = {
    dependencies = [
      "ronin-support"
      "spidr"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fLxH34YX5aG9vCbLpllXXoyYrqOi8Fb/hSMbha8PuzE=";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-web-user_agents = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IRyQz0AXzDeAg0+ho0cFVro11dpOJ1ndpkYCiwuiwBs=";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-wordlists = {
    dependencies = [
      "ronin-core"
      "wordlist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SnfRVUFwkM3Et6Mi8yRX1AvaWoEQJgyhMgg/r2wLyyc=";
      type = "gem";
    };
    version = "0.1.0";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o9NTIiqnLkniyGcmwLz9cZ+CWS9X1JRHRlX0jmaezrY=";
      type = "gem";
    };
    version = "3.30.0";
  };
  ruby-masscan = {
    dependencies = [ "command_mapper" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cd1bsEI1OZJHKtvryA9BaWlPdawYTM+4CNx/AVWTEgU=";
      type = "gem";
    };
    version = "0.3.0";
  };
  ruby-nmap = {
    dependencies = [
      "command_mapper"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vja9v1QdkW7kDrAHRZytwR0BAoJx2wsQ9w1NDeTDQJ0=";
      type = "gem";
    };
    version = "1.0.3";
  };
  ruby-yasm = {
    dependencies = [ "command_mapper" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zfm/NEWB3280LSxjhiyIDeXoUVZWVAMx0fnwWlq57Rk=";
      type = "gem";
    };
    version = "0.3.1";
  };
  ruby2_keywords = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/9E3QMVztzAc96LmH8hXsqjj06/zJUXW+DANi64Q4+8=";
      type = "gem";
    };
    version = "0.0.5";
  };
  securerandom = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zFGT1BSkNBtuIl8MtERqzsqOUNXhiIdD+sFph2OOoLE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  sidekiq = {
    dependencies = [
      "base64"
      "connection_pool"
      "logger"
      "rack"
      "redis-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EQhxLh3viQArKONUXVrhXUpX/9TSwl2XuxNgmIgmtac=";
      type = "gem";
    };
    version = "7.3.9";
  };
  sinatra = {
    dependencies = [
      "mustermann"
      "rack"
      "rack-protection"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bnJ/TQNOhwZ9mqs38ygCHXwWci/9KT7we26WiRUQmAc=";
      type = "gem";
    };
    version = "3.2.0";
  };
  sinatra-contrib = {
    dependencies = [
      "multi_json"
      "mustermann"
      "rack-protection"
      "sinatra"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DDKp4essIum1l8BE/t3ggD9neaqnCQ0HRFWtg6rx78E=";
      type = "gem";
    };
    version = "3.2.0";
  };
  sinatra-flash = {
    dependencies = [ "sinatra" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/vBE2kNBhA3N3G8cyVgsK6vGkyrvvxsAzaZvO/b3F+4=";
      type = "gem";
    };
    version = "0.3.0";
  };
  spidr = {
    dependencies = [
      "base64"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-El8KNEeRIrlrR8sAqcmPtY4K2vpJdrhKRlSbxB71Qq4=";
      type = "gem";
    };
    version = "0.7.2";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+nf2PHCVSPRtTptrtFzaUqo4gaoSzIWZETJ1jolocBw=";
      type = "gem";
    };
    version = "1.7.3";
  };
  stringio = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vKkkYVFaExU1dDvIHVVZ+h3n2Az/mmVNbAr2+fJ+Ncg=";
      type = "gem";
    };
    version = "3.1.5";
  };
  tdiff = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aFu+U4B+SSZy29qrlTLL8AHnn2W7x5gszQRB7I1UkzA=";
      type = "gem";
    };
    version = "0.4.0";
  };
  thread-local = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L7Vo0x8O8ngGP0Wjkjxe1i7lwz2oE0EDvH0uzbh70uc=";
      type = "gem";
    };
    version = "1.1.0";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jj10hGbg2D5RCqGi4ige/1R5N/DvBr4z02MnIeJV92s=";
      type = "gem";
    };
    version = "2.6.0";
  };
  time = {
    dependencies = [ "date" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A182BQikpNury7zTiGVmuavUMt6JE2eV0v967FvN6mE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lQnwebK1X+QjbXljO9deNMHB5+P7S1bLX9ph+AoP4w4=";
      type = "gem";
    };
    version = "0.4.3";
  };
  traces = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0lR4NLcki7jI9PZTLGubqA744tYGjOFueHNXXXuALYE=";
      type = "gem";
    };
    version = "0.15.2";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ja+CjMd7z31jsOO9tsqkfiJy3Pr0+/5G+MOp3wh6gps=";
      type = "gem";
    };
    version = "2.0.6";
  };
  uri-query_params = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cVHbrgRymeKMrJDyYKdArCkPsFGvzCnZL9rd9H8a/Hw=";
      type = "gem";
    };
    version = "0.8.2";
  };
  webrick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tC08lPFm8/tz2H6bNZ3vm1g2xCb8i+rPOPIYSiGyqYk=";
      type = "gem";
    };
    version = "1.9.1";
  };
  websocket = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-t+enTiQQtehcJYWLJrMyLykWHjAJNfcKDg08NeBGJzc=";
      type = "gem";
    };
    version = "1.2.11";
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
      hash = "sha256-BW2Z8s1UVxLPsSkWUP3nR45PJmHcHbag+juWYjGhRrQ=";
      type = "gem";
    };
    version = "0.7.7";
  };
  websocket-extensions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HGumMJLNo0PrU/xlcRDHHHVMVkhKrUJXhJUifXF6gkE=";
      type = "gem";
    };
    version = "0.1.5";
  };
  woothee = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zI12K+J/OR5cP2+Ot0woYispPhpqpWWI04/rBCIO43U=";
      type = "gem";
    };
    version = "1.13.0";
  };
  wordlist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rb7SOmjKMJ42BU4k80jlue0SD2IV8J+sMJF4W9LV4NE=";
      type = "gem";
    };
    version = "1.1.1";
  };
  zeitwerk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hC4GfLEeuSPXRySbrftfzcllLW8gofBkUzF5IP3NRnM=";
      type = "gem";
    };
    version = "2.7.2";
  };
}
