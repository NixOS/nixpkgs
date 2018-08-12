{
  ast = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "184ssy3w93nkajlz2c70ifm79jp3j737294kbc5fjw69v1w0n9x7";
      type = "gem";
    };
    version = "2.4.0";
  };
  coderay = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vav4bhcc2x3jmi3izb11l4d9f3xv8hp2fszb7iqmpsccv1pz4y";
      type = "gem";
    };
    version = "1.1.2";
  };
  eventmachine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  htmlentities = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  jaro_winkler = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rr797nqz081bfk30m2apj5h24bg5d1jr1c8p3xwx4hbwsrbclah";
      type = "gem";
    };
    version = "1.5.1";
  };
  kramdown = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n1c4jmrh5ig8iv1rw81s4mw4xsp4v97hvf8zkigv4hn5h542qjq";
      type = "gem";
    };
    version = "1.17.0";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13d32jjadpjj6d2wdhkfpsmy68zjx90p49bgf8f7nkpz86r1fr11";
      type = "gem";
    };
    version = "2.3.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h9nml9h3m0mpvmh8jfnqvblnz5n5y3mmhgfc38avfmfzdrq9bgc";
      type = "gem";
    };
    version = "1.8.4";
  };
  parallel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01hj8v1qnyl5ndrs33g8ld8ibk0rbcqdpkpznr04gkbxd11pqn67";
      type = "gem";
    };
    version = "1.12.1";
  };
  parser = {
    dependencies = ["ast"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zp89zg7iypncszxsjp8kiccrpbdf728jl449g6cnfkz990fyb5k";
      type = "gem";
    };
    version = "2.5.1.2";
  };
  powerpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r51d67wd467rpdfl6x43y84vwm8f5ql9l9m85ak1s2sp3nc5hyv";
      type = "gem";
    };
    version = "0.1.2";
  };
  rainbow = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb2fpjspydr6x0s8pn1pqkzmxszvkfapv0p4627mywl7ky4zkhk";
      type = "gem";
    };
    version = "3.0.0";
  };
  reverse_markdown = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w7y5n74daajvl9gixr91nh8670d7mkgspkk3ql71m8azq3nffbg";
      type = "gem";
    };
    version = "1.1.0";
  };
  rubocop = {
    dependencies = ["jaro_winkler" "parallel" "parser" "powerpack" "rainbow" "ruby-progressbar" "unicode-display_width"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fc1fw9z98qd91ipsh9hdvpcb401qvkhw518s35l8a67sv4vdnj3";
      type = "gem";
    };
    version = "0.58.2";
  };
  ruby-progressbar = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1igh1xivf5h5g3y5m9b4i4j2mhz2r43kngh4ww3q1r80ch21nbfk";
      type = "gem";
    };
    version = "1.9.0";
  };
  solargraph = {
    dependencies = ["coderay" "eventmachine" "htmlentities" "kramdown" "parser" "reverse_markdown" "rubocop" "thor" "tilt" "yard"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01lh5vibr277vhhrgk6zl09ivb262c1qpk54ahzhc40zs309842b";
      type = "gem";
    };
    version = "0.23.6";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmqpyj642sk4g16nkbq6pj856adpv91lp4krwhqkh2iw63aszdl";
      type = "gem";
    };
    version = "0.20.0";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0020mrgdf11q23hm1ddd6fv691l51vi10af00f137ilcdb2ycfra";
      type = "gem";
    };
    version = "2.0.8";
  };
  unicode-display_width = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0040bsdpcmvp8w31lqi2s9s4p4h031zv52401qidmh25cgyh4a57";
      type = "gem";
    };
    version = "1.4.0";
  };
  yard = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "145pbc0x95s6x296kh1wp5ykwy6srfcz946dgj83s35g8p52z4q4";
      type = "gem";
    };
    version = "0.9.15";
  };
}