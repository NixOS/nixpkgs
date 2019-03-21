{
  ast = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "184ssy3w93nkajlz2c70ifm79jp3j737294kbc5fjw69v1w0n9x7";
      type = "gem";
    };
    version = "2.4.0";
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
  parallel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01hj8v1qnyl5ndrs33g8ld8ibk0rbcqdpkpznr04gkbxd11pqn67";
      type = "gem";
    };
    version = "1.12.1";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zjk0w1kjj3xk8ymy1430aa4gg0k8ckphfj88br6il4pm83f0n1f";
      type = "gem";
    };
    version = "2.5.3.0";
  };
  powerpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r51d67wd467rpdfl6x43y84vwm8f5ql9l9m85ak1s2sp3nc5hyv";
      type = "gem";
    };
    version = "0.1.2";
  };
  rainbow = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb2fpjspydr6x0s8pn1pqkzmxszvkfapv0p4627mywl7ky4zkhk";
      type = "gem";
    };
    version = "3.0.0";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sy5a7nh6xjdc9yhcw31jji7ssrf9v5806hn95gbrzr998a2ydjn";
      type = "gem";
    };
    version = "12.3.2";
  };
  rubocop = {
    dependencies = ["jaro_winkler" "parallel" "parser" "powerpack" "rainbow" "ruby-progressbar" "unicode-display_width"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03narxzrpbilwbhr19qklvxhg22i8jkfar4igb1l8m73jydpxfvk";
      type = "gem";
    };
    version = "0.62.0";
  };
  ruby-progressbar = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cv2ym3rl09svw8940ny67bav7b2db4ms39i4raaqzkf59jmhglk";
      type = "gem";
    };
    version = "1.10.0";
  };
  unicode-display_width = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bq528fibi8s0jmxz0xzlgzggdq0x4fx46wfqz49478pv8gb2diq";
      type = "gem";
    };
    version = "1.4.1";
  };
}