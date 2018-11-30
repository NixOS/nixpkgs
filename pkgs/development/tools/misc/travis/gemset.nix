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
      sha256 = "1hshjxww2h7s0dk57njrygq4zpp0nlqrjfya7zwm27iq3rhc3y8g";
      type = "gem";
    };
    version = "3.11.4";
  };
  ethon = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y70szwm2p0b9qfvpqrzjrgm3jz0ig65vlbfr6ppc3z0m1h7kv48";
      type = "gem";
    };
    version = "0.11.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14lg0c4bphk16rccc5jmaan6nfcvmy0caiahpc61f9zfwpsj7ymg";
      type = "gem";
    };
    version = "0.15.2";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p7icfl28nvl8qqdsngryz1snqic9l8x6bk0dxd7ygn230y0k41d";
      type = "gem";
    };
    version = "0.12.2";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jpm2dis1j7zvvy3lg7axz9jml316zrn7s0j59vyq3qr127z0m7q";
      type = "gem";
    };
    version = "1.9.25";
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
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
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
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
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
      sha256 = "0lw206zr2waic1kmm6x9qj91975g035wfsvbqs09z1cy8cvp63yw";
      type = "gem";
    };
    version = "1.8.9";
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