{
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08r67nglsqnxrbn803szf5bdnqhchhq8kf2by94f37fcl65wpp19";
      type = "gem";
    };
    version = "2.5.0";
  };
  elftools = {
    dependencies = ["bindata"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p96wj4sz3sfv9yxyl8z530554bkbf82vj24w6x7yf91qa1p8z6i";
      type = "gem";
    };
    version = "1.1.3";
  };
  one_gadget = {
    dependencies = ["elftools"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j9478h929jm5hq2fs3v8y37a7y2hhpli90mbps7yvka4ykci7mw";
      type = "gem";
    };
    version = "1.9.0";
  };
}
