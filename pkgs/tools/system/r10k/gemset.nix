{
  colored = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0x5jmsyi0z69bm6sij1k89z7h0laag3cb4mdn7zkl9qmxb90lx";
      type = "gem";
    };
    version = "1.2";
  };
  cri = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z1z1aj7a3gf16wv31kc0mr45snlxrjavcj762rx791ymalmxkbr";
      type = "gem";
    };
    version = "2.15.5";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gyqsj7vlqynwvivf9485zwmcj04v1z7gq362z0b8zw2zf4ag0hw";
      type = "gem";
    };
    version = "0.13.1";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p7icfl28nvl8qqdsngryz1snqic9l8x6bk0dxd7ygn230y0k41d";
      type = "gem";
    };
    version = "0.12.2";
  };
  fast_gettext = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ci71w9jb979c379c7vzm88nc3k6lf68kbrsgw9nlx5g4hng0s78";
      type = "gem";
    };
    version = "1.1.2";
  };
  gettext = {
    dependencies = ["locale" "text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0764vj7gacn0aypm2bf6m46dzjzwzrjlmbyx6qwwwzbmi94r40wr";
      type = "gem";
    };
    version = "3.2.9";
  };
  gettext-setup = {
    dependencies = ["fast_gettext" "gettext" "locale"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04c243gwwlnh4m8rn1zx0w8mzhixjf9fvpfb65xcmgs5a19146j4";
      type = "gem";
    };
    version = "0.30";
  };
  locale = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sls9bq4krx0fmnzmlbn64dw23c4d6pz46ynjzrn9k8zyassdd0x";
      type = "gem";
    };
    version = "2.1.2";
  };
  log4r = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ri90q0frfmigkirqv5ihyrj59xm8pq5zcmf156cbdv4r4l2jicv";
      type = "gem";
    };
    version = "1.1.10";
  };
  minitar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dfw1q83h6jxrmivd3fsg0dsbkdhv63qns0jc1a6kf1vmhd6ihwd";
      type = "gem";
    };
    version = "0.8";
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
  multipart-post = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  puppet_forge = {
    dependencies = ["faraday" "faraday_middleware" "gettext-setup" "minitar" "semantic_puppet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00qma88kwg2f4nh5yid9w4pqfdbwlh8bz2mmgiiwji38s0pdahba";
      type = "gem";
    };
    version = "2.2.9";
  };
  r10k = {
    dependencies = ["colored" "cri" "gettext-setup" "log4r" "multi_json" "puppet_forge"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yjvklvdvx0wjgg6bhhaszdsk62cysjviwj0536z7ng25q3ci5kj";
      type = "gem";
    };
    version = "3.2.0";
  };
  semantic_puppet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "046m45rdwpvfz77s7bxid27c89w329c1nj593p74wdd8kknf0nv0";
      type = "gem";
    };
    version = "1.0.2";
  };
  text = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x6kkmsr49y3rnrin91rv8mpc3dhrf3ql08kbccw8yffq61brfrg";
      type = "gem";
    };
    version = "1.3.1";
  };
}