{
  "erubis" = {
    version = "2.7.0";
    source = {
      type = "gem";
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
    };
  };
  "thor" = {
    version = "0.19.1";
    source = {
      type = "gem";
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
    };
  };
  "tmuxinator" = {
    version = "0.6.9";
    source = {
      type = "gem";
      sha256 = "0q0ld82dznjsan7ciblfsxz59brcc16fwmvr9n3c7vdcndj8rd27";
    };
    dependencies = [
      "erubis"
      "thor"
    ];
  };
}