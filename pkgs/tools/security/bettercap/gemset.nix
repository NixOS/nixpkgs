{
  bettercap = {
    dependencies = ["colorize" "em-proxy" "net-dns" "network_interface" "packetfu" "pcaprub" "rubydns"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mns96yfyfnksk720p8k83qkwwsid4sicwgrzxaa9gbc53aalll0";
      type = "gem";
    };
    version = "1.6.2";
  };
  celluloid = {
    dependencies = ["timers"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "044xk0y7i1xjafzv7blzj5r56s7zr8nzb619arkrl390mf19jxv3";
      type = "gem";
    };
    version = "0.16.0";
  };
  celluloid-io = {
    dependencies = ["celluloid" "nio4r"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l1x0p6daa5vskywrvaxdlanwib3k5pps16axwyy4p8d49pn9rnx";
      type = "gem";
    };
    version = "0.16.2";
  };
  colorize = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "133rqj85n400qk6g3dhf2bmfws34mak1wqihvh3bgy9jhajw580b";
      type = "gem";
    };
    version = "0.8.1";
  };
  em-proxy = {
    dependencies = ["eventmachine"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yzkg6jkmcg859b5mf13igpf8q2bjhsmqjsva05948fi733w5n2j";
      type = "gem";
    };
    version = "0.1.9";
  };
  eventmachine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "075hdw0fgzldgss3xaqm2dk545736khcvv1fmzbf1sgdlkyh1v8z";
      type = "gem";
    };
    version = "1.2.5";
  };
  hitimes = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06222h9236jw9jgmdlpi0q7psac1shvxqxqx905qkvabmxdxlfar";
      type = "gem";
    };
    version = "1.2.6";
  };
  net-dns = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12nal6vhdyg0pbcqpsxqr59h7mbgdhcqp3v0xnzvy167n40gabf9";
      type = "gem";
    };
    version = "0.8.0";
  };
  network_interface = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xh4knfq77ii4pjzsd2z1p3nd6nrcdjhb2vi5gw36jqj43ffw0zp";
      type = "gem";
    };
    version = "0.0.2";
  };
  nio4r = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jjrj7vs29w6dfgsxq08226jfbi2j0x62lf4p9zmvyp19dj4z00a";
      type = "gem";
    };
    version = "2.2.0";
  };
  packetfu = {
    dependencies = ["pcaprub"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16ppq9wfxq4x2hss61l5brs3s6fmi8gb50mnp1nnnzb1asq4g8ll";
      type = "gem";
    };
    version = "1.1.13";
  };
  pcaprub = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pl4lqy7308185pfv0197n8b4v20fhd0zb3wlpz284rk8ssclkvz";
      type = "gem";
    };
    version = "0.12.4";
  };
  rubydns = {
    dependencies = ["celluloid" "celluloid-io" "timers"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cvj8li8shz7zn1rc5hdrkqmvr9j187g4y28mvkfvmv1j9hdln62";
      type = "gem";
    };
    version = "1.0.3";
  };
  timers = {
    dependencies = ["hitimes"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jx4wb0x182gmbcs90vz0wzfyp8afi1mpl9w5ippfncyk4kffvrz";
      type = "gem";
    };
    version = "4.0.4";
  };
}