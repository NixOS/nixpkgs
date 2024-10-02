{
  diff-lcs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rwvjahnp7cpmracd8x732rjgnilqv2sx7d1gfrysslc3h039fa9";
      type = "gem";
    };
    version = "1.5.0";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  net-scp = {
    dependencies = ["net-ssh"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1si2nq9l6jy5n2zw1q59a5gaji7v9vhy8qx08h4fg368906ysbdk";
      type = "gem";
    };
    version = "4.0.0";
  };
  net-ssh = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yx0pb5fmziz92bw8qzbh8vf20lr56nd3s6q8h0gsgr307lki687";
      type = "gem";
    };
    version = "7.1.0";
  };
  net-telnet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13qxznpwmc3hs51b76wqx2w29r158gzzh8719kv2gpi56844c8fx";
      type = "gem";
    };
    version = "0.1.1";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "171rc90vcgjl8p1bdrqa92ymrj8a87qf6w20x05xq29mljcigi6c";
      type = "gem";
    };
    version = "3.12.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0da45cvllbv39sdbsl65vp5djb2xf5m10mxc9jm7rsqyyxjw4h1f";
      type = "gem";
    };
    version = "3.12.1";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03ba3lfdsj9zl00v1yvwgcx87lbadf87livlfa5kgqssn9qdnll6";
      type = "gem";
    };
    version = "3.12.2";
  };
  rspec-its = {
    dependencies = ["rspec-core" "rspec-expectations"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zafd70gxly5i0s00nky14sj2n92dnj3xpj83ysl3c2wx0119ad";
      type = "gem";
    };
    version = "1.3.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hfm17xakfvwya236graj6c2arr4sb9zasp35q5fykhyz8mhs0w2";
      type = "gem";
    };
    version = "3.12.5";
  };
  rspec-support = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12y52zwwb3xr7h91dy9k3ndmyyhr3mjcayk0nnarnrzz8yr48kfx";
      type = "gem";
    };
    version = "3.12.0";
  };
  serverspec = {
    dependencies = ["multi_json" "rspec" "rspec-its" "specinfra"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kqx84yspy75z517wf32mz2hr4bqmq33y46zik57rn7bq2pj39xx";
      type = "gem";
    };
    version = "2.42.2";
  };
  sfl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qm4hvhq9pszi9zs1cl9qgwx1n4wxq0af0hq9sbf6qihqd8rwwwr";
      type = "gem";
    };
    version = "2.3";
  };
  specinfra = {
    dependencies = ["net-scp" "net-ssh" "net-telnet" "sfl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19kkryvxnci7qd7rq5m3nl3xazy452bcg35a709kfggpfm4c6r38";
      type = "gem";
    };
    version = "2.85.0";
  };
}
