{
  ast = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "184ssy3w93nkajlz2c70ifm79jp3j737294kbc5fjw69v1w0n9x7";
      type = "gem";
    };
    version = "2.4.0";
  };
  backport = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xmjljpyx5ly078gi0lmmgkv4y0msxxa3hmv74bzxzp3l8qbn5vc";
      type = "gem";
    };
    version = "1.1.2";
  };
  benchmark = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jadlpsl504ql436a6bx8ihp0bkg3rvxg7fbi4r1bmra3cqz0h88";
      type = "gem";
    };
    version = "0.1.0";
  };
  e2mmap = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n8gxjb63dck3vrmsdcqqll7xs7f3wk78mw8w0gdk9wp5nx6pvj5";
      type = "gem";
    };
    version = "0.1.0";
  };
  jaro_winkler = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y8l6k34svmdyqxya3iahpwbpvmn3fswhwsvrz0nk1wyb8yfihsh";
      type = "gem";
    };
    version = "1.5.4";
  };
  maruku = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r7bxpgnx2hp3g12bjrmdrpv663dfqxsdp0af69kjhxmaxpia56x";
      type = "gem";
    };
    version = "0.7.3";
  };
  mini_portile2 = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zplpfw3knqifj9bpf604rb3wc1vhq6363pd6lvhayng8wql5vy";
      type = "gem";
    };
    version = "2.4.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12j76d0bp608932xkzmfi638c7aqah57l437q8494znzbj610qnm";
      type = "gem";
    };
    version = "1.10.9";
  };
  parallel = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12jijkap4akzdv11lm08dglsc8jmc87xcgq6947i1s3qb69f4zn2";
      type = "gem";
    };
    version = "1.19.1";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iirjc36irgwpfb58jdf9gli382cj893y9caqhxas8anpzzlikgc";
      type = "gem";
    };
    version = "2.7.0.5";
  };
  rainbow = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb2fpjspydr6x0s8pn1pqkzmxszvkfapv0p4627mywl7ky4zkhk";
      type = "gem";
    };
    version = "3.0.0";
  };
  reverse_markdown = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w786j869fjhjf72waj0hc9i4ghi45b78a2am27kij4sa2hmsc53";
      type = "gem";
    };
    version = "1.4.0";
  };
  rexml = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mkvkcw9fhpaizrhca0pdgjcrbns48rlz4g6lavl5gjjq3rk2sq3";
      type = "gem";
    };
    version = "3.2.4";
  };
  rubocop = {
    dependencies = ["jaro_winkler" "parallel" "parser" "rainbow" "rexml" "ruby-progressbar" "unicode-display_width"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i8pw7p4dk11xpahs0j6vlvqlv3rgapaccj933g0i34hbx392lj8";
      type = "gem";
    };
    version = "0.80.1";
  };
  ruby-progressbar = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k77i0d4wsn23ggdd2msrcwfy0i376cglfqypkk2q77r2l3408zf";
      type = "gem";
    };
    version = "1.10.1";
  };
  solargraph = {
    dependencies = ["backport" "benchmark" "e2mmap" "jaro_winkler" "maruku" "nokogiri" "parser" "reverse_markdown" "rubocop" "thor" "tilt" "yard"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06kcqm032sq1y4pgg7cl32hv74573b1vsy79x81zglar80ybgzv4";
      type = "gem";
    };
    version = "0.38.6";
  };
  thor = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xbhkmyhlxwzshaqa7swy2bx6vd64mm0wrr8g3jywvxy7hg0cwkm";
      type = "gem";
    };
    version = "1.0.1";
  };
  tilt = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rn8z8hda4h41a64l0zhkiwz2vxw9b1nb70gl37h1dg2k874yrlv";
      type = "gem";
    };
    version = "2.0.10";
  };
  unicode-display_width = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pppclzq4qb26g321553nm9xqca3zgllvpwb2kqxsdadwj51s09x";
      type = "gem";
    };
    version = "1.6.1";
  };
  yard = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g0bw2qcl48fxawrdf68l229508z53mrqisavji2lkxzv4w4j2pp";
      type = "gem";
    };
    version = "0.9.24";
  };
}
