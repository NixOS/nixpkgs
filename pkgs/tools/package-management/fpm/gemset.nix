{
  arr-pm = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fddw0vwdrr7v3a0lfqbmnd664j48a9psrjd3wh3k4i3flplizzx";
      type = "gem";
    };
    version = "0.0.12";
  };
  backports = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f3zcy0q88rw3clk0r7bai7sp4r253lndf0qmdgczq1ykbm219w3";
      type = "gem";
    };
    version = "3.24.1";
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
      sha256 = "1n0pi8x8ql5h1mijvm8lgn6bhq4xjb5a500p5r1krq4s6j9lg565";
      type = "gem";
    };
    version = "2.8.1";
  };
  fpm = {
    dependencies = ["arr-pm" "backports" "cabin" "clamp" "pleaserun" "rexml" "stud"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1grd0lb0mw1jvw6l8zqgh49m9gg2jxn98rifq2spzacwm11g7yqz";
      type = "gem";
    };
    version = "1.15.1";
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
      sha256 = "1aykf0l8327bqkkf5xd9jcglsib973zpy37cfnlf4j0vp0cdpn2d";
      type = "gem";
    };
    version = "0.0.32";
  };
  rexml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05i8518ay14kjbma550mv0jm8a6di8yp5phzrd8rj44z9qnrlrp0";
      type = "gem";
    };
    version = "3.2.6";
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
