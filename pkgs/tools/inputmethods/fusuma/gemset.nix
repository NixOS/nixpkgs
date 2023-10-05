{
  fusuma = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "163an1yv8lasbdmdjsj2a4byq1rljg7vf5z86ip33xpb9l133xmm";
      type = "gem";
    };
    version = "3.1.0";
  };
  fusuma-plugin-appmatcher = {
    dependencies = ["fusuma" "rexml" "ruby-dbus"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "28e8c59d5984a5723510f19868c37c363bec93e51f6cb7a573170cf7f5b9189f";
      type = "gem";
    };
    version = "0.6.0";
  };
  fusuma-plugin-keypress = {
    dependencies = ["fusuma"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045c1820d909307abb1d232c0cf26bbd88eafa0453004124c07b15fff5d680de";
      type = "gem";
    };
    version = "0.8.0";
  };
  fusuma-plugin-sendkey = {
    dependencies = ["fusuma" "revdev"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "f792fec194b611d5d79b93b6694876292c43bee55635d9422f885b6509eeb765";
      type = "gem";
    };
    version = "0.10.1";
  };
  fusuma-plugin-tap = {
    dependencies = ["fusuma"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jlw08iw20fpykjglzj4c2fy3z13zsnmi63zbfpn0gmvs05869ys";
      type = "gem";
    };
    version = "0.4.2";
  };
  fusuma-plugin-wmctrl = {
    dependencies = ["fusuma"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "067939b2d8b99cf8fce43be40341cda3de3371596a8a4fb24eb13ca84c0bffe5";
      type = "gem";
    };
    version = "1.3.1";
  };
  revdev = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b6zg6vqlaik13fqxxcxhd4qnkfgdjnl4wy3a1q67281bl0qpsz9";
      type = "gem";
    };
    version = "0.2.1";
  };
  rexml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
  };
  ruby-dbus = {
    dependencies = ["rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18zbsr03drpx7mknm927i2kz5b49s0lwmrbmsdknfa674z0xy6sm";
      type = "gem";
    };
    version = "0.19.0";
  };
}
