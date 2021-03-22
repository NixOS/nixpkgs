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
    dependencies = ["rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jdbcjv4v7sj888bv3vc6d1dg4ackkh7ywlmn9ln2g9alk7kisar";
      type = "gem";
    };
    version = "2.3.1";
  };
  kramdown-rfc2629 = {
    dependencies = ["certified" "json_pure" "kramdown"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1iviq8q9za2hg0vqyrarrc3mqfskgp7spxp37xj0kl3g89vswq";
      type = "gem";
    };
    version = "1.4.1";
  };
  rexml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mkvkcw9fhpaizrhca0pdgjcrbns48rlz4g6lavl5gjjq3rk2sq3";
      type = "gem";
    };
    version = "3.2.4";
  };
}
