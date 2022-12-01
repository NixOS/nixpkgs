{
  async = {
    dependencies = ["console" "nio4r" "timers"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13l94x31wvamjdvyy5f8rv60vgw4ygwik2z0hazbdisw4p8qzcis";
      type = "gem";
    };
    version = "1.30.3";
  };
  async-container = {
    dependencies = ["async" "async-io"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1llhbwffmha2n7kx8v5yz048ipknyvzkwiicpmfq0m0h95xgnv20";
      type = "gem";
    };
    version = "0.16.12";
  };
  async-http = {
    dependencies = ["async" "async-io" "async-pool" "protocol-http" "protocol-http1" "protocol-http2" "traces"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q0bn63xnhsch21kdq5wr4kpaw579isap7mdf6l0xn9f7x75x3w7";
      type = "gem";
    };
    version = "0.56.6";
  };
  async-http-cache = {
    dependencies = ["async-http"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05awbimxiw0hdixw5ww1vdml2lwzn4hk00vwznsz3fpg150nfhvk";
      type = "gem";
    };
    version = "0.4.3";
  };
  async-io = {
    dependencies = ["async"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10l9m0x2ffvsaaxc4mfalrljjx13njkyir9w6yfif8wpszc291h8";
      type = "gem";
    };
    version = "1.32.2";
  };
  async-pool = {
    dependencies = ["async"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1chrj28qgv7jxq1yf9g4bw8ppm3n6i4sfsbs2ficc8z8w22k8a2y";
      type = "gem";
    };
    version = "0.3.12";
  };
  async-websocket = {
    dependencies = ["async-http" "async-io" "protocol-websocket"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mag69gqfw9jv67ly2bdsaczzwvlikiaz61vabbn5s937yzb6v99";
      type = "gem";
    };
    version = "0.19.2";
  };
  build-environment = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rbg948vvvnq7v3213i7s2i8nfhljp1ih15kzy1lgi733iqplwnb";
      type = "gem";
    };
    version = "1.13.0";
  };
  console = {
    dependencies = ["fiber-local"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y1bv3kd1l9p0k5n3anvvjxdrcq113pyngz2g29i9mvdgbbx7kq2";
      type = "gem";
    };
    version = "1.16.2";
  };
  falcon = {
    dependencies = ["async" "async-container" "async-http" "async-http-cache" "async-io" "build-environment" "localhost" "process-metrics" "rack" "samovar"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01xq3m7v8rymc8pl1khywf2m5qxzgb90wc9d2pcigapbgg3dn15p";
      type = "gem";
    };
    version = "0.39.2";
  };
  fiber-local = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vrxxb09fc7aicb9zb0pmn5akggjy21dmxkdl3w949y4q05rldr9";
      type = "gem";
    };
    version = "1.0.0";
  };
  localhost = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1prbdrvw628awzvkpxbx37rkq11jyyfd3f09hzg5gnaxqjxk2q6x";
      type = "gem";
    };
    version = "1.1.9";
  };
  mail = {
    dependencies = ["mini_mime"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00wwz6ys0502dpk8xprwcqfwyf3hmnx6lgxaiq6vj43mkx43sapc";
      type = "gem";
    };
    version = "2.7.1";
  };
  mailcatcher = {
    dependencies = ["async" "async-http" "async-io" "async-websocket" "falcon" "mail" "rack" "sinatra" "sqlite3"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "6815f296fda555e5263720e41469c4637a872220";
      sha256 = "136fa9y46f76clf09275hdri9yq59fg4xr4193v2lspflhjaj9np";
      type = "git";
      url = "https://github.com/Ahmedgagan/mailcatcher.git";
    };
    version = "1.0.0.beta1";
  };
  mapping = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fgj59zq1a2vskm9m5kfgmxq325ds4046hy8zbxyl3wn8fiw6xy6";
      type = "gem";
    };
    version = "1.1.1";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lbim375gw2dk6383qirz13hgdmxlan0vc5da2l072j3qw6fqjm5";
      type = "gem";
    };
    version = "1.1.2";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rapl1sfmfi3bfr68da4ca16yhc0pp93vjwkj7y3rdqrzy3b41hy";
      type = "gem";
    };
    version = "2.8.0";
  };
  nio4r = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xk64wghkscs6bv2n22853k2nh39d131c6rfpnlw12mbjnnv9v1v";
      type = "gem";
    };
    version = "2.5.8";
  };
  process-metrics = {
    dependencies = ["console" "samovar"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k46lhfllkxcbnccjsbz0vwrj7iwrrmwil9hmj6ds7ysicid824x";
      type = "gem";
    };
    version = "0.2.1";
  };
  protocol-hpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sd85am1hj2w7z5hv19wy1nbisxfr1vqx3wlxjfz9xy7x7s6aczw";
      type = "gem";
    };
    version = "1.4.2";
  };
  protocol-http = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yl53pn916fl3c1f63zr5d2l3jf08bdacphrh2s49ni6bpwjn2vf";
      type = "gem";
    };
    version = "0.22.9";
  };
  protocol-http1 = {
    dependencies = ["protocol-http"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "001myk5sgiygpc39aj0fxk1g7cxh2l102if8hg4mszhqdvdkzg4b";
      type = "gem";
    };
    version = "0.14.6";
  };
  protocol-http2 = {
    dependencies = ["protocol-hpack" "protocol-http"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a9klpfmi7w465zq5xz8y8h1qvj42hkm0qd0nlws9d2idd767q5j";
      type = "gem";
    };
    version = "0.14.2";
  };
  protocol-websocket = {
    dependencies = ["protocol-http" "protocol-http1"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iv5cwsmrihqh9bin6myx15l1va81z3p4jw6zm3sk7zi3hlja9ly";
      type = "gem";
    };
    version = "0.7.5";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wr1f3g9rc9i8svfxa9cijajl1661d817s56b2w7rd572zwn0zi0";
      type = "gem";
    };
    version = "1.6.13";
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
  samovar = {
    dependencies = ["console" "mapping"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wl16hvqz5w7997g4qymjz4ls63bl59isr7n0gwhb9gyi85f24jx";
      type = "gem";
    };
    version = "2.1.4";
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
  sqlite3 = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "009124l2yw7csrq3mvzffjflgpqi3y30flazjqf6aad64gnnnksx";
      type = "gem";
    };
    version = "1.5.4";
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "186nfbcsk0l4l86gvng1fw6jq6p6s7rc0caxr23b3pnbfb20y63v";
      type = "gem";
    };
    version = "2.0.11";
  };
  timers = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pjzipnmzfywvgsr3gxwj6nmg47lz4700g0q71jgcy1z6rb7dn7p";
      type = "gem";
    };
    version = "4.3.5";
  };
  traces = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ccy1snkgf0n1sq8j1gkd45isvfhzizzfrj8gj8qir50a80xmk21";
      type = "gem";
    };
    version = "0.4.1";
  };
}
