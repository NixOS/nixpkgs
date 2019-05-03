{
  arr-pm = {
    dependencies = ["cabin"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07yx1g1nh4zdy38i2id1xyp42fvj4vl6i196jn7szvjfm0jx98hg";
      type = "gem";
    };
    version = "0.0.10";
  };
  backports = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17j5pf0b69bkn043wi4xd530ky53jbbnljr4bsjzlm4k8bzlknfn";
      type = "gem";
    };
    version = "3.14.0";
  };
  cabin = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b3b8j3iqnagjfn1261b9ncaac9g44zrx1kcg81yg4z9i513kici";
      type = "gem";
    };
    version = "0.9.0";
  };
  childprocess = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a61922kmvcxyj5l70fycapr87gz1dzzlkfpq85rfqk5vdh3d28p";
      type = "gem";
    };
    version = "0.9.0";
  };
  clamp = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jb6l4scp69xifhicb5sffdixqkw8wgkk9k2q57kh2y36x1px9az";
      type = "gem";
    };
    version = "1.0.1";
  };
  dotenv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13cis6bf06hmz744xrsl163p6gb78xcm8g8q4pcabsy5ywyv6kag";
      type = "gem";
    };
    version = "2.7.2";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j8pzj8raxbir5w5k6s7a042sb5k02pg0f8s4na1r5lan901j00p";
      type = "gem";
    };
    version = "1.10.0";
  };
  fpm = {
    dependencies = ["arr-pm" "backports" "cabin" "childprocess" "clamp" "ffi" "json" "pleaserun" "ruby-xz" "stud"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0khzsiqzswxpql6w2ws9dawb27zgv4nmgrjszydmm0xpv6h21jrm";
      type = "gem";
    };
    version = "1.11.0";
  };
  insist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bw3bdwns14mapbgb8cbjmr0amvwz8y72gyclq04xp43wpp5jrvg";
      type = "gem";
    };
    version = "1.0.0";
  };
  io-like = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nn0s2wmgxij3k760h3r8m1dgih5dmd9h4v1nn085yi824i5z6k";
      type = "gem";
    };
    version = "0.3.0";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qmj7fypgb9vag723w1a49qihxrcf5shzars106ynw2zk352gbv5";
      type = "gem";
    };
    version = "1.8.6";
  };
  mustache = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g5hplm0k06vwxwqzwn1mq5bd02yp0h3rym4zwzw26aqi7drcsl2";
      type = "gem";
    };
    version = "0.99.8";
  };
  pleaserun = {
    dependencies = ["cabin" "clamp" "dotenv" "insist" "mustache" "stud"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hgnrl67zkqaxmfkwbyscawj4wqjm7h8khpbj58s6iw54wp3408p";
      type = "gem";
    };
    version = "0.0.30";
  };
  ruby-xz = {
    dependencies = ["ffi" "io-like"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11bgpvvk0098ghvlxr4i713jmi2izychalgikwvdwmpb452r3ndw";
      type = "gem";
    };
    version = "0.2.3";
  };
  stud = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qpb57cbpm9rwgsygqxifca0zma87drnlacv49cqs2n5iyi6z8kb";
      type = "gem";
    };
    version = "0.0.23";
  };
}