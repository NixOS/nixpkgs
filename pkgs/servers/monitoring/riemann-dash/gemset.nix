{
  "erubis" = {
    version = "2.7.0";
    source = {
      type = "gem";
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
    };
  };
  "multi_json" = {
    version = "1.3.6";
    source = {
      type = "gem";
      sha256 = "0q2zjfvd2ibds9g9nzf2p1b47fc1wqliwfywv5pw85w15lmy91yr";
    };
  };
  "rack" = {
    version = "1.6.1";
    source = {
      type = "gem";
      sha256 = "0f73v6phkwczl1sfv0wgdwsnlsg364bhialbnfkg2dnxhh57l0gl";
    };
  };
  "rack-protection" = {
    version = "1.5.3";
    source = {
      type = "gem";
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
    };
    dependencies = [
      "rack"
    ];
  };
  "riemann-dash" = {
    version = "0.2.11";
    source = {
      type = "gem";
      sha256 = "1vzb75hf1xy7ssil7fp9z7z51vh79ba22x56ific7f1kcb21lzk7";
    };
    dependencies = [
      "erubis"
      "multi_json"
      "sass"
      "sinatra"
      "webrick"
    ];
  };
  "sass" = {
    version = "3.4.14";
    source = {
      type = "gem";
      sha256 = "0x2mg6pid87s4ddvv6xnxfzwgy72pjmkm461pav92ngqnngx2ggk";
    };
  };
  "sinatra" = {
    version = "1.4.6";
    source = {
      type = "gem";
      sha256 = "1hhmwqc81ram7lfwwziv0z70jh92sj1m7h7s9fr0cn2xq8mmn8l7";
    };
    dependencies = [
      "rack"
      "rack-protection"
      "tilt"
    ];
  };
  "tilt" = {
    version = "2.0.1";
    source = {
      type = "gem";
      sha256 = "1qc1k2r6whnb006m10751dyz3168cq72vj8mgp5m2hpys8n6xp3k";
    };
  };
  "webrick" = {
    version = "1.3.1";
    source = {
      type = "gem";
      sha256 = "0s42mxihcl2bx0h9q0v2syl70qndydfkl39a06h9il17p895ya8g";
    };
  };
}