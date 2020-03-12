{
  pg_query = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "070iy9jdj0snfl42my5n6i2svcnn87cbffcjvvq5068hw0b0296w";
      type = "gem";
    };
    version = "1.1.0";
  };
  sqlint = {
    dependencies = ["pg_query"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pg9c00w520mw1mzq8kls8whwgqva1alksdsv536bh9nq7m2hnky";
      type = "gem";
    };
    version = "0.1.9";
  };
}