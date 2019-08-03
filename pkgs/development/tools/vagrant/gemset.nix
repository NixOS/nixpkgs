{
  bcrypt_pbkdf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02vssr285m7kpsr47jdmzbar1h1d0mnkmyrpr1zg828isfmwii35";
      type = "gem";
    };
    version = "1.0.1";
  };
  builder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  childprocess = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p3f43scdzx9zxmy2kw5zsc3az6v46nq4brwcxmnscjy4w4racbv";
      type = "gem";
    };
    version = "0.6.3";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x07r23s7836cpp5z9yrlbpljcxpax14yw4fy4bnp6crhr6x24an";
      type = "gem";
    };
    version = "1.1.5";
  };
  diff-lcs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
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
  ed25519 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f5kr8za7hvla38fc0n9jiv55iq62k5bzclsa5kdb14l3r4w6qnw";
      type = "gem";
    };
    version = "1.2.4";
  };
  erubis = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06mvxpjply8qh4j3fj9wh08kdzwkbnvsiysh0vrhlk5cwxzjmblh";
      type = "gem";
    };
    version = "1.11.1";
  };
  gssapi = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13l6pqbfrx3vv7cw26nq9p8rnyp9br31gaz85q32wx6hnzfcriwh";
      type = "gem";
    };
    version = "1.3.0";
  };
  gyoku = {
    dependencies = ["builder"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wn0sl14396g5lyvp8sjmcb1hw9rbyi89gxng91r7w4df4jwiidh";
      type = "gem";
    };
    version = "1.3.1";
  };
  hashicorp-checkpoint = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z6mwzvd7p2wqhmk07dwrhvm0ncgqm7pxn0pr2k025rwsspp9bsd";
      type = "gem";
    };
    version = "0.1.5";
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
  i18n = {
    dependencies = ["concurrent-ruby"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gcp1m1p6dpasycfz2sj82ci9ggz7lsskz9c9q6gvfwxrl8y9dx7";
      type = "gem";
    };
    version = "1.1.1";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify" "ruby_dep"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v5mrnfqm6sgm8xn2v5swxsn1wlmq7rzh2i48d4jzjsc7qvb6mx";
      type = "gem";
    };
    version = "3.1.5";
  };
  little-plugger = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
      type = "gem";
    };
    version = "1.1.4";
  };
  log4r = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ri90q0frfmigkirqv5ihyrj59xm8pq5zcmf156cbdv4r4l2jicv";
      type = "gem";
    };
    version = "1.1.10";
  };
  logging = {
    dependencies = ["little-plugger" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06j6iaj89h9jhkx1x3hlswqrfnqds8br05xb1qra69dpvbdmjcwn";
      type = "gem";
    };
    version = "2.2.2";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m00pg19cm47n1qlcxgl91ajh2yq0fszvn1vy8fy0s1jkrp9fw4a";
      type = "gem";
    };
    version = "3.2019.0331";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  net-scp = {
    dependencies = ["net-ssh"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0jqrcsp4bbi4n4mzyf70cp2ysyp6x07j8k8cqgxnvb4i3a134j";
      type = "gem";
    };
    version = "1.2.1";
  };
  net-sftp = {
    dependencies = ["net-ssh"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04674g4n6mryjajlcd82af8g8k95la4b1bj712dh71hw1c9vhw1y";
      type = "gem";
    };
    version = "2.1.2";
  };
  net-ssh = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jglf8rxvlw6is5019r6kwsdhw38zm3z39jbghdbj449r6h7h77n";
      type = "gem";
    };
    version = "5.1.0";
  };
  netrc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  nori = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "066wc774a2zp4vrq3k7k8p0fhv30ymqmxma1jj7yg5735zls8agn";
      type = "gem";
    };
    version = "2.6.0";
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
      sha256 = "1fs7hxm9g6ywv2yih83b879klhc4fs8i0p9166z795qmd77dk0a4";
      type = "gem";
    };
    version = "0.10.0";
  };
  rb-kqueue = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14mhzrhs2j43vj36i1qq4z29nd860shrslfik015f4kf1jiaqcrw";
      type = "gem";
    };
    version = "0.2.5";
  };
  rest-client = {
    dependencies = ["http-cookie" "mime-types" "netrc"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hzcs2r7b5bjkf2x2z3n8z6082maz0j8vqjiciwgg3hzb63f958j";
      type = "gem";
    };
    version = "2.0.2";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16g3mmih999f0b6vcz2c3qsc7ks5zy4lj1rzjh8hf6wk531nvc6s";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nacs062qbr98fx6czf1vwppn1js956nv2c8vfwj6i65axdfs46i";
      type = "gem";
    };
    version = "3.5.4";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bbqfrb1x8gmwf8x2xhhwvvlhwbbafq4isbvlibxi6jk602f09gs";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nl3ksivh9wwrjjd47z5dggrwx40v6gpb3a0gzbp1gs06a5dmk24";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-support = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10vf3k3d472y573mag2kzfsfrf6rv355s13kadnpryk8d36yq5r0";
      type = "gem";
    };
    version = "3.5.0";
  };
  ruby_dep = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v0qznxz999lx4vs76mr590r90i0cm5m76wwvgis7sq4y21l308l";
      type = "gem";
    };
    version = "1.3.1";
  };
  rubyntlm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p6bxsklkbcqni4bcq6jajc2n57g0w5rzn4r49c3lb04wz5xg0dy";
      type = "gem";
    };
    version = "0.6.2";
  };
  rubyzip = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w9gw28ly3zyqydnm8phxchf4ymyjl2r7zf7c12z8kla10cpmhlc";
      type = "gem";
    };
    version = "1.2.3";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d1g37j6sc7fkidf8rqlm3wh9zgyg3g7y8h2x1y34hmil5ywa8c3";
      type = "gem";
    };
    version = "0.18.1";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ll6w64ibh81qwvjx19h8nj7mngxgffg7aigjx11klvf5k2g4nxf";
      type = "gem";
    };
    version = "0.0.7.6";
  };
  vagrant-spec = {
    dependencies = ["childprocess" "log4r" "rspec" "thor"];
    source = {
      fetchSubmodules = false;
      rev = "abfc34474d122235d56e4c6b6fb5d3e35bedfa90";
      sha256 = "08xy2c82lrxkwjlvrbx1v32968a6psni3952y3knriqgygv2kzbn";
      type = "git";
      url = "https://github.com/hashicorp/vagrant-spec.git";
    };
    version = "0.0.1";
  };
  vagrant_cloud = {
    dependencies = ["rest-client"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0451x3ab869hbycffcq656dm7mmjwmnxcyhv6g7dpdv3acg64783";
      type = "gem";
    };
    version = "2.0.2";
  };
  wdm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x5l2pn4x92734k6i2wcjbn2klmwgkiqaajvxadh35k74dgnyh18";
      type = "gem";
    };
    version = "0.1.1";
  };
  winrm = {
    dependencies = ["builder" "erubis" "gssapi" "gyoku" "httpclient" "logging" "nori" "rubyntlm"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19vxrclxc5l8n2agwvv291740s6gna2phg3lkybjb0ldkmpi3sj2";
      type = "gem";
    };
    version = "2.3.2";
  };
  winrm-elevated = {
    dependencies = ["winrm" "winrm-fs"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1saqc3ffh075y6fdkc7iqmn0v3pnidvfw0sh09w9cn6jvpsdxizk";
      type = "gem";
    };
    version = "1.1.1";
  };
  winrm-fs = {
    dependencies = ["erubis" "logging" "rubyzip" "winrm"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fy4yj52kssrm5hchq7l2mbry6w6yvi736p1wjpyv8m19rx7k0c3";
      type = "gem";
    };
    version = "1.3.2";
  };
}