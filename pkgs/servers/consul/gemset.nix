{
  execjs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "097v02bhmzc70j7n0yyf8j0z5wms88zcmgpmggby4hnvqxf41y1h";
      type = "gem";
    };
    version = "2.3.0";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zzvv25vjikavd3b1bp6lvbgj23vv9jvmnl4vpim8pv30z8p6vr5";
      type = "gem";
    };
    version = "1.8.5";
  };
  libv8 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j5x22v7rqdk1047k0sz4k1xhf6hkdw6h1nl7xsw694hfjdb0vyx";
      type = "gem";
    };
    version = "3.16.14.15";
  };
  ref = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19qgpsfszwc2sfh6wixgky5agn831qq8ap854i1jqqhy1zsci3la";
      type = "gem";
    };
    version = "1.0.5";
  };
  sass = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10dncnv7g5v8d1xpw2aaarxjjlm68f7nm02ns2kl8nf3yxi6wzdf";
      type = "gem";
    };
    version = "3.4.11";
  };
  therubyracer = {
    dependencies = ["libv8" "ref"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "106fqimqyaalh7p6czbl5m2j69z8gv7cm10mjb8bbb2p2vlmqmi6";
      type = "gem";
    };
    version = "0.12.1";
  };
  uglifier = {
    dependencies = ["execjs" "json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x1mnakx086l83a3alj690c6n8kfmb4bk243a6m6yz99s15gbxfq";
      type = "gem";
    };
    version = "2.7.0";
  };
}