{
  erubis = {
    source = {
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jpm2dis1j7zvvy3lg7axz9jml316zrn7s0j59vyq3qr127z0m7q";
      type = "gem";
    };
    version = "1.9.25";
  };
  multi_json = {
    source = {
      sha256 = "0q2zjfvd2ibds9g9nzf2p1b47fc1wqliwfywv5pw85w15lmy91yr";
      type = "gem";
    };
    version = "1.3.6";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0in0amn0kwvzmi8h5zg6ijrx5wpsf8h96zrfmnk1kwh2ql4sxs2q";
      type = "gem";
    };
    version = "1.6.10";
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
  rb-fsevent = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lm1k7wpz69jx7jrc92w3ggczkjyjbfziq5mg62vjnxmzs383xx8";
      type = "gem";
    };
    version = "0.10.3";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yfsgw5n7pkpyky6a9wkf1g9jafxb0ja7gz0qw0y14fd2jnzfh71";
      type = "gem";
    };
    version = "0.9.10";
  };
  riemann-dash = {
    dependencies = ["erubis" "multi_json" "sass" "sinatra" "webrick"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h366knb1vx5l4a46ppfr2sb467bb4m448fh8q2al0ixw7wqncvr";
      type = "gem";
    };
    version = "0.2.14";
  };
  sass = {
    dependencies = ["sass-listen"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18c6prbw9wl8bqhb2435pd9s0lzarl3g7xf8pmyla28zblvwxmyh";
      type = "gem";
    };
    version = "3.6.0";
  };
  sass-listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";
      type = "gem";
    };
    version = "4.0.0";
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
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0020mrgdf11q23hm1ddd6fv691l51vi10af00f137ilcdb2ycfra";
      type = "gem";
    };
    version = "2.0.8";
  };
  webrick = {
    source = {
      sha256 = "0s42mxihcl2bx0h9q0v2syl70qndydfkl39a06h9il17p895ya8g";
      type = "gem";
    };
    version = "1.3.1";
  };
}