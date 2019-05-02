{
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bcm2hchn897xjhqj9zzsxf3n9xhddymj4lsclz508f4vw3av46l";
      type = "gem";
    };
    version = "2.6.0";
  };
  commonmarker = {
    dependencies = ["ruby-enum"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "122dy5mzx4p86flpzyg3raf742zp5ab9bjr7zk29p3ixpncf0rdk";
      type = "gem";
    };
    version = "0.18.2";
  };
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x07r23s7836cpp5z9yrlbpljcxpax14yw4fy4bnp6crhr6x24an";
      type = "gem";
    };
    version = "1.1.5";
  };
  daemons = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l5gai3vd4g7aqff0k1mp41j9zcsvm2rbwmqn115a325k9r7pf4w";
      type = "gem";
    };
    version = "1.3.1";
  };
  em-websocket = {
    dependencies = ["addressable" "eventmachine"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xkb1rc6dd3y5s7qsp4wqrri3n9gwsbvnwwv6xwgp241jxdpp4iq";
      type = "gem";
    };
    version = "0.3.8";
  };
  eventmachine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  fidget = {
    dependencies = ["ruby-dbus"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04g2846wjlb8ms5041lv37aqs4jzsziwv58bxg7yzc61pdvi4ksb";
      type = "gem";
    };
    version = "0.0.6";
  };
  gli = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "133glfzsq67ykmdsgp251s9kddg9x4qki2jpbjv25h3hawlql4hs";
      type = "gem";
    };
    version = "2.18.0";
  };
  htmlentities = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hfxnlyr618s25xpafw9mypa82qppjccbh292c4l3bj36az7f6wl";
      type = "gem";
    };
    version = "1.6.0";
  };
  iso-639 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10k1gpkkbxbasgjzh4hd32ygxzjb5312rphipm46ryxkpx556zzz";
      type = "gem";
    };
    version = "0.2.8";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sx97bm9by389rbzv8r1f43h06xcz8vwi3h5jv074gvparql7lcx";
      type = "gem";
    };
    version = "2.2.0";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zplpfw3knqifj9bpf604rb3wc1vhq6363pd6lvhayng8wql5vy";
      type = "gem";
    };
    version = "2.4.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09zll7c6j7xr6wyvh5mm5ncj6pkryp70ybcsxdbw1nyphx5dh184";
      type = "gem";
    };
    version = "1.10.1";
  };
  parslet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12nrzfwjphjlakb9pmpj70hgjwgzvnr8i1zfzddifgyd44vspl88";
      type = "gem";
    };
    version = "1.8.2";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08q64b5br692dd3v0a9wq9q5dvycc6kmiqmjbdxkxbfizggsvx6l";
      type = "gem";
    };
    version = "3.0.3";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9926ln2lw12lfxm4ylq1h6nl0rafl10za3xvjzc87qvnqic87f";
      type = "gem";
    };
    version = "1.6.11";
  };
  rack-contrib = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l7m0av4pjl5p64l8j7pkip1jwhkp80a8kc2j7b9lrwh04fgx5wx";
      type = "gem";
    };
    version = "1.8.0";
  };
  rack-protection = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0my0wlw4a5l3hs79jkx2xzv7djhajgf8d28k8ai1ddlnxxb0v7ss";
      type = "gem";
    };
    version = "1.5.5";
  };
  redcarpet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h9qz2hik4s9knpmbwrzb3jcp3vc5vygp9ya8lcpl7f1l9khmcd7";
      type = "gem";
    };
    version = "3.4.0";
  };
  ruby-dbus = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16lsqdwas6ngyyvq51l7lynj5ayis17zm5hpsg5x3m3n6r5k2gv4";
      type = "gem";
    };
    version = "0.14.1";
  };
  ruby-enum = {
    dependencies = ["i18n"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h62avini866kxpjzqxlqnajma3yvj0y25l6hn9h2mv5pp6fcrhx";
      type = "gem";
    };
    version = "0.7.2";
  };
  showoff = {
    dependencies = ["commonmarker" "fidget" "gli" "htmlentities" "i18n" "iso-639" "json" "nokogiri" "parslet" "rack-contrib" "redcarpet" "sinatra" "sinatra-websocket" "thin" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14884kh7vrp5b72dpn7q26h49y7igxqza72girkv1h28qx4kqw4r";
      type = "gem";
    };
    version = "0.20.1";
  };
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byxzl7rx3ki0xd7aiv1x8mbah7hzd8f81l65nq8857kmgzj1jqq";
      type = "gem";
    };
    version = "1.4.8";
  };
  sinatra-websocket = {
    dependencies = ["em-websocket" "eventmachine" "thin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0as52mfw34z3ba6qjab009h2rdn0za0iwrc42kw948hbb8qzcm5m";
      type = "gem";
    };
    version = "0.3.1";
  };
  thin = {
    dependencies = ["daemons" "eventmachine" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nagbf9pwy1vg09k6j4xqhbjjzrg5dwzvkn4ffvlj76fsn6vv61f";
      type = "gem";
    };
    version = "1.7.2";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ca4k0clwf0rkvy7726x4nxpjxkpv67w043i39saxgldxd97zmwz";
      type = "gem";
    };
    version = "2.0.9";
  };
}