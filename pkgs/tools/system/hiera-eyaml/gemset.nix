{
  hiera-eyaml = {
    dependencies = ["highline" "optimist"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "049rxnwyivqgyjl0sjg7cb2q44ic0wsml288caspd1ps8v31gl18";
      type = "gem";
    };
    version = "3.0.0";
  };
  highline = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06bml1fjsnrhd956wqq5k3w8cyd09rv1vixdpa3zzkl6xs72jdn1";
      type = "gem";
    };
    version = "1.6.21";
  };
  optimist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05jxrp3nbn5iilc1k7ir90mfnwc5abc9h78s5rpm3qafwqxvcj4j";
      type = "gem";
    };
    version = "3.0.0";
  };
}
