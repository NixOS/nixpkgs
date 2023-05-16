{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0s465919p6fcgcsqin8w8hay2m598dvnzks490hbsb0p68sdz69m";
      type = "gem";
    };
    version = "6.1.7.4";
=======
      sha256 = "08wzpwgdm03vzb8gqr8bvfdarb89g5ah0skvwqk6qv87p55xqkyw";
      type = "gem";
    };
    version = "6.1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "15s8van7r2ad3dq6i03l3z4hqnvxcq75a3h72kxvf9an53sqma20";
      type = "gem";
    };
    version = "2.8.4";
=======
      sha256 = "022r3m9wdxljpbya69y2i3h9g3dhhfaqzidf95m6qjzms792jvgp";
      type = "gem";
    };
    version = "2.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  cms_scanner = {
    dependencies = ["ethon" "get_process_mem" "nokogiri" "opt_parse_validator" "public_suffix" "ruby-progressbar" "sys-proctable" "typhoeus" "xmlrpc" "yajl-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15d7djrrkrcwznglgkr4y80jbsbxaf071qhjnn4i1c4n7nszwwfj";
      type = "gem";
    };
    version = "0.13.8";
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
      sha256 = "0s4fpn3mqiizpmpy2a24k4v365pv75y50292r8ajrv4i1p5b2k14";
      type = "gem";
    };
    version = "1.1.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  ethon = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kd7c61f28f810fgxg480j7457nlvqarza9c2ra0zhav0dd80288";
      type = "gem";
    };
    version = "0.15.0";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1862ydmclzy1a0cjbvm8dz7847d9rch495ib0zb64y84d3xd4bkg";
      type = "gem";
    };
    version = "1.15.5";
  };
  get_process_mem = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fkyyyxjcx4iigm8vhraa629k2lxa1npsv4015y82snx84v3rzaa";
      type = "gem";
    };
    version = "0.2.7";
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
      sha256 = "0b2qyvnk4yynlg17ymkq4g5xgr275637fhl1mjh0valw3cb1fhhg";
      type = "gem";
    };
    version = "1.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0z7f38iq37h376n9xbl4gajdrnwzq284c9v1py4imw3gri2d5cj6";
      type = "gem";
    };
    version = "2.8.2";
=======
      sha256 = "0rapl1sfmfi3bfr68da4ca16yhc0pp93vjwkj7y3rdqrzy3b41hy";
      type = "gem";
    };
    version = "2.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  minitest = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1kg9wh7jlc9zsr3hkhpzkbn0ynf4np5ap9m2d8xdrb8shy0y6pmb";
      type = "gem";
    };
    version = "5.18.1";
=======
      sha256 = "06xf558gid4w8lwx13jwfdafsch9maz8m0g85wnfymqj63x5nbbd";
      type = "gem";
    };
    version = "5.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0n79k78c5vdcyl0m3y3l5x9kxl6xf5lgriwi2vd665qmdkr01vnk";
      type = "gem";
    };
    version = "1.13.10";
=======
      sha256 = "11w59ga9324yx6339dgsflz3dsqq2mky1qqdwcg6wi5s1bf2yldi";
      type = "gem";
    };
    version = "1.13.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  opt_parse_validator = {
    dependencies = ["activesupport" "addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jzmn3h9sr7bhjj1fdfvh4yzvqx7d3vsbwbqrf718dh427ifqs9c";
      type = "gem";
    };
    version = "1.9.5";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f3knlwfwm05sfbaihrxm4g772b79032q14c16q4b38z8bi63qcb";
      type = "gem";
    };
    version = "4.0.7";
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "11v3l46mwnlzlc371wr3x6yylpgafgwdf0q7hc7c1lzx6r414r5g";
      type = "gem";
    };
    version = "1.7.1";
=======
      sha256 = "0la56m0z26j3mfn1a9lf2l03qx1xifanndf9p3vx1azf6sqy7v9d";
      type = "gem";
    };
    version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  ruby-progressbar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02nmaw7yx9kl7rbaan5pl8x5nn0y4j5954mzrkzi9i3dhsrps4nc";
      type = "gem";
    };
    version = "1.11.0";
  };
  sys-proctable = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "121ix0bl19pawhljs17sfgddkd0hgxlhchsz9kxw14ipmskjq9ah";
      type = "gem";
    };
    version = "1.2.7";
=======
      sha256 = "17zzb1slwhq0j42qh8ywnh4c5ww2wwskl9362ayxf0am86b02zsb";
      type = "gem";
    };
    version = "1.2.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  typhoeus = {
    dependencies = ["ethon"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m22yrkmbj81rzhlny81j427qdvz57yk5wbcf3km0nf3bl6qiygz";
      type = "gem";
    };
    version = "1.4.0";
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
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
      sha256 = "10qp5x7f9hvlc0psv9gsfbxg4a7s0485wsbq1kljkxq94in91l4z";
      type = "gem";
    };
    version = "2.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  webrick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "13qm7s0gr2pmfcl7dxrmq38asaza4w0i2n9my4yzs499j731wh8r";
      type = "gem";
    };
    version = "1.8.1";
=======
      sha256 = "1d4cvgmxhfczxiq5fr534lmizkhigd15bsx5719r5ds7k7ivisc7";
      type = "gem";
    };
    version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  wpscan = {
    dependencies = ["cms_scanner"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0qh7x5sjx1i9h8zrp86qz126brxbqx0c3wxc8vn7fpln0y78nw9q";
      type = "gem";
    };
    version = "3.8.24";
=======
      sha256 = "0c89shx0qv2yanyn3k6z3sjszq12vak27j33akz0lkgpfpk2sngi";
      type = "gem";
    };
    version = "3.8.22";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  xmlrpc = {
    dependencies = ["webrick"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xa79ry3976ylap38cr5g6q3m81plm611flqd3dwgnmgbkycb6jp";
      type = "gem";
    };
    version = "0.3.2";
  };
  yajl-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lni4jbyrlph7sz8y49q84pb0sbj82lgwvnjnsiv01xf26f4v5wc";
      type = "gem";
    };
    version = "1.4.3";
  };
  zeitwerk = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0ck6bj7wa73dkdh13735jl06k6cfny98glxjkas82aivlmyzqqbk";
      type = "gem";
    };
    version = "2.6.8";
=======
      sha256 = "09bq7j2p6mkbxnsg71s253dm2463kg51xc7bmjcxgyblqbh4ln7m";
      type = "gem";
    };
    version = "2.5.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
