{
  asetus = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zkr8cbp8klanqmhzz7qmimzlxh6zmsy98zb3s75af34l7znq790";
      type = "gem";
    };
    version = "0.3.0";
  };
  backports = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hshjxww2h7s0dk57njrygq4zpp0nlqrjfya7zwm27iq3rhc3y8g";
      type = "gem";
    };
    version = "3.11.4";
  };
  charlock_holmes = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nf1l31n10yaark2rrg5qzyzcx9w80681449s3j09qmnipsl8rl5";
      type = "gem";
    };
    version = "0.7.6";
  };
  emk-sinatra-url-for = {
    dependencies = ["sinatra"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rd5b1lraklv0hblzdnmw2z3dragfg0qqk7wxbpn58f8y7jxzjgj";
      type = "gem";
    };
    version = "0.2.1";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jpm2dis1j7zvvy3lg7axz9jml316zrn7s0j59vyq3qr127z0m7q";
      type = "gem";
    };
    version = "1.9.25";
  };
  haml = {
    dependencies = ["temple" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q0a9fvqh8kn6wm97fcks6qzbjd400bv8bx748w8v87m7p4klhac";
      type = "gem";
    };
    version = "5.0.4";
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
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  net-ssh = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "013p5jb4wy0cq7x7036piw2a3s1i9p752ki1srx2m289mpz4ml3q";
      type = "gem";
    };
    version = "4.1.0";
  };
  net-telnet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13qxznpwmc3hs51b76wqx2w29r158gzzh8719kv2gpi56844c8fx";
      type = "gem";
    };
    version = "0.1.1";
  };
  oxidized = {
    dependencies = ["asetus" "net-ssh" "net-telnet" "rugged" "slop"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i8lbzjay60jpk6g86rpk59j4r0kyd1nnm79qdh64qvx6hy02ylq";
      type = "gem";
    };
    version = "0.25.0";
  };
  oxidized-script = {
    dependencies = ["oxidized" "slop"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15cxsyaz2mwd7jj63gfv3lzyqkvb3gz29wxfy7xyjdzkc19c7vk6";
      type = "gem";
    };
    version = "0.6.0";
  };
  oxidized-web = {
    dependencies = ["charlock_holmes" "emk-sinatra-url-for" "haml" "htmlentities" "json" "oxidized" "puma" "rack-test" "sass" "sinatra" "sinatra-contrib"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12ib7380sh9ca7qirw1yhs8di2vv38l09imqaamibdzgmk0rvs1r";
      type = "gem";
    };
    version = "0.12.0";
  };
  puma = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06qiqx1pcfwq4gi9pdrrq8r6hgh3rwl7nl51r67zpm5xmqlp0g10";
      type = "gem";
    };
    version = "3.11.4";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9926ln2lw12lfxm4ylq1h6nl0rafl10za3xvjzc87qvnqic87f";
      type = "gem";
    };
    version = "1.6.11";
  };
  rack-protection = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0my0wlw4a5l3hs79jkx2xzv7djhajgf8d28k8ai1ddlnxxb0v7ss";
      type = "gem";
    };
    version = "1.5.5";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f50ljlbg38g21q242him0n12r0fz7r3rs9n6p8ppahzh7k22x11";
      type = "gem";
    };
    version = "0.7.0";
  };
  rb-fsevent = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lm1k7wpz69jx7jrc92w3ggczkjyjbfziq5mg62vjnxmzs383xx8";
      type = "gem";
    };
    version = "0.10.3";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fs7hxm9g6ywv2yih83b879klhc4fs8i0p9166z795qmd77dk0a4";
      type = "gem";
    };
    version = "0.10.0";
  };
  rugged = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0znb9n1grdsqf22jqzwin58kyq7x7ml57h6pf48j219f8by21sj6";
      type = "gem";
    };
    version = "0.27.7";
  };
  sass = {
    dependencies = ["sass-listen"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1phs6hnd8b95m7n5wbh5bsclmwaajd1sqlgw9fmj72bfqldbmcqa";
      type = "gem";
    };
    version = "3.7.2";
  };
  sass-listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";
      type = "gem";
    };
    version = "4.0.0";
  };
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byxzl7rx3ki0xd7aiv1x8mbah7hzd8f81l65nq8857kmgzj1jqq";
      type = "gem";
    };
    version = "1.4.8";
  };
  sinatra-contrib = {
    dependencies = ["backports" "multi_json" "rack-protection" "rack-test" "sinatra" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vi3i0icbi2figiayxpvxbqpbn1syma7w4p4zw5mav1ln4c7jnfr";
      type = "gem";
    };
    version = "1.4.7";
  };
  slop = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
      type = "gem";
    };
    version = "3.6.0";
  };
  temple = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00nxf610nzi4n1i2lkby43nrnarvl89fcl6lg19406msr0k3ycmq";
      type = "gem";
    };
    version = "0.8.0";
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ca4k0clwf0rkvy7726x4nxpjxkpv67w043i39saxgldxd97zmwz";
      type = "gem";
    };
    version = "2.0.9";
  };
}