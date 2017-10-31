{
  execjs = {
    version = "2.3.0";
    source = {
      type = "gem";
      sha256 = "097v02bhmzc70j7n0yyf8j0z5wms88zcmgpmggby4hnvqxf41y1h";
    };
  };
  json = {
    version = "1.8.2";
    source = {
      type = "gem";
      sha256 = "0zzvv25vjikavd3b1bp6lvbgj23vv9jvmnl4vpim8pv30z8p6vr5";
    };
  };
  libv8 = {
    version = "3.16.14.11";
    source = {
      type = "gem";
      sha256 = "000vbiy78wk5r1f6p7qncab8ldg7qw5pjz7bchn3lw700gpaacxp";
    };
  };
  ref = {
    version = "1.0.5";
    source = {
      type = "gem";
      sha256 = "19qgpsfszwc2sfh6wixgky5agn831qq8ap854i1jqqhy1zsci3la";
    };
  };
  sass = {
    version = "3.4.11";
    source = {
      type = "gem";
      sha256 = "10dncnv7g5v8d1xpw2aaarxjjlm68f7nm02ns2kl8nf3yxi6wzdf";
    };
  };
  therubyracer = {
    version = "0.12.1";
    source = {
      type = "gem";
      sha256 = "106fqimqyaalh7p6czbl5m2j69z8gv7cm10mjb8bbb2p2vlmqmi6";
    };
    dependencies = [
      "libv8"
      "ref"
    ];
  };
  uglifier = {
    version = "2.7.0";
    source = {
      type = "gem";
      sha256 = "1x1mnakx086l83a3alj690c6n8kfmb4bk243a6m6yz99s15gbxfq";
    };
    dependencies = [
      "execjs"
      "json"
    ];
  };
}
