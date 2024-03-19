{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    groups = ["default"];
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fvchp2rhp2rmigx7qglf69xvjqvzq7x0g49naliw29r2bz656sy";
      type = "gem";
    };
    version = "2.7.0";
  };
  coderay = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "094387x4yasb797mv07cs3g6f08y56virc2rjcpb1k79rzaj3nhl";
      type = "gem";
    };
    version = "1.1.6";
  };
  ethon = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gggrgkcq839mamx7a8jbnp2h7x2ykfn34ixwskwb0lzx2ak17g9";
      type = "gem";
    };
    version = "0.12.0";
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
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12lpwaw82bb0rm9f52v1498bpba8aj2l2q359mkwbxsswhpga5af";
      type = "gem";
    };
    version = "1.13.1";
  };
  gh = {
    dependencies = ["activesupport" "addressable" "faraday" "faraday_middleware" "multi_json" "net-http-persistent" "net-http-pipeline"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nj2dm2pahfa4d39y8csvjv5l3hpsm6yjq2y96vj2bqgg0qs26bj";
      type = "gem";
    };
    version = "0.17.0";
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
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10nq1xjqvkhngiygji831qx9bryjwws95r4vrnlq9142bzkg670s";
      type = "gem";
    };
    version = "1.8.3";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nrmw2r4nfxlfgprfgki3hjifgrcrs3l5zvm3ca3gb4743yr25mn";
      type = "gem";
    };
    version = "2.3.0";
  };
  launchy = {
    dependencies = ["addressable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190lfbiy1vwxhbgn4nl4dcbzxvm049jwc158r2x7kq3g5khjrxa2";
      type = "gem";
    };
    version = "2.4.3";
  };
  method_source = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pviwzvdqd90gn6y7illcdd9adapw8fczml933p5vl739dkvl3lq";
      type = "gem";
    };
    version = "0.9.2";
  };
  minitest = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09bz9nsznxgaf06cx3b5z71glgl0hdw469gqx3w7bqijgrb55p5g";
      type = "gem";
    };
    version = "5.14.1";
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
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zgw9zlwh2a6i1yvhhc4a84ry1hv824d6g2iw2chs3k5aylpmpfj";
      type = "gem";
    };
    version = "2.1.1";
  };
  net-http-persistent = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y9fhaax0d9kkslyiqi1zys6cvpaqx9a0y0cywp24rpygwh4s9r4";
      type = "gem";
    };
    version = "2.9.4";
  };
  net-http-pipeline = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bxjy33yhxwsbnld8xj3zv64ibgfjn9rjpiqkyd5ipmz50pww8v9";
      type = "gem";
    };
    version = "1.0.1";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mh312k3y94sj0pi160wpia0ps8f4kmzvm505i6bvwynfdh7v30g";
      type = "gem";
    };
    version = "0.11.3";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vywld400fzi17cszwrchrzcqys4qm6sshbv73wy5mwcixmrgg7g";
      type = "gem";
    };
    version = "4.0.5";
  };
  pusher-client = {
    dependencies = ["json" "websocket"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18ymxz34gmg7jff3h0nyzp5vdg5i06dbdxlrdl2nq4hf14qwj1f4";
      type = "gem";
    };
    version = "0.6.2";
  };
  thread_safe = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  travis = {
    dependencies = ["faraday" "faraday_middleware" "gh" "highline" "json" "launchy" "pusher-client" "typhoeus"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yizj5nqvyrfbyiv1kfwc33dylhsmk5l007z06djj152v04z63i3";
      type = "gem";
    };
    version = "1.9.1";
  };
  typhoeus = {
    dependencies = ["ethon"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03x3fxjsnhgayl4s96h0a9975awlvx2v9nmx2ba0cnliglyczdr8";
      type = "gem";
    };
    version = "0.8.0";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i3jh086w1kbdj3k5l60lc3nwbanmzdf8yjj3mlrx9b2gjjxhi9r";
      type = "gem";
    };
    version = "1.2.7";
  };
  websocket = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f11rcn4qgffb1rq4kjfwi7di79w8840x9l74pkyif5arp0mb08x";
      type = "gem";
    };
    version = "1.2.8";
  };
}
