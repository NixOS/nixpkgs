{
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kz42nvxnk1j9cj0i8lcnhprcgdqsqska92g6l19ziadydfk2gqy";
      type = "gem";
    };
    version = "2.4.4";
  };
  elftools = {
    dependencies = ["bindata"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kdf0ck4rzxpd006y09rfwppdrqb3sxww4gzfpv2053yq4mkimbn";
      type = "gem";
    };
    version = "1.1.0";
  };
  one_gadget = {
    dependencies = ["elftools"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07s2nigjw1yik895gliz3a7ps0m9j5nccq82zwdd30sv740jmf5b";
      type = "gem";
    };
    version = "1.7.2";
  };
}
