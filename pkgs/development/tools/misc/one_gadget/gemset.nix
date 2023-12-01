{
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04y4zgh4bbcb8wmkxwfqg4saky1d1f3xw8z6yk543q13h8ky8rz5";
      type = "gem";
    };
    version = "2.4.15";
  };
  elftools = {
    dependencies = ["bindata"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p96wj4sz3sfv9yxyl8z530554bkbf82vj24w6x7yf91qa1p8z6i";
      type = "gem";
    };
    version = "1.1.3";
  };
  one_gadget = {
    dependencies = ["elftools"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dwsmjhr9i8gwwbbpiyddbhcx74cvqqk90a5l8zbsjhjfs679irc";
      type = "gem";
    };
    version = "1.8.1";
  };
}
