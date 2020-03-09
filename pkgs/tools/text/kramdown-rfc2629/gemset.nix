{
  certified = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1706p6p0a8adyvd943af2a3093xakvislgffw3v9dvp7j07dyk5a";
      type = "gem";
    };
    version = "1.0.0";
  };
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
  kramdown-rfc2629 = {
    dependencies = ["certified" "kramdown"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s53m46qlcdakik0czvx0p41mk46l9l36331cps8gpf364wf3l9d";
      type = "gem";
    };
    version = "1.2.13";
  };
}