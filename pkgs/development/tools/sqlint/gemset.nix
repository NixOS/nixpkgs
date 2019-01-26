{
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  pg_query = {
    dependencies = ["json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zgwnrf5mkpkxfh49r2pvh2djivrbqd19350g8hxapmkya9w3qpi";
      type = "gem";
    };
    version = "1.0.0";
  };
  sqlint = {
    dependencies = ["pg_query"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wm81dgdmgc16b97bz73vm0wjd2m1ra1b40h0kwfd9wgrh9ig2al";
      type = "gem";
    };
    version = "0.1.7";
  };
}
