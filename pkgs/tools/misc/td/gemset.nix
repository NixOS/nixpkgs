{
  fluent-logger = {
    dependencies = [ "msgpack" ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yr6vrai4fqajpzybmdlajf8wzsgy29kr1318amn21y9nhjlnys5";
      type = "gem";
    };
    version = "0.8.0";
  };
  hirb = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mzch3c2lvmf8gskgzlx6j53d10j42ir6ik2dkrl27sblhy76cji";
      type = "gem";
    };
    version = "0.7.3";
  };
  httpclient = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  msgpack = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0031gd2mjyba6jb7m97sqa149zjkr0vzn2s2gpb3m9nb67gqkm13";
      type = "gem";
    };
    version = "1.2.6";
  };
  parallel = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "005shcy8dabc7lwydpkbhd3fx8bfqzvsj6g04r90mx0wky10lz84";
      type = "gem";
    };
    version = "1.13.0";
  };
  ruby-progressbar = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cv2ym3rl09svw8940ny67bav7b2db4ms39i4raaqzkf59jmhglk";
      type = "gem";
    };
    version = "1.10.0";
  };
  rubyzip = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1n1lb2sdwh9h27y244hxzg1lrxxg2m53pk1vq7p33bna003qkyrj";
      type = "gem";
    };
    version = "1.2.2";
  };
  td = {
    dependencies = [
      "hirb"
      "msgpack"
      "parallel"
      "ruby-progressbar"
      "rubyzip"
      "td-client"
      "td-logger"
      "yajl-ruby"
      "zip-zip"
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nlxpc4nasgmv6mqanb6ag1q3wmryja2c174dzgwxngxa0y2j1yn";
      type = "gem";
    };
    version = "0.16.4";
  };
  td-client = {
    dependencies = [
      "httpclient"
      "msgpack"
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j5jcsgg020cm8xarbbw67mca4k8cx5pfyd2mm3wcqrnc1cl2bgp";
      type = "gem";
    };
    version = "1.0.6";
  };
  td-logger = {
    dependencies = [
      "fluent-logger"
      "msgpack"
      "td-client"
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y56gilaqk9a4lfhzb777ysmsq77pi1aqkr4q485a7f5dwnpwl1p";
      type = "gem";
    };
    version = "0.3.27";
  };
  yajl-ruby = {
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16v0w5749qjp13xhjgr2gcsvjv6mf35br7iqwycix1n2h7kfcckf";
      type = "gem";
    };
    version = "1.4.1";
  };
  zip-zip = {
    dependencies = [ "rubyzip" ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ny3zv1sn9wasamykfkg7b7xgs6w7k5fy8kggiyjj9vrwfzzavqg";
      type = "gem";
    };
    version = "0.3";
  };
}
