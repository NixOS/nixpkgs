{
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
  };
  atomos = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17vq6sjyswr5jfzwdccw748kgph6bdw30bakwnn6p8sl4hpv4hvx";
      type = "gem";
    };
    version = "0.1.3";
  };
  babosa = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05rgxg4pz4bc4xk34w5grv0yp1j94wf571w84lf3xgqcbs42ip2f";
      type = "gem";
    };
    version = "1.0.2";
  };
  CFPropertyList = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ykjag3k5msz3sf1j91rb55da2xh596y06m3a4yl79fiy2id0w9z";
      type = "gem";
    };
    version = "3.0.0";
  };
  claide = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0az54rp691hc42yl1xyix2cxv58byhaaf4gxbpghvvq29l476rzc";
      type = "gem";
    };
    version = "1.0.2";
  };
  colored = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0x5jmsyi0z69bm6sij1k89z7h0laag3cb4mdn7zkl9qmxb90lx";
      type = "gem";
    };
    version = "1.2";
  };
  colored2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jlbqa9q4mvrm73aw9mxh23ygzbjiqwisl32d8szfb5fxvbjng5i";
      type = "gem";
    };
    version = "3.1.2";
  };
  commander-fastlane = {
    dependencies = ["highline"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y8d3ac9qwm1cg6rnpf8rcdsy1yxacrd2g2kl809xsp2vi973g65";
      type = "gem";
    };
    version = "4.4.6";
  };
  declarative = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0642xvwzzbgi3kp1bg467wma4g3xqrrn0sk369hjam7w579gnv5j";
      type = "gem";
    };
    version = "0.0.10";
  };
  declarative-option = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g4ibxq566f1frnhdymzi9hxxcm4g2gw4n21mpjk2mhwym4q6l0p";
      type = "gem";
    };
    version = "0.1.0";
  };
  domain_name = {
    dependencies = ["unf"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0abdlwb64ns7ssmiqhdwgl27ly40x2l27l8hs8hn0z4kb3zd2x3v";
      type = "gem";
    };
    version = "0.5.20180417";
  };
  dotenv = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1va5y19f7l5jh53vz5vibz618lg8z93k5m2k70l25s9k46v2gfm3";
      type = "gem";
    };
    version = "2.5.0";
  };
  emoji_regex = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pcw3axgcmsgihp0xlsdqrqmavz0lw8g396b048fg21033kssxjn";
      type = "gem";
    };
    version = "0.1.1";
  };
  excon = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15l9w0938c19nxmrp09n75qpmm64k12xj69h47yvxzcxcpbgnkb2";
      type = "gem";
    };
    version = "0.62.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16hwxc8v0z6gkanckjhx0ffgqmzpc4ywz4dfhxpjlz2mbz8d5m52";
      type = "gem";
    };
    version = "0.15.3";
  };
  faraday-cookie_jar = {
    dependencies = ["faraday" "http-cookie"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1di4gx6446a6zdkrpj679m5k515i53wvb4yxcsqvy8d8zacxiiv6";
      type = "gem";
    };
    version = "0.0.6";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p7icfl28nvl8qqdsngryz1snqic9l8x6bk0dxd7ygn230y0k41d";
      type = "gem";
    };
    version = "0.12.2";
  };
  fastimage = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i7p9jgb9x1lxkhkwq8xlq7an5qbgdq6gsyrbs2xnf5ffa8yx1i2";
      type = "gem";
    };
    version = "2.1.4";
  };
  fastlane = {
    dependencies = ["CFPropertyList" "addressable" "babosa" "colored" "commander-fastlane" "dotenv" "emoji_regex" "excon" "faraday" "faraday-cookie_jar" "faraday_middleware" "fastimage" "gh_inspector" "google-api-client" "highline" "json" "mini_magick" "multi_json" "multi_xml" "multipart-post" "plist" "public_suffix" "rubyzip" "security" "simctl" "slack-notifier" "terminal-notifier" "terminal-table" "tty-screen" "tty-spinner" "word_wrap" "xcodeproj" "xcpretty" "xcpretty-travis-formatter"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d3jv7ik3rivmhxzcapia2lzf9xjmjgi4yxkl60ly6pcbbvhl48w";
      type = "gem";
    };
    version = "2.107.0";
  };
  gh_inspector = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f8r9byajj3bi2c7c5sqrc7m0zrv3nblfcd4782lw5l73cbsgk04";
      type = "gem";
    };
    version = "1.1.3";
  };
  google-api-client = {
    dependencies = ["addressable" "googleauth" "httpclient" "mime-types" "representable" "retriable" "signet"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z925kbqyaxdi6ld3gvaqc9527xfi8k3rr6snq5mvx5kibdi072a";
      type = "gem";
    };
    version = "0.23.9";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "memoist" "multi_json" "os" "signet"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yj7j1rnyamxpn5ybgdgbiw89v9bq2r0h85s2y2jzvqanvm7iflq";
      type = "gem";
    };
    version = "0.6.7";
  };
  highline = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ib7jp85xjc4gh4jg0wyzllm46hwv8p0w1m4c75pbgi41fps50y";
      type = "gem";
    };
    version = "1.7.10";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
      type = "gem";
    };
    version = "1.0.3";
  };
  httpclient = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  jwt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w0kaqrbl71cq9sbnixc20x5lqah3hs2i93xmhlfdg2y3by7yzky";
      type = "gem";
    };
    version = "2.1.0";
  };
  memoist = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pq8fhqh8w25qcw9v3vzfb0i6jp0k3949ahxc3wrwz2791dpbgbh";
      type = "gem";
    };
    version = "0.16.0";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fjxy1jm52ixpnv3vg9ld9pr9f35gy0jp66i1njhqjvmnvq0iwwk";
      type = "gem";
    };
    version = "3.2.2";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07wvp0aw2gjm4njibb70as6rh5hi1zzri5vky1q6jx95h8l56idc";
      type = "gem";
    };
    version = "3.2018.0812";
  };
  mini_magick = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a59k5l29vj060yscaqk370rg5vyr132kbw6x3zar7khzjqjqd8p";
      type = "gem";
    };
    version = "4.5.1";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  multi_xml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lmd4f401mvravi1i1yq7b2qjjli0yq7dfc4p1nj5nwajp7r6hyj";
      type = "gem";
    };
    version = "0.6.0";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  nanaimo = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ajfyaqjw3dzykk612yw8sm21savfqy292hgps8h8l4lvxww1lz6";
      type = "gem";
    };
    version = "0.2.6";
  };
  naturally = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dzqdawqr4agx7zr1fr5zxdwl8vb5rhpz57l1lk7d2y46ha6l4l7";
      type = "gem";
    };
    version = "2.2.0";
  };
  os = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s401gvhqgs2r8hh43ia205mxsy1wc0ib4k76wzkdpspfcnfr1rk";
      type = "gem";
    };
    version = "1.0.0";
  };
  plist = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f27kj49v76psqxgcwvwc63cf7va2bszmmw2qrrd281qzi2if79l";
      type = "gem";
    };
    version = "3.4.0";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "040jf98jpp6w140ghkhw2hvc1qx41zvywx5gj7r2ylr1148qnj7q";
      type = "gem";
    };
    version = "2.0.5";
  };
  representable = {
    dependencies = ["declarative" "declarative-option" "uber"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qm9rgi1j5a6nv726ka4mmixivlxfsg91h8rpp72wwd4vqbkkm07";
      type = "gem";
    };
    version = "3.0.4";
  };
  retriable = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q48hqws2dy1vws9schc0kmina40gy7sn5qsndpsfqdslh65snha";
      type = "gem";
    };
    version = "3.1.2";
  };
  rouge = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sfikq1q8xyqqx690iiz7ybhzx87am4w50w8f2nq36l3asw4x89d";
      type = "gem";
    };
    version = "2.0.7";
  };
  rubyzip = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n1lb2sdwh9h27y244hxzg1lrxxg2m53pk1vq7p33bna003qkyrj";
      type = "gem";
    };
    version = "1.2.2";
  };
  security = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ryjxs0j66wrbky2c08yf0mllwalvpg12rpxzbdx2rdhj3cbrlxa";
      type = "gem";
    };
    version = "0.1.3";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f5d3bz5bjc4b0r2jmqd15qf07lgsqkgd25f0h46jihrf9l5fsi4";
      type = "gem";
    };
    version = "0.11.0";
  };
  simctl = {
    dependencies = ["CFPropertyList" "naturally"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bbvbpdk955q1g797md960fdznw6p6hmj2pc62yrbpvb1ymag1sf";
      type = "gem";
    };
    version = "1.6.5";
  };
  slack-notifier = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pkfn99dhy5s526r6k8d87fwwb6j287ga9s7lxqmh60z28xqh3bv";
      type = "gem";
    };
    version = "2.3.2";
  };
  terminal-notifier = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vy75sbq236v1p83jj6r3a9d52za5lqj2vj24np9lrszdczm9zcb";
      type = "gem";
    };
    version = "1.8.0";
  };
  terminal-table = {
    dependencies = ["unicode-display_width"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1512cngw35hsmhvw4c05rscihc59mnj09m249sm9p3pik831ydqk";
      type = "gem";
    };
    version = "1.8.0";
  };
  tty-cursor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f4rsapf4apaxn11xnqrq7axgrlvn6pdlqxqb2g34jnpfh5yrk1i";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-screen = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0azpjgyhdm8ycblnx9crq3dgb2x8yg454a13n60zfpsc0n138sw1";
      type = "gem";
    };
    version = "0.6.5";
  };
  tty-spinner = {
    dependencies = ["tty-cursor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xv5bycgmiyx00bq0kx2bdixi3h1ffi86mwj858gqbxlpjbzsi94";
      type = "gem";
    };
    version = "0.8.0";
  };
  uber = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1mm7mngg40x05z52md3mbamkng0zpajbzqjjwmsyw0zw3v9vjv";
      type = "gem";
    };
    version = "0.1.0";
  };
  unf = {
    dependencies = ["unf_ext"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06p1i6qhy34bpb8q8ms88y6f2kz86azwm098yvcc0nyqk9y729j1";
      type = "gem";
    };
    version = "0.0.7.5";
  };
  unicode-display_width = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0040bsdpcmvp8w31lqi2s9s4p4h031zv52401qidmh25cgyh4a57";
      type = "gem";
    };
    version = "1.4.0";
  };
  word_wrap = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iyc5bc7dbgsd8j3yk1i99ral39f23l6wapi0083fbl19hid8mpm";
      type = "gem";
    };
    version = "1.0.0";
  };
  xcodeproj = {
    dependencies = ["CFPropertyList" "atomos" "claide" "colored2" "nanaimo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hy2ihcqfjlsrnf8qkm51m1kk154yp0l0007f269ky8j9z5lyw3p";
      type = "gem";
    };
    version = "1.7.0";
  };
  xcpretty = {
    dependencies = ["rouge"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xq47q2h5llj7b54rws4796904vnnjz7qqnacdv7wlp3gdbwrivm";
      type = "gem";
    };
    version = "0.3.0";
  };
  xcpretty-travis-formatter = {
    dependencies = ["xcpretty"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15b5c0lxz2blmichfdlabzlbyw5nlh1ci898pxwb661m9bahz3ml";
      type = "gem";
    };
    version = "1.0.0";
  };
}