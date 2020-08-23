{
  ast = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l3468czzjmxl93ap40hp7z94yxp4nbag0bxqs789bm30md90m2a";
      type = "gem";
    };
    version = "2.4.1";
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
      sha256 = "162122h7vkg9crc9gsjwpy6bjrwg9r8ghhimwk952i5rrln3kird";
      type = "gem";
    };
    version = "2.7.1.3";
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
  regexp_parser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "106azpr2c280y2f8jnr6fd49q1abb43xh9hhgbxc4d4kvzpa8094";
      type = "gem";
    };
    version = "1.7.1";
  };
  reverse_markdown = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w6fv779542vdliq2kmikfhymjv55z8mgzblkfjdy2agl07da9c6";
      type = "gem";
    };
    version = "2.0.0";
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
    dependencies = ["parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ghvlbaxcvwqqpkikzdg125frf5i733lhnih79ghrvc4rykvi86h";
      type = "gem";
    };
    version = "0.85.1";
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lbs9is1y85cmd6p3yq3v0nppq4rhpy8ynk2ln0y4rwrlb5088dh";
      type = "gem";
    };
    version = "0.0.3";
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
      sha256 = "140zs7syf6l641p6459rg1byc2h9z2ldhmc0hbzmkgqp4lw18n7c";
      type = "gem";
    };
    version = "0.39.8";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06i3id27s60141x6fdnjn5rar1cywdwy64ilc59cz937303q3mna";
      type = "gem";
    };
    version = "1.7.0";
  };
  yard = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "126m49mvh4lbvlvrprq7xj2vjixbq3xqr8dwr089vadvs0rkn4rd";
      type = "gem";
    };
    version = "0.9.25";
  };
}