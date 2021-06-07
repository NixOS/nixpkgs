{
  chef-utils = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14xd2md3cda42afl28hr5q4ng195zmqfn04w2bxr4s2fb0gglbrz";
      type = "gem";
    };
    version = "16.7.61";
  };
  kramdown = {
    dependencies = ["rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vmw752c26ny2jwl0npn0gbyqwgz4hdmlpxnsld9qi9xhk5b1qh7";
      type = "gem";
    };
    version = "2.3.0";
  };
  kramdown-parser-gfm = {
    dependencies = ["kramdown"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a8pb3v951f4x7h968rqfsa19c8arz21zw1vaj42jza22rap8fgv";
      type = "gem";
    };
    version = "1.1.0";
  };
  mdl = {
    dependencies = ["kramdown" "kramdown-parser-gfm" "mixlib-cli" "mixlib-config" "mixlib-shellout"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vgzq6v2scd8n4cmx8rrypqmchnhg4wccrhiakg2i8fzv7wxplqq";
      type = "gem";
    };
    version = "0.11.0";
  };
  mixlib-cli = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ydxlfgd7nnj3rp1y70k4yk96xz5cywldjii2zbnw3sq9pippwp6";
      type = "gem";
    };
    version = "2.1.8";
  };
  mixlib-config = {
    dependencies = ["tomlrb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1askip583sfnz25gywd508l3vj5wnvx9vp7gm1sfnixm7amssrwq";
      type = "gem";
    };
    version = "3.0.9";
  };
  mixlib-shellout = {
    dependencies = ["chef-utils"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y1z0phkdhpbsn8vz7a86nhkr7ra619j86z5p75amz61kfpw42z9";
      type = "gem";
    };
    version = "3.2.2";
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
  tomlrb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ssyvjcvaisv70f21arlmnw5a1ryzmxzz4538vdwfslz9xxl27sr";
      type = "gem";
    };
    version = "2.0.0";
  };
}
