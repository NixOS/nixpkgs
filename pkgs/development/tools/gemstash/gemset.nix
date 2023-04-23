{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "164lmi9w96wdwd00dnly8f9dcak3blv49ymyqz30q2fdjn45c775";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.2.6.2";
  };
  concurrent-ruby = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nwad3211p7yv9sda31jmbyw6sdafzmdi2i2niaz6f0wk5nq9h0f";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.9";
  };
  dalli = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0br39scmr187w3ifl5gsddl2fhq6ahijgw6358plqjdzrizlg764";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.7.11";
  };
  faraday = {
    dependencies = ["multipart-post"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bs2lm0wd273kwq8nk1p8pk43n1wrizv4c1bdywkpcm9g2f5sp6p";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.17.5";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x7jgvpzl1nm7hqcnc8carq6yj1lijq74jv8pph4sb3bcpfpvcsc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.14.0";
  };
  gemstash = {
    dependencies = ["activesupport" "dalli" "faraday" "faraday_middleware" "lru_redux" "puma" "sequel" "server_health_check-rack" "sinatra" "sqlite3" "thor"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fimbc5xnsxq1g2zb7kn4qf3rp4klx7fxbigg34gr9i9apq8qfrc";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.1.0";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b2qyvnk4yynlg17ymkq4g5xgr275637fhl1mjh0valw3cb1fhhg";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.10.0";
  };
  lru_redux = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yxghzg7476sivz8yyr9nkak2dlbls0b89vc2kg52k0nmg6d0wgf";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.0";
  };
  minitest = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06xf558gid4w8lwx13jwfdafsch9maz8m0g85wnfymqj63x5nbbd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.15.0";
  };
  multipart-post = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zgw9zlwh2a6i1yvhhc4a84ry1hv824d6g2iw2chs3k5aylpmpfj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.1.1";
  };
  mustermann = {
    dependencies = ["ruby2_keywords"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ccm54qgshr1lq3pr1dfh7gphkilc19dp63rw6fcx7460pjwy88a";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.1.1";
  };
  nio4r = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xk64wghkscs6bv2n22853k2nh39d131c6rfpnlw12mbjnnv9v1v";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.5.8";
  };
  puma = {
    dependencies = ["nio4r"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xvkz9xrd1cqnlm0qac1iwwxzndx3cc17zrjncpa4lzjfwbxhsnm";
      type = "gem";
    };
    target_platform = "ruby";
    version = "4.3.11";
  };
  rack = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i5vs0dph9i5jn8dfc6aqd6njcafmb20rwqngrf759c9cvmyff16";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.3";
  };
  rack-protection = {
    dependencies = ["rack"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hz6h6d67r217qi202qmxq2xkn3643ay3iybhl3dq3qd6j8nm3b2";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.0";
  };
  ruby2_keywords = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.0.5";
  };
  sequel = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wzb16vyslr7bpy7g5k2m35yz90bpf12f3pzj5w6icf1vldnc3nf";
      type = "gem";
    };
    target_platform = "ruby";
    version = "5.54.0";
  };
  server_health_check = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06chz92parchhj1457lf5lbj3hrmvqpq6mfskxcnj5f4qa14n5wd";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.0.2";
  };
  server_health_check-rack = {
    dependencies = ["server_health_check"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cgqr94x18f60n27sk9lgg471c6vk6qy132z7i1ppp32kvmjfphs";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.1.0";
  };
  sinatra = {
    dependencies = ["mustermann" "rack" "rack-protection" "tilt"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x3rci7k30g96y307hvglpdgm3f7nga3k3n4i8n1v2xxx290800y";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.2.0";
  };
  sqlite3 = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lja01cp9xd5m6vmx99zwn4r7s97r1w5cb76gqd8xhbm1wxyzf78";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.4.2";
  };
  thor = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.20.3";
  };
  thread_safe = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    target_platform = "ruby";
    version = "0.3.6";
  };
  tilt = {
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rn8z8hda4h41a64l0zhkiwz2vxw9b1nb70gl37h1dg2k874yrlv";
      type = "gem";
    };
    target_platform = "ruby";
    version = "2.0.10";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    gem_platform = "ruby";
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zwqqh6138s8b321fwvfbywxy00lw1azw4ql3zr0xh1aqxf8cnvj";
      type = "gem";
    };
    target_platform = "ruby";
    version = "1.2.9";
  };
}
