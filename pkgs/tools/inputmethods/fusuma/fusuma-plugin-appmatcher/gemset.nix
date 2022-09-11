{
  fusuma = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rq64grp98w7msjmj24hlxy1jqzqn96r81x4z09aq2v532cgqy4f";
      type = "gem";
    };
    version = "2.4.1";
  };
  fusuma-plugin-appmatcher = {
    dependencies = ["fusuma" "rexml" "ruby-dbus"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mfl51a5v3ym3v68z94rv92i0g5kkbaqb8f4z5gnbfqdw1gkqi1n";
      type = "gem";
    };
    version = "0.4.0";
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
      sha256 = "1zbxmxq4q1c1hm0bh3vc78d39bcg7w886d11d8rjas6vgw8cdi18";
      type = "gem";
    };
    version = "0.18.1";
  };
}
