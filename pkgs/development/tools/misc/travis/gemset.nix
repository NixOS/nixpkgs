{
  addressable = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mpn7sbjl477h56gmxsjqb89r5s3w7vx5af994ssgc3iamvgzgvs";
      type = "gem";
    };
    version = "2.4.0";
  };
  backports = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cczfi1yp7a68bg7ipzi4lvrmi4xsi36n9a19krr4yb3nfwd8fn2";
      type = "gem";
    };
    version = "3.15.0";
  };
  coderay = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vav4bhcc2x3jmi3izb11l4d9f3xv8hp2fszb7iqmpsccv1pz4y";
      type = "gem";
    };
    version = "1.1.2";
  };
  ethon = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gggrgkcq839mamx7a8jbnp2h7x2ykfn34ixwskwb0lzx2ak17g9";
      type = "gem";
    };
    version = "0.12.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jk2bar4x6miq2cr73lv0lsbmw4cymiljvp29xb85jifsb3ba6az";
      type = "gem";
    };
    version = "0.17.0";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a93rs58bakqck7bcihasz66a1riy22h2zpwrpmb13gp8mw3wkmr";
      type = "gem";
    };
    version = "0.13.1";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cbads5da12lb3j0mg2hjrd57s5qkkairxh2y6r9bqyblb5b8xbw";
      type = "gem";
    };
    version = "1.11.2";
  };
  gh = {
    dependencies = ["addressable" "backports" "faraday" "multi_json" "net-http-persistent" "net-http-pipeline"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g4df0jsscq16g6f27flfmvk7p4sbq81d5mdylbz4ikqq60kywzg";
      type = "gem";
    };
    version = "0.15.1";
  };
  highline = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ib7jp85xjc4gh4jg0wyzllm46hwv8p0w1m4c75pbgi41fps50y";
      type = "gem";
    };
    version = "1.7.10";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sx97bm9by389rbzv8r1f43h06xcz8vwi3h5jv074gvparql7lcx";
      type = "gem";
    };
    version = "2.2.0";
  };
  launchy = {
    dependencies = ["addressable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190lfbiy1vwxhbgn4nl4dcbzxvm049jwc158r2x7kq3g5khjrxa2";
      type = "gem";
    };
    version = "2.4.3";
  };
  method_source = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pviwzvdqd90gn6y7illcdd9adapw8fczml933p5vl739dkvl3lq";
      type = "gem";
    };
    version = "0.9.2";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xy54mjf7xg41l8qrg1bqri75agdqmxap9z466fjismc1rn2jwfr";
      type = "gem";
    };
    version = "1.14.1";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zgw9zlwh2a6i1yvhhc4a84ry1hv824d6g2iw2chs3k5aylpmpfj";
      type = "gem";
    };
    version = "2.1.1";
  };
  net-http-persistent = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y9fhaax0d9kkslyiqi1zys6cvpaqx9a0y0cywp24rpygwh4s9r4";
      type = "gem";
    };
    version = "2.9.4";
  };
  net-http-pipeline = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bxjy33yhxwsbnld8xj3zv64ibgfjn9rjpiqkyd5ipmz50pww8v9";
      type = "gem";
    };
    version = "1.0.1";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mh312k3y94sj0pi160wpia0ps8f4kmzvm505i6bvwynfdh7v30g";
      type = "gem";
    };
    version = "0.11.3";
  };
  pusher-client = {
    dependencies = ["json" "websocket"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18ymxz34gmg7jff3h0nyzp5vdg5i06dbdxlrdl2nq4hf14qwj1f4";
      type = "gem";
    };
    version = "0.6.2";
  };
  travis = {
    dependencies = ["backports" "faraday" "faraday_middleware" "gh" "highline" "launchy" "pusher-client" "typhoeus"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ggdksipvnkl7s0g84l4wfpm9v70x9id8xvb9jmn3l0hhlk54dsk";
      type = "gem";
    };
    version = "1.8.10";
  };
  typhoeus = {
    dependencies = ["ethon"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03x3fxjsnhgayl4s96h0a9975awlvx2v9nmx2ba0cnliglyczdr8";
      type = "gem";
    };
    version = "0.8.0";
  };
  websocket = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f11rcn4qgffb1rq4kjfwi7di79w8840x9l74pkyif5arp0mb08x";
      type = "gem";
    };
    version = "1.2.8";
  };
}