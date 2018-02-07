{
  arr-pm = {
    dependencies = ["cabin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07yx1g1nh4zdy38i2id1xyp42fvj4vl6i196jn7szvjfm0jx98hg";
      type = "gem";
    };
    version = "0.0.10";
  };
  backports = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1agsk23kfr194s690jnrpijh9pf3hq4a9yy66j1wzzj2x19ss9y0";
      type = "gem";
    };
    version = "3.10.3";
  };
  cabin = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b3b8j3iqnagjfn1261b9ncaac9g44zrx1kcg81yg4z9i513kici";
      type = "gem";
    };
    version = "0.9.0";
  };
  childprocess = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "081hxbgrqjxha0jz0p0wkncdqawdvlsxb3awsx195g0pgkpqrcms";
      type = "gem";
    };
    version = "0.8.0";
  };
  clamp = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jb6l4scp69xifhicb5sffdixqkw8wgkk9k2q57kh2y36x1px9az";
      type = "gem";
    };
    version = "1.0.1";
  };
  dotenv = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pgzlvs0sswnqlgfm9gkz2hlhkc0zd3vnlp2vglb1wbgnx37pjjv";
      type = "gem";
    };
    version = "2.2.1";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "034f52xf7zcqgbvwbl20jwdyjwznvqnwpbaps9nk18v9lgb1dpx0";
      type = "gem";
    };
    version = "1.9.18";
  };
  fpm = {
    dependencies = ["arr-pm" "backports" "cabin" "childprocess" "clamp" "ffi" "json" "pleaserun" "ruby-xz" "stud"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yvp9cifzfrxv3pr1kvcvvnyrcz8vxf6yd43hg5blaick50sbm23";
      type = "gem";
    };
    version = "1.9.3";
  };
  insist = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bw3bdwns14mapbgb8cbjmr0amvwz8y72gyclq04xp43wpp5jrvg";
      type = "gem";
    };
    version = "1.0.0";
  };
  io-like = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nn0s2wmgxij3k760h3r8m1dgih5dmd9h4v1nn085yi824i5z6k";
      type = "gem";
    };
    version = "0.3.0";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qmj7fypgb9vag723w1a49qihxrcf5shzars106ynw2zk352gbv5";
      type = "gem";
    };
    version = "1.8.6";
  };
  mustache = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g5hplm0k06vwxwqzwn1mq5bd02yp0h3rym4zwzw26aqi7drcsl2";
      type = "gem";
    };
    version = "0.99.8";
  };
  pleaserun = {
    dependencies = ["cabin" "clamp" "dotenv" "insist" "mustache" "stud"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hgnrl67zkqaxmfkwbyscawj4wqjm7h8khpbj58s6iw54wp3408p";
      type = "gem";
    };
    version = "0.0.30";
  };
  ruby-xz = {
    dependencies = ["ffi" "io-like"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11bgpvvk0098ghvlxr4i713jmi2izychalgikwvdwmpb452r3ndw";
      type = "gem";
    };
    version = "0.2.3";
  };
  stud = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qpb57cbpm9rwgsygqxifca0zma87drnlacv49cqs2n5iyi6z8kb";
      type = "gem";
    };
    version = "0.0.23";
  };
}