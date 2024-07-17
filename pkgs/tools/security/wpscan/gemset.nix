{
  activesupport = {
    dependencies = [
      "concurrent-ruby"
      "i18n"
      "minitest"
      "tzinfo"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nhrdih0rk46i0s6x7nqhbypmj1hf23zl5gfl9xasb6k4r2a1dxk";
      type = "gem";
    };
    version = "6.1.7.6";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05r1fwy487klqkya7vzia8hnklcxy4vr92m9dmni3prfwk6zpw33";
      type = "gem";
    };
    version = "2.8.5";
  };
  cms_scanner = {
    dependencies = [
      "ethon"
      "get_process_mem"
      "nokogiri"
      "opt_parse_validator"
      "public_suffix"
      "ruby-progressbar"
      "sys-proctable"
      "typhoeus"
      "xmlrpc"
      "yajl-ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p3vdkkd04r31d503z5v0480xlq1fhiw77icbk5s17y6dwfacydy";
      type = "gem";
    };
    version = "0.13.9";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      type = "gem";
    };
    version = "1.2.2";
  };
  ethon = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17ix0mijpsy3y0c6ywrk5ibarmvqzjsirjyprpsy3hwax8fdm85v";
      type = "gem";
    };
    version = "0.16.0";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yvii03hcgqj30maavddqamqy50h7y6xcn2wcyq72wn823zl4ckd";
      type = "gem";
    };
    version = "1.16.3";
  };
  get_process_mem = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fkyyyxjcx4iigm8vhraa629k2lxa1npsv4015y82snx84v3rzaa";
      type = "gem";
    };
    version = "0.2.7";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qaamqsh5f3szhcakkak8ikxlzxqnv49n2p7504hcz2l0f4nj0wx";
      type = "gem";
    };
    version = "1.14.1";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kl9c3kdchjabrihdqfmcplk3lq4cw1rr9f378y6q22qwy5dndvs";
      type = "gem";
    };
    version = "2.8.5";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bkmfi9mb49m0fkdhl2g38i3xxa02d411gg0m8x0gvbwfmmg5ym3";
      type = "gem";
    };
    version = "5.20.0";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "004ip9x9281fxhpipwi8di1sb1dnabscq9dy1p3cxgdwbniqqi12";
      type = "gem";
    };
    version = "1.15.5";
  };
  opt_parse_validator = {
    dependencies = [
      "activesupport"
      "addressable"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jzmn3h9sr7bhjj1fdfvh4yzvqx7d3vsbwbqrf718dh427ifqs9c";
      type = "gem";
    };
    version = "1.9.5";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bni4qjrsh2q49pnmmd6if4iv3ak36bd2cckrs6npl111n769k9m";
      type = "gem";
    };
    version = "5.0.4";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01b9662zd2x9bp4rdjfid07h09zxj7kvn7f5fghbqhzc625ap1dp";
      type = "gem";
    };
    version = "1.7.3";
  };
  ruby-progressbar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  sys-proctable = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0m3fj6j1qpfszqnsvr6wpak0d9vw5ggylaqkalhl3m50kbbimxii";
      type = "gem";
    };
    version = "1.3.0";
  };
  typhoeus = {
    dependencies = [ "ethon" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z7gamf6s83wy0yqms3bi4srirn3fc0lc7n65lqanidxcj1xn5qw";
      type = "gem";
    };
    version = "1.4.1";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  webrick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13qm7s0gr2pmfcl7dxrmq38asaza4w0i2n9my4yzs499j731wh8r";
      type = "gem";
    };
    version = "1.8.1";
  };
  wpscan = {
    dependencies = [ "cms_scanner" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x04asq0aznbm6m79jlsv7mjbhq755759s4bi3qbyrv5rwpy7hji";
      type = "gem";
    };
    version = "3.8.25";
  };
  xmlrpc = {
    dependencies = [ "webrick" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fwfnccagsjrbvrav5nbk3zracj9zncr7i375nn20jd4cfy4cggc";
      type = "gem";
    };
    version = "0.3.3";
  };
  yajl-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lni4jbyrlph7sz8y49q84pb0sbj82lgwvnjnsiv01xf26f4v5wc";
      type = "gem";
    };
    version = "1.4.3";
  };
  zeitwerk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gir0if4nryl1jhwi28669gjwhxb7gzrm1fcc8xzsch3bnbi47jn";
      type = "gem";
    };
    version = "2.6.12";
  };
}
