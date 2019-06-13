{
  ast = {
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00kwxnj4jwjkf5ji473qsz0nq4kjsx6p6hzlm8iwbbylv22hf2xy";
      type = "gem";
    };
    version = "1.0.0";
  };
  htmlentities = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  jaro_winkler = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zz27z88qznix4r65gd9h56gl177snlfpgv10b0s69vi8qpl909l";
      type = "gem";
    };
    version = "1.5.2";
  };
  kramdown = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n1c4jmrh5ig8iv1rw81s4mw4xsp4v97hvf8zkigv4hn5h542qjq";
      type = "gem";
    };
    version = "1.17.0";
  };
  mini_portile2 = {
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
      sha256 = "02bjydih0j515szfv9mls195cvpyidh6ixm7dwbl3s2sbaxxk5s4";
      type = "gem";
    };
    version = "1.10.3";
  };
  parallel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x1gzgjrdlkm1aw0hfpyphsxcx90qgs3y4gmp9km3dvf4hc4qm8r";
      type = "gem";
    };
    version = "1.17.0";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnks149x0fzgqiw53qlmvcd8bi746cxdw03sjljby5s97p1fskn";
      type = "gem";
    };
    version = "2.6.3.0";
  };
  rainbow = {
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
      sha256 = "0w7y5n74daajvl9gixr91nh8670d7mkgspkk3ql71m8azq3nffbg";
      type = "gem";
    };
    version = "1.1.0";
  };
  rubocop = {
    dependencies = ["jaro_winkler" "parallel" "parser" "rainbow" "ruby-progressbar" "unicode-display_width"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "171bczfafdmyz1lj6mgz2wdzz8i42w10zw2wj5j13y2f6hp687ca";
      type = "gem";
    };
    version = "0.68.0";
  };
  ruby-progressbar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cv2ym3rl09svw8940ny67bav7b2db4ms39i4raaqzkf59jmhglk";
      type = "gem";
    };
    version = "1.10.0";
  };
  solargraph = {
    dependencies = ["backport" "htmlentities" "jaro_winkler" "kramdown" "parser" "reverse_markdown" "rubocop" "thor" "tilt" "yard"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bsv0x9hhxwki7v8x99wzxcl1spgwrsxqd6alpb2y0wf9lsakabl";
      type = "gem";
    };
    version = "0.32.1";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    version = "0.20.3";
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ca4k0clwf0rkvy7726x4nxpjxkpv67w043i39saxgldxd97zmwz";
      type = "gem";
    };
    version = "2.0.9";
  };
  unicode-display_width = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ssnc6rja9ii97z7m35y4zd0rd7cpv3bija20l7cpd7y4jyyx44q";
      type = "gem";
    };
    version = "1.5.0";
  };
  yard = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w0i13a0vsw4jmlj59xn64rdsqcsl9r3rmjjgdca5i51m1q4ix6v";
      type = "gem";
    };
    version = "0.9.19";
  };
}