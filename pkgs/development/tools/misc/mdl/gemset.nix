{
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
  mdl = {
    dependencies = ["kramdown" "mixlib-cli" "mixlib-config"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "047hp8z1ma630wp38bm1giklkf385rp6wly8aidn825q831w2g4i";
      type = "gem";
    };
    version = "0.5.0";
  };
  mixlib-cli = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0647msh7kp7lzyf6m72g6snpirvhimjm22qb8xgv9pdhbcrmcccp";
      type = "gem";
    };
    version = "1.7.0";
  };
  mixlib-config = {
    dependencies = ["tomlrb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gm6yj9cbbgsl9x4xqxga0vz5w0ksq2jnq1wj8hvgm5c4wfcrswb";
      type = "gem";
    };
    version = "2.2.18";
  };
  tomlrb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g28ssfal6vry3cmhy509ba3vi5d5aggz1gnffnvvmc8ml8vkpiv";
      type = "gem";
    };
    version = "1.2.8";
  };
}