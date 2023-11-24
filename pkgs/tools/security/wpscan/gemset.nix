{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s465919p6fcgcsqin8w8hay2m598dvnzks490hbsb0p68sdz69m";
      type = "gem";
    };
    version = "6.1.7.4";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15s8van7r2ad3dq6i03l3z4hqnvxcq75a3h72kxvf9an53sqma20";
      type = "gem";
    };
    version = "2.8.4";
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
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      type = "gem";
    };
    version = "1.2.2";
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
      sha256 = "0qaamqsh5f3szhcakkak8ikxlzxqnv49n2p7504hcz2l0f4nj0wx";
      type = "gem";
    };
    version = "1.14.1";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z7f38iq37h376n9xbl4gajdrnwzq284c9v1py4imw3gri2d5cj6";
      type = "gem";
    };
    version = "2.8.2";
  };
  minitest = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kg9wh7jlc9zsr3hkhpzkbn0ynf4np5ap9m2d8xdrb8shy0y6pmb";
      type = "gem";
    };
    version = "5.18.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n79k78c5vdcyl0m3y3l5x9kxl6xf5lgriwi2vd665qmdkr01vnk";
      type = "gem";
    };
    version = "1.13.10";
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
      sha256 = "11v3l46mwnlzlc371wr3x6yylpgafgwdf0q7hc7c1lzx6r414r5g";
      type = "gem";
    };
    version = "1.7.1";
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
      sha256 = "121ix0bl19pawhljs17sfgddkd0hgxlhchsz9kxw14ipmskjq9ah";
      type = "gem";
    };
    version = "1.2.7";
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
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  webrick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13qm7s0gr2pmfcl7dxrmq38asaza4w0i2n9my4yzs499j731wh8r";
      type = "gem";
    };
    version = "1.8.1";
  };
  wpscan = {
    dependencies = ["cms_scanner"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qh7x5sjx1i9h8zrp86qz126brxbqx0c3wxc8vn7fpln0y78nw9q";
      type = "gem";
    };
    version = "3.8.24";
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
      sha256 = "0ck6bj7wa73dkdh13735jl06k6cfny98glxjkas82aivlmyzqqbk";
      type = "gem";
    };
    version = "2.6.8";
  };
}
