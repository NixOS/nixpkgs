{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkzg31x501l8d1hbygyh1lr4c3vnw88a3c1rxz5ifvvzb10i6zm";
      type = "gem";
    };
    version = "5.2.0";
  };
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
  };
  colorize = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "133rqj85n400qk6g3dhf2bmfws34mak1wqihvh3bgy9jhajw580b";
      type = "gem";
    };
    version = "0.8.1";
  };
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "183lszf5gx84kcpb779v6a2y0mx9sssy8dgppng1z9a505nj1qcf";
      type = "gem";
    };
    version = "1.0.5";
  };
  ethon = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y70szwm2p0b9qfvpqrzjrgm3jz0ig65vlbfr6ppc3z0m1h7kv48";
      type = "gem";
    };
    version = "0.11.0";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zw6pbyvmj8wafdc7l5h7w20zkp1vbr2805ql5d941g2b20pk4zr";
      type = "gem";
    };
    version = "1.9.23";
  };
  html-proofer = {
    dependencies = ["activesupport" "addressable" "colorize" "mercenary" "nokogiri" "parallel" "typhoeus" "yell"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06ggsx2fhsis1iw0sw12a709h99ksbs9kbmv0j05kvbak7b9m51a";
      type = "gem";
    };
    version = "3.8.0";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1milplpsdpxlvn23q6pvir4jgxsphq2ps2jgdb3i29kzpc55gm7y";
      type = "gem";
    };
    version = "1.0.1";
  };
  mercenary = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10la0xw82dh5mqab8bl0dk21zld63cqxb1g16fk8cb39ylc4n21a";
      type = "gem";
    };
    version = "0.3.6";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13d32jjadpjj6d2wdhkfpsmy68zjx90p49bgf8f7nkpz86r1fr11";
      type = "gem";
    };
    version = "2.3.0";
  };
  minitest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0icglrhghgwdlnzzp4jf76b0mbc71s80njn5afyfjn4wqji8mqbq";
      type = "gem";
    };
    version = "5.11.3";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05fm3xh462glvs0rwnfmc1spmgl4ljg2giifynbmwwqvl42zaaiq";
      type = "gem";
    };
    version = "1.8.2";
  };
  parallel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01hj8v1qnyl5ndrs33g8ld8ibk0rbcqdpkpznr04gkbxd11pqn67";
      type = "gem";
    };
    version = "1.12.1";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x5h1dh1i3gwc01jbg01rly2g6a1qwhynb1s8a30ic507z1nh09s";
      type = "gem";
    };
    version = "3.0.2";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  typhoeus = {
    dependencies = ["ethon"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01pd16n6bvknyip42r1r7js0j8x8ly37gmr72z3695zcczh1blyq";
      type = "gem";
    };
    version = "1.3.0";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fjx9j327xpkkdlxwmkl3a8wqj7i4l4jwlrv3z13mg95z9wl253z";
      type = "gem";
    };
    version = "1.2.5";
  };
  yell = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m3q1l33sznrl86myjhd2l7chma1wdcdrdmnf2fi7aydapwd4vib";
      type = "gem";
    };
    version = "2.0.7";
  };
}