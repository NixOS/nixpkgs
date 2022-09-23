{
  iostruct = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kwp6ryis32j3z7myw8g7v1yszwrwyl04g2c7flr42pwxga1afxc";
      type = "gem";
    };
    version = "0.0.4";
  };
  rainbow = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb2fpjspydr6x0s8pn1pqkzmxszvkfapv0p4627mywl7ky4zkhk";
      type = "gem";
    };
    version = "3.0.0";
  };
  zpng = {
    dependencies = ["rainbow"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ciyab7qxqsxjhfvr6rbpdzg655fi1zygqg9sd9m6wmgc037dj74";
      type = "gem";
    };
    version = "0.3.1";
  };
  zsteg = {
    dependencies = ["iostruct" "zpng"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mwajlsgs27449n2yf2f9hz8g46qv9bz9f58i9cz1jg58spvpxpk";
      type = "gem";
    };
    version = "0.2.2";
  };
}
