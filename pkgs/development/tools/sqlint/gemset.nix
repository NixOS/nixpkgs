{
  pg_query = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p9s6znavm6v5dwk1hxg9a8h2lrrwh9l0rlk0sy8cx4sq2mq82m1";
      type = "gem";
    };
    version = "1.2.0";
  };
  sqlint = {
    dependencies = ["pg_query"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ds7qsaqi745fda8nliy15is36l1bkfbfkr43q6smpy103xbk44c";
      type = "gem";
    };
    version = "0.1.10";
  };
}