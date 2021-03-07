{
  ast = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nc8x27hlzlrr5c2gn7mar4vdr0apw5xg22wp6m8dx3wqr04a0y";
      type = "gem";
    };
    version = "2.4.2";
  };
  parallel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0055br0mibnqz0j8wvy20zry548dhkakws681bhj3ycb972awkzd";
      type = "gem";
    };
    version = "1.20.1";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jixakyzmy0j5c1rb0fjrrdhgnyryvrr6vgcybs14jfw09akv5ml";
      type = "gem";
    };
    version = "3.0.0.0";
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
  regexp_parser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vg7imjnfcqjx7kw94ccj5r78j4g190cqzi1i59sh4a0l940b9cr";
      type = "gem";
    };
    version = "2.1.1";
  };
  rexml = {
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
      sha256 = "0zrzsgx35mcr81c51gyx63s7yngcfgk33dbkx5j0npkaks4fcm7r";
      type = "gem";
    };
    version = "1.11.0";
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gkf1p8yal38nlvdb39qaiy0gr85fxfr09j5dxh8qvrgpncpnk78";
      type = "gem";
    };
    version = "1.4.1";
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
  unicode-display_width = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bilbnc8j6jkb59lrf177i3p1pdyxll0n8400hzqr35vl3r3kv2m";
      type = "gem";
    };
    version = "2.0.0";
  };
}
