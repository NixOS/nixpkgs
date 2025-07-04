{
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Xs0MG5ICUGb7nJ4nSeLY0GTp03EI5u9A89qJeVIS438=";
      type = "gem";
    };
    version = "6.1.7.7";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1mJhiXY/6f2wIWn5qhFP39z3QZbiLtWoGFPwnf2r/mM=";
      type = "gem";
    };
    version = "6.1.7.7";
  };
  activesupport = {
    dependencies = [
      "concurrent-ruby"
      "i18n"
      "minitest"
      "tzinfo"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-97mGHW5/xelzEWiPgr1lC7jzgqZ+HuaQb2GBesFKUWQ=";
      type = "gem";
    };
    version = "6.1.7.7";
  };
  bcrypt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hBD4x7PtVKPADNJFa/E5F9aVEX8DMhjiSDsuQLB4QJk=";
      type = "gem";
    };
    version = "3.1.20";
  };
  charlock_holmes = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tJ6KEc4ZIeLFtlURu4ZK5RcgzpvRwzbM8OiebIrmLbA=";
      type = "gem";
    };
    version = "0.7.9";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-w2nx0IdbQilf4Pq8MhBl88/quMMsUmwBtrBa8e/IsM4=";
      type = "gem";
    };
    version = "1.3.1";
  };
  daemons = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j8dtdvrsZp/rXkVdcvNb1MRtxnNeKMQgr7gi+sH6mh0=";
      type = "gem";
    };
    version = "1.4.1";
  };
  eventmachine = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mUAW5CqgQUd7qc/0XL5Q3iBH8l3UGOugA+hPDRZWCXI=";
      type = "gem";
    };
    version = "1.2.7";
  };
  gpgme = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-U+zNcEKrtP1cePMLye0HWxMl5kUOqyB/L2oefiiuO2Q=";
      type = "gem";
    };
    version = "2.0.24";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jty8BeNktX4nq0MBSLM3e8QTmH00zAQjNicdj0Lp0bk=";
      type = "gem";
    };
    version = "1.14.5";
  };
  mail = {
    dependencies = [ "mini_mime" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Co9SJ91ELkNjqo/arqtcDjPHWY8347mbQIUoL35nAM=";
      type = "gem";
    };
    version = "2.7.1";
  };
  mail-gpg = {
    dependencies = [
      "gpgme"
      "mail"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0nk2NG6Ll72xzLMXuHGBoZ2xjJv7bj2fOp4pi6oZ6ec=";
      type = "gem";
    };
    version = "0.4.4";
  };
  mini_mime = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hoG34uQhXyoVn5QAtYFthenYxsa0kelqEnl+eY+LzO8=";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Tiqwm5JJBv1CwLbrcoFttqQ10EBOnL3MXXIsEztJOZE=";
      type = "gem";
    };
    version = "2.8.6";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8ej41v/Zb7FzOc5QdovLvbut/1Bzy5WD0IRAOHener4=";
      type = "gem";
    };
    version = "5.23.1";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H9BBOLbkqQAX6NG4BMA5AxOZhm/z+6u3girqNnx4YV0=";
      type = "gem";
    };
    version = "1.15.0";
  };
  mustermann = {
    dependencies = [ "ruby2_keywords" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y+ZRtsA55M76Y1uAhzmP9Z10+DWRBkkmzGLTesTH4FQ=";
      type = "gem";
    };
    version = "2.0.2";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qnPgy6ahJTad6YN7jY74KmGEk2DroFIZAOLDcTqhYqg=";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-X8BBXm6hzAs9/qcnBDjsIrJ4yo1SSYajrk5a6NCHtCo=";
      type = "gem";
    };
    version = "0.5.0";
  };
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/WMBqXocHpVeaPhchh/LHN5hRaMsUy4eoyGnL/jMQEI=";
      type = "gem";
    };
    version = "2.2.9";
  };
  rack-protection = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gmY9zqrP+t0xopNv3q1Ei4/Y4ySJHVLDiySC+qLO0bQ=";
      type = "gem";
    };
    version = "2.2.4";
  };
  rake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rss42uZdfXS2AgpKydSK/tjrgUnAQOzPBSO+yRkHBZ0=";
      type = "gem";
    };
    version = "13.2.1";
  };
  ruby2_keywords = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/9E3QMVztzAc96LmH8hXsqjj06/zJUXW+DANi64Q4+8=";
      type = "gem";
    };
    version = "0.0.5";
  };
  schleuder = {
    dependencies = [
      "activerecord"
      "bcrypt"
      "charlock_holmes"
      "gpgme"
      "mail"
      "mail-gpg"
      "rake"
      "sinatra"
      "sinatra-contrib"
      "sqlite3"
      "thin"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-naPNKhL0sKr/8Y/fP0NddLieVfOryNGlmrhsAciJtVM=";
      type = "gem";
    };
    version = "4.0.3";
  };
  sinatra = {
    dependencies = [
      "mustermann"
      "rack"
      "rack-protection"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PjHp9//InOP913cMmkGDFQ12tr3McyLPOPhDA9MBbHI=";
      type = "gem";
    };
    version = "2.2.4";
  };
  sinatra-contrib = {
    dependencies = [
      "multi_json"
      "mustermann"
      "rack-protection"
      "sinatra"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y8zOCEgwEuCpZt17xjIR4Qi/FL50r0iP6uP2/8cMzGg=";
      type = "gem";
    };
    version = "2.2.4";
  };
  sqlite3 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XYHKwTQdQyYM6Wc+FG9B0o2w0J7GfnajXugIloZRPPw=";
      type = "gem";
    };
    version = "1.4.4";
  };
  thin = {
    dependencies = [
      "daemons"
      "eventmachine"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HFUlGrpb7nz2k26hiwSPTTx074EKpeaQbPbt/w324SE=";
      type = "gem";
    };
    version = "1.8.2";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sbwhf+KPavNMbmCwA+NAXCdZWlVokHfYLp5h1NO1Gfo=";
      type = "gem";
    };
    version = "0.20.3";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gt2QPWEhPGNnnSjkBO6OENGw/fUnDxrQiY7DFMw+dFw=";
      type = "gem";
    };
    version = "2.3.0";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bx9O3UvKKM/6WVAXM6lCFUB8aWC9IQczHwKA1Kveu5o=";
      type = "gem";
    };
    version = "0.4.1";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ja+CjMd7z31jsOO9tsqkfiJy3Pr0+/5G+MOp3wh6gps=";
      type = "gem";
    };
    version = "2.0.6";
  };
  zeitwerk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-suaGIrqVaAo1dDDInhd31uZ5bWPHwC6HkMw49MM4Is8=";
      type = "gem";
    };
    version = "2.6.15";
  };
}
