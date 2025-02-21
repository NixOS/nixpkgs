{
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18d1w5j7vjaza3v1ig9j7zyis04kxqdkb1272vbgncxn03ck45mm";
      type = "gem";
    };
    version = "3.25.0";
  };
  pg_query = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15ynrzqsmmbmxib8ri8n9k6z3l6rwd91j7y1mghm33nfgdf9bj8w";
      type = "gem";
    };
    version = "4.2.3";
  };
  sqlint = {
    dependencies = ["pg_query"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06gljzjhbfvxs85699jr1p7y2j8hhi629kfarad7yjqy7ssl541n";
      type = "gem";
    };
    version = "0.3.0";
  };
}
