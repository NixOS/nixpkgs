{
  erubis = {
    version = "2.7.0";
    src = {
      type = "gem";
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
    };
  };
  multi_json = {
    version = "1.3.6";
    src = {
      type = "gem";
      sha256 = "0q2zjfvd2ibds9g9nzf2p1b47fc1wqliwfywv5pw85w15lmy91yr";
    };
  };
  rack = {
    version = "1.5.2";
    src = {
      type = "gem";
      sha256 = "19szfw76cscrzjldvw30jp3461zl00w4xvw1x9lsmyp86h1g0jp6";
    };
  };
  rack-protection = {
    version = "1.5.3";
    src = {
      type = "gem";
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
    };
    dependencies = [
      "rack"
    ];
  };
  riemann-dash = {
    version = "0.2.9";
    src = {
      type = "gem";
      sha256 = "0ws5wmjbv8w9lcr3i2mdinj2qm91p6c85k6c067i67cf0p90jxq3";
    };
    dependencies = [
      "erubis"
      "multi_json"
      "sass"
      "sinatra"
      "webrick"
    ];
  };
  sass = {
    version = "3.4.8";
    src = {
      type = "gem";
      sha256 = "1ianyj2figwk314h10fkzpjql2xxi5l4njv1h0w8iyzjda85rqlp";
    };
  };
  sinatra = {
    version = "1.4.5";
    src = {
      type = "gem";
      sha256 = "0qyna3wzlnvsz69d21lxcm3ixq7db08mi08l0a88011qi4qq701s";
    };
    dependencies = [
      "rack"
      "rack-protection"
      "tilt"
    ];
  };
  tilt = {
    version = "1.4.1";
    src = {
      type = "gem";
      sha256 = "00sr3yy7sbqaq7cb2d2kpycajxqf1b1wr1yy33z4bnzmqii0b0ir";
    };
  };
  webrick = {
    version = "1.3.1";
    src = {
      type = "gem";
      sha256 = "0s42mxihcl2bx0h9q0v2syl70qndydfkl39a06h9il17p895ya8g";
    };
  };
}
