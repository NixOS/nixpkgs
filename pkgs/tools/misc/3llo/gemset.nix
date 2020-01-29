{
  "3llo" = {
    dependencies = ["tty-prompt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "082g42lkkynnb2piz37ih696zm2ms63mz2q9rnfzjsd149ig39yy";
      type = "gem";
    };
    version = "0.3.0";
  };
  equatable = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fzx2ishipnp6c124ka6fiw5wk42s7c7gxid2c4c1mb55b30dglf";
      type = "gem";
    };
    version = "0.6.1";
  };
  necromancer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v9nhdkv6zrp7cn48xv7n2vjhsbslpvs0ha36mfkcd56cp27pavz";
      type = "gem";
    };
    version = "0.4.0";
  };
  pastel = {
    dependencies = ["equatable" "tty-color"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m43wk7gswwkl6lfxwlliqc9v1qp8arfygihyz91jc9icf270xzm";
      type = "gem";
    };
    version = "0.7.3";
  };
  tty-color = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zpp6zixkkchrc2lqnabrsy24pxikz2px87ggz5ph6355fs803da";
      type = "gem";
    };
    version = "0.5.0";
  };
  tty-cursor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07whfm8mnp7l49s2cm2qy1snhsqq3a90sqwb71gvym4hm2kx822a";
      type = "gem";
    };
    version = "0.4.0";
  };
  tty-prompt = {
    dependencies = ["necromancer" "pastel" "tty-cursor" "wisper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1026nyqhgmgxi2nmk8xk3hca07gy5rpisjs8y6w00wnw4f01kpv0";
      type = "gem";
    };
    version = "0.12.0";
  };
  wisper = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19bw0z1qw1dhv7gn9lad25hgbgpb1bkw8d599744xdfam158ms2s";
      type = "gem";
    };
    version = "1.6.1";
  };
}