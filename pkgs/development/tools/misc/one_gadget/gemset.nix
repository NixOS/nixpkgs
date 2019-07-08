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
      sha256 = "1ajymn59fr9117dkwf5xl8vmr737h6xmrcf1033zjlj2l5qkxn4a";
      type = "gem";
    };
    version = "1.0.2";
  };
  one_gadget = {
    dependencies = ["elftools"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wacvysd7ddnbx2jl1vhzbkb28y974riyns7bpx889518zaa09z0";
      type = "gem";
    };
    version = "1.6.2";
  };
}