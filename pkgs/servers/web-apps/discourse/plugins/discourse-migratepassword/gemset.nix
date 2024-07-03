{
  argon2 = {
    dependencies = ["ffi" "ffi-compiler"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wdllcqlr81nzyf485ldv1p660xsi476p79ghbj7zsf3n9n86gwd";
      type = "gem";
    };
    version = "2.2.0";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ai0m15jg3n0b22mimk09ppnga316dc7dyvz06w8rrqh5gy1lslp";
      type = "gem";
    };
    version = "3.1.13";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07139870npj59jnl8vmk39ja3gdk3fb5z9vc0lf32y2h891hwqsi";
      type = "gem";
    };
    version = "1.17.0";
  };
  ffi-compiler = {
    dependencies = ["ffi" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c2caqm9wqnbidcb8dj4wd3s902z15qmgxplwyfyqbwa0ydki7q1";
      type = "gem";
    };
    version = "1.0.1";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17850wcwkgi30p7yqh60960ypn7yibacjjha0av78zaxwvd3ijs6";
      type = "gem";
    };
    version = "13.2.1";
  };
  unix-crypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wflipsmmicmgvqilp9pml4x19b337kh6p6jgrzqrzpkq2z52gdq";
      type = "gem";
    };
    version = "1.3.0";
  };
}
