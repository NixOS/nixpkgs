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
  json_pure = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "030hmc268wchqsccbjk41hvbyg99krpa72i3q0y3wwqzfh8hi736";
      type = "gem";
    };
    version = "2.5.1";
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
    dependencies = ["certified" "json_pure" "kramdown"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16m08q5bgib3i54bb9p3inrxb1xksiybs9zj1rnncq492gcqqv4j";
      type = "gem";
    };
    version = "1.3.37";
  };
}
