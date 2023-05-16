{
  activesupport = {
<<<<<<< HEAD
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
=======
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1c7k5i6531z5il4q1jnbrv7x7zcl3bgnxp5fzl71rzigk6zn53ym";
      type = "gem";
    };
    version = "7.0.5";
=======
      sha256 = "1md98dkbirc8mq5nbz1vqq3hwqjiv7b54q7180w8wyxgd4k1awwb";
      type = "gem";
    };
    version = "6.0.2.2";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      type = "gem";
    };
    version = "1.2.2";
=======
      sha256 = "094387x4yasb797mv07cs3g6f08y56virc2rjcpb1k79rzaj3nhl";
      type = "gem";
    };
    version = "1.1.6";
  };
  cookiejar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q0kmbks9l3hl0wdq744hzy97ssq9dvlzywyqv9k9y1p3qc9va2a";
      type = "gem";
    };
    version = "0.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  curses = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "00y9g79lzfffxarj3rmhnkblsnyx7izx91mh8c1sdcs9y2pdfq53";
      type = "gem";
    };
    version = "1.4.4";
=======
      sha256 = "0hic9kq09dhh8jqjx3k1991rnqhlj3glz82w0g7ndcri52m1hgqg";
      type = "gem";
    };
    version = "1.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
  em-http-request = {
    dependencies = ["addressable" "cookiejar" "em-socksify" "eventmachine" "http_parser.rb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13rxmbi0fv91n4sg300v3i9iiwd0jxv0i6xd0sp81dx3jlx7kasx";
      type = "gem";
    };
    version = "1.1.5";
  };
  em-socksify = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rk43ywaanfrd8180d98287xv2pxyl7llj291cwy87g1s735d5nk";
      type = "gem";
    };
    version = "0.3.2";
  };
  eventmachine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17jr1caa3ggg696dd02g2zqzdjqj9x9q2nl7va82l36f7c5v6k4z";
      type = "gem";
    };
    version = "1.0.9.1";
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  haveapi-client = {
    dependencies = ["activesupport" "highline" "json" "require_all" "rest-client" "ruby-progressbar"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0iz0k9cwva8icc040k5m9ah0cz08jg6x51h6ahdccw6azy8h93i1";
      type = "gem";
    };
    version = "0.16.3";
=======
      sha256 = "1wn5zvyy3w3q74m2fsb4jwxfdbdnpyyzxdf9iklpggcdmjhb78z0";
      type = "gem";
    };
    version = "0.13.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  highline = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0yclf57n2j3cw8144ania99h1zinf8q3f5zrhqa754j6gl95rp9d";
      type = "gem";
    };
    version = "2.0.3";
  };
  http-accept = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09m1facypsdjynfwrcv19xcb1mqg8z6kk31g8r33pfxzh838c9n6";
      type = "gem";
    };
    version = "1.7.0";
=======
      sha256 = "01ib7jp85xjc4gh4jg0wyzllm46hwv8p0w1m4c75pbgi41fps50y";
      type = "gem";
    };
    version = "1.7.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  http-cookie = {
    dependencies = ["domain_name"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "13rilvlv8kwbzqfb644qp6hrbsj82cbqmnzcvqip1p6vqx36sxbk";
      type = "gem";
    };
    version = "1.0.5";
=======
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
      type = "gem";
    };
    version = "1.0.3";
  };
  "http_parser.rb" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
      type = "gem";
    };
    version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0qaamqsh5f3szhcakkak8ikxlzxqnv49n2p7504hcz2l0f4nj0wx";
      type = "gem";
    };
    version = "1.14.1";
=======
      sha256 = "0jwrd1l4mxz06iyx6053lr6hz2zy7ah2k3ranfzisvych5q19kwm";
      type = "gem";
    };
    version = "1.8.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0nalhin1gda4v8ybk6lq8f407cgfrj6qzn234yra4ipkmlbfmal6";
      type = "gem";
    };
    version = "2.6.3";
=======
      sha256 = "0nrmw2r4nfxlfgprfgki3hjifgrcrs3l5zvm3ca3gb4743yr25mn";
      type = "gem";
    };
    version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0ipw892jbksbxxcrlx9g5ljq60qx47pm24ywgfbyjskbcl78pkvb";
      type = "gem";
    };
    version = "3.4.1";
=======
      sha256 = "1zj12l9qk62anvk9bjvandpa6vy4xslil15wl6wlivyf51z773vh";
      type = "gem";
    };
    version = "3.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1pky3vzaxlgm9gw5wlqwwi7wsw3jrglrfflrppvvnsrlaiz043z9";
      type = "gem";
    };
    version = "3.2023.0218.1";
=======
      sha256 = "1zin0q26wc5p7zb7glpwary7ms60s676vcq987yv22jgm6hnlwlh";
      type = "gem";
    };
    version = "3.2020.0425";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  minitest = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0ic7i5z88zcaqnpzprf7saimq2f6sad57g5mkkqsrqrcd6h3mx06";
      type = "gem";
    };
    version = "5.18.0";
=======
      sha256 = "0g73x65hmjph8dg1h3rkzfg7ys3ffxm35hj35grw75fixmq53qyz";
      type = "gem";
    };
    version = "5.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  netrc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
<<<<<<< HEAD
=======
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l1kqw75asziwmzrig8rywxswxz8l91sc3pvns02ffsqac1a3wiz";
      type = "gem";
    };
    version = "4.0.4";
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  require_all = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sjf2vigdg4wq7z0xlw14zyhcz4992s05wgr2s58kjgin12bkmv8";
      type = "gem";
    };
    version = "2.0.0";
  };
  rest-client = {
<<<<<<< HEAD
    dependencies = ["http-accept" "http-cookie" "mime-types" "netrc"];
=======
    dependencies = ["http-cookie" "mime-types" "netrc"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1qs74yzl58agzx9dgjhcpgmzfn61fqkk33k1js2y5yhlvc5l19im";
      type = "gem";
    };
    version = "2.1.0";
=======
      sha256 = "1hzcs2r7b5bjkf2x2z3n8z6082maz0j8vqjiciwgg3hzb63f958j";
      type = "gem";
    };
    version = "2.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  ruby-progressbar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "02nmaw7yx9kl7rbaan5pl8x5nn0y4j5954mzrkzi9i3dhsrps4nc";
      type = "gem";
    };
    version = "1.11.0";
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
=======
      sha256 = "0hynaavnqzld17qdx9r7hfw00y16ybldwq730zrqfszjwgi59ivi";
      type = "gem";
    };
    version = "1.7.5";
  };
  thread_safe = {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
=======
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      sha256 = "1yj2nz2l101vr1x9w2k83a0fag1xgnmjwp8w8rw4ik2rwcz65fch";
      type = "gem";
    };
    version = "0.0.8.2";
  };
  vpsadmin-client = {
    dependencies = ["curses" "haveapi-client" "json"];
=======
      sha256 = "0wc47r23h063l8ysws8sy24gzh74mks81cak3lkzlrw4qkqb3sg4";
      type = "gem";
    };
    version = "0.0.7.7";
  };
  vpsadmin-client = {
    dependencies = ["curses" "em-http-request" "eventmachine" "haveapi-client" "json"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1rqxvfmcbpi8wcmgwdl34il3a4gg3q3zy8pyyj0kk0v8lly0wb6d";
      type = "gem";
    };
    version = "3.0.0.master.20221118.pre.1.ac358990";
=======
      sha256 = "0ki3204pkg3f9wk9plbq5n9lrnsmc364smfxyrbq32gi8ag2y2s8";
      type = "gem";
    };
    version = "3.0.0.master.20190517.pre.0.3ab5ddfe";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  vpsfree-client = {
    dependencies = ["vpsadmin-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0a4fmimzrysjcnvw2jz7f5hdslmy2aaipcgiisjkhqazw6nlbd8w";
      type = "gem";
    };
    version = "0.17.1";
=======
      sha256 = "0cs2ibl9kl39hnpzyhyczaqv4i58pn106vx2m6lds9p3av5mcbxs";
      type = "gem";
    };
    version = "0.11.0";
  };
  zeitwerk = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1akpm3pwvyiack2zk6giv9yn3cqb8pw6g40p4394pdc3xmy3s4k0";
      type = "gem";
    };
    version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
