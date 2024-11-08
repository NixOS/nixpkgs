{
  colsole = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l29sxy4p9jbvcihckxfsyqx98b8xwzd3hjqvdh1zxw8nv5walnp";
      type = "gem";
    };
    version = "0.8.2";
  };
  completely = {
    dependencies = ["colsole" "mister_bin"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w7cmmsp9m42c8w4j03kr98zy7x7yszw3qsm3ww600dmc0d0xd2b";
      type = "gem";
    };
    version = "0.5.2";
  };
  docopt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rvlfbb7kzyagncm4zdpcjwrh682zamgf5rcf5qmj0bd6znkgy3k";
      type = "gem";
    };
    version = "0.6.1";
  };
  mister_bin = {
    dependencies = ["colsole" "docopt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f51zs9wjpslhdadp8yfx4ij0jj1ya92cbzqlfd2wfr19wdr2jgd";
      type = "gem";
    };
    version = "0.7.3";
  };
}
