{
  beefcake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10gid0a7pdllh3qmjiqkqxgfqvd7m1f2dmcm4gcd19s63pv620gv";
      type = "gem";
    };
    version = "1.0.0";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qmj7fypgb9vag723w1a49qihxrcf5shzars106ynw2zk352gbv5";
      type = "gem";
    };
    version = "1.8.6";
  };
  mtrc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xj2pv4cpn0ad1xw38sinsxfzwhgqs6ff18hw0cwz5xmsf3zqmiz";
      type = "gem";
    };
    version = "0.0.4";
  };
  riemann-client = {
    dependencies = ["beefcake" "mtrc" "trollop"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02rp8x2y8h61x8mx9c8kwgm2yyvgg63g8km93zmwmkpp5fyi3fi8";
      type = "gem";
    };
    version = "0.2.6";
  };
  riemann-tools = {
    dependencies = ["json" "riemann-client" "trollop"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0brf44cq4xz0nqhs189zlg76527bfv3jr453yc00410qdzz8fpxa";
      type = "gem";
    };
    version = "0.2.13";
  };
  trollop = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "074h7lns72kg1dl5gvz5apl3xz1i0axbnbc01pf2kbw4q0lkpnp4";
      type = "gem";
    };
    version = "2.9.9";
  };
}