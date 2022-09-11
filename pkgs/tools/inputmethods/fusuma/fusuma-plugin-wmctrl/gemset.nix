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
  fusuma-plugin-wmctrl = {
    dependencies = ["fusuma"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ji1cp9lvxmcp29rcnplq986wfdqvbxk55xmdkyy6rcxg8x5kmv7";
      type = "gem";
    };
    version = "1.1.0";
  };
}
