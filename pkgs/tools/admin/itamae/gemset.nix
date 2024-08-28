{
  ansi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14ims9zfal4gs2wpx2m5rd8zsrl2k794d359shkrsgg3fhr2a22l";
      type = "gem";
    };
    version = "1.5.0";
  };
  bcrypt_pbkdf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ndamfaivnkhc6hy0yqyk2gkwr6f3bz6216lh74hsiiyk3axz445";
      type = "gem";
    };
    version = "1.1.0";
  };
  docker-api = {
    dependencies = ["excon" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g7dbniz15b3l2sy6xh0j0998dr5jypf3xg3bsygp0108vv7waxy";
      type = "gem";
    };
    version = "2.2.0";
  };
  ed25519 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zb2dr2ihb1qiknn5iaj1ha1w9p7lj9yq5waasndlfadz225ajji";
      type = "gem";
    };
    version = "1.3.0";
  };
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j826kfvzn7nc5pv950n270r0sx1702k988ad11cdlav3dcxxw09";
      type = "gem";
    };
    version = "0.99.0";
  };
  hashie = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nh3arcrbz1rc1cr59qm53sdhqm137b258y8rcb4cvd3y98lwv4x";
      type = "gem";
    };
    version = "5.0.0";
  };
  itamae = {
    dependencies = ["ansi" "hashie" "schash" "specinfra" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zhx0cknipkjqp33qdxjlv7lcybgmh1jv9npp55vxaazd8cyfylx";
      type = "gem";
    };
    version = "1.14.1";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  net-scp = {
    dependencies = ["net-ssh"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1si2nq9l6jy5n2zw1q59a5gaji7v9vhy8qx08h4fg368906ysbdk";
      type = "gem";
    };
    version = "4.0.0";
  };
  net-ssh = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qp3i8bi7ji1np0530bp2p9zrrn6galvmbsivxwpkjdpjdyn19sr";
      type = "gem";
    };
    version = "7.0.1";
  };
  net-telnet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13qxznpwmc3hs51b76wqx2w29r158gzzh8719kv2gpi56844c8fx";
      type = "gem";
    };
    version = "0.1.1";
  };
  schash = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ia62xi56pkxy4y6wg3v5kwabjncyh3g78nqll4fs34zhdf7v8ad";
      type = "gem";
    };
    version = "0.1.2";
  };
  sfl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qm4hvhq9pszi9zs1cl9qgwx1n4wxq0af0hq9sbf6qihqd8rwwwr";
      type = "gem";
    };
    version = "2.3";
  };
  specinfra = {
    dependencies = ["net-scp" "net-ssh" "net-telnet" "sfl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qzhb7k66gi375ymnkwiy4alr7jw2c9ih7hv1lv5j5nda10hfb1p";
      type = "gem";
    };
    version = "2.84.1";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0inl77jh4ia03jw3iqm5ipr76ghal3hyjrd6r8zqsswwvi9j2xdi";
      type = "gem";
    };
    version = "1.2.1";
  };
}
