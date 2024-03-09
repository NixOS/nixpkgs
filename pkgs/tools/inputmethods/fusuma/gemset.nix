{
  fusuma = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13pbvmkjriq6myynv4gfismiqa9y7bfbvvrfcv25670l4zyiakhm";
      type = "gem";
    };
    version = "3.3.1";
  };
  fusuma-plugin-appmatcher = {
    dependencies = ["fusuma" "rexml" "ruby-dbus"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qkir4a657znq0fnx91lik7bw5kyq54jwhiy2zrlplln78xs5yai";
      type = "gem";
    };
    version = "0.6.1";
  };
  fusuma-plugin-keypress = {
    dependencies = ["fusuma"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0as95haqa943i740xs7czcaibb8lvy4gn6kr8nbldq20nly64bih";
      type = "gem";
    };
    version = "0.9.0";
  };
  fusuma-plugin-sendkey = {
    dependencies = ["fusuma" "revdev"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rdpxq4nanw85x1djdanwnz46b19fr46kdlkkgbxa4dnjk0zx4pp";
      type = "gem";
    };
    version = "0.10.1";
  };
  fusuma-plugin-wmctrl = {
    dependencies = ["fusuma"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rgz1d6ahg5i9sr4z2kab5qk7pm3rm0h7r1vwkygi75rv2r3jy86";
      type = "gem";
    };
    version = "1.3.1";
  };
  revdev = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b6zg6vqlaik13fqxxcxhd4qnkfgdjnl4wy3a1q67281bl0qpsz9";
      type = "gem";
    };
    version = "0.2.1";
  };
  rexml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05i8518ay14kjbma550mv0jm8a6di8yp5phzrd8rj44z9qnrlrp0";
      type = "gem";
    };
    version = "3.2.6";
  };
  ruby-dbus = {
    dependencies = ["rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hf9y5lbi1xcadc2fw87wlif75s1359c2wwlvvd0gag7cq5dm0pm";
      type = "gem";
    };
    version = "0.23.1";
  };
}
