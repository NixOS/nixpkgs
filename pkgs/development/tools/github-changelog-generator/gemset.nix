{
  activesupport = {
    dependencies = [
      "base64"
      "benchmark"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "logger"
      "minitest"
      "securerandom"
      "tzinfo"
      "uri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/VvHRkHCSsNUEFXCh5eJGY/0Kt7j45wpMyiboAiRLjc=";
      type = "gem";
    };
    version = "8.0.1";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
  async = {
    dependencies = [
      "console"
      "fiber-annotation"
      "io-event"
      "metrics"
      "traces"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YSyXNGlIpdv7a0rvEpdkFrAa70jsLUFnfvslyMMqUAY=";
      type = "gem";
    };
    version = "2.23.1";
  };
  async-http = {
    dependencies = [
      "async"
      "async-pool"
      "io-endpoint"
      "io-stream"
      "metrics"
      "protocol-http"
      "protocol-http1"
      "protocol-http2"
      "traces"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+1/w23u3ex7jUsrWJIi+TH93uidxN1eyZux3ZrQAGoA=";
      type = "gem";
    };
    version = "0.87.0";
  };
  async-http-faraday = {
    dependencies = [
      "async-http"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-81L4dEfpnK4fbQgwYHwhgRezFn0wSXY00stYQSwqI30=";
      type = "gem";
    };
    version = "0.21.0";
  };
  async-pool = {
    dependencies = [ "async" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tUL53sw0/T1tBURXZAi7edbS0qqcpGenW1RqxFdlAIo=";
      type = "gem";
    };
    version = "0.10.3";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  benchmark = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DxL4xJVUXjcQw+TwSA9j8GtMhCzJTOx/M6lW9RgOh0o=";
      type = "gem";
    };
    version = "0.4.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/x0IDFSGtacLfyBWpjkJqIwo9Iq6sGZWCanXav62Mw=";
      type = "gem";
    };
    version = "3.1.9";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gTs+N6ym3yoho7nx1Jf4y6skorlMqzJb/+Ze4PbL68Y=";
      type = "gem";
    };
    version = "1.3.5";
  };
  connection_pool = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IzuS+NOOA4wTSczqZd03cnJ9Zp1tLnH5iXyL9c1T6/w=";
      type = "gem";
    };
    version = "2.5.0";
  };
  console = {
    dependencies = [
      "fiber-annotation"
      "fiber-local"
      "json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5hx6AauetcwE+R5zIiWMzzYuLDkV027i5jsF8ii+9m0=";
      type = "gem";
    };
    version = "1.30.2";
  };
  drb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6dRyv3hfVYuWslNYuuEVZG2g2/1FEHrYWLC8DZNcs0A=";
      type = "gem";
    };
    version = "2.2.1";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FXM5wlx7i8tzn1zxIHywzv6PocZQJyZry8NMkMhLmtY=";
      type = "gem";
    };
    version = "2.12.2";
  };
  faraday-http-cache = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y/wSmoXhrYWAEwGJgyz1nn4RfZT+J3VH1h/FMfdolIM=";
      type = "gem";
    };
    version = "2.5.1";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ofHkzWos8hWZyCIVleJ1gtmTaBmXe71AiaYB8kxk5Uo=";
      type = "gem";
    };
    version = "3.4.0";
  };
  fiber-annotation = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-er+t8dEZ9QiGfUEDvyMcA1TQGcw5pXOJRd7C7a2vbAM=";
      type = "gem";
    };
    version = "0.2.0";
  };
  fiber-local = {
    dependencies = [ "fiber-storage" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yIX5TyEPubBXN95l1RETbqYC4AxRBZU3SKoPh5NInwY=";
      type = "gem";
    };
    version = "1.1.0";
  };
  fiber-storage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uAoyPx4LleebEcHU339lTb5RfBGjRMkPKkPexnulq38=";
      type = "gem";
    };
    version = "1.0.0";
  };
  github_changelog_generator = {
    dependencies = [
      "activesupport"
      "async"
      "async-http-faraday"
      "faraday-http-cache"
      "multi_json"
      "octokit"
      "rainbow"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IdLf5B1Qzzp//olndHednWHaaq8I05D43f8NrL34phE=";
      type = "gem";
    };
    version = "1.16.4";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zrpXP4E4/ywJFUJ/H8W99Ko6uK6IyM4lXrPs8KEaXQ8=";
      type = "gem";
    };
    version = "1.14.7";
  };
  io-endpoint = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Hn6Qu2g5RSiAdbQ6xQWroRRgooFgAja1+PvCEM+HjyU=";
      type = "gem";
    };
    version = "0.15.2";
  };
  io-event = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TCYrZhCtZDor516JITWspPpn7cZ9GUTArmtuXdc/T8E=";
      type = "gem";
    };
    version = "1.9.0";
  };
  io-stream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RSDwwUEt/SZOmrDTY+msqQpDVBhQIgtH8evVSZrS6W8=";
      type = "gem";
    };
    version = "0.6.1";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3ciK2Robrz8AOMF08lOvOwhtMNx02xfKQlm73pgvlNw=";
      type = "gem";
    };
    version = "2.10.1";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3WGNJOY3cVRycy5+7QLjPPvfVt6q0iXt0PH4nTgCQBc=";
      type = "gem";
    };
    version = "1.6.6";
  };
  metrics = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dcqrCCNdwrO7dEDgD2ToQmsjucqpR1XYHPk3H/+h4So=";
      type = "gem";
    };
    version = "0.12.2";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nPLK4lrE38kMmI68O5F/U8BUl4tnMnPaG9ILywd4+Uc=";
      type = "gem";
    };
    version = "5.25.4";
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
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-liGyDBN4mK+diQVWhIyTYDcWyrUW3CyJsBo4uJTiWfs=";
      type = "gem";
    };
    version = "0.6.0";
  };
  octokit = {
    dependencies = [
      "faraday"
      "sawyer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wCCS7oLc3+hNsODqYwpw0yvsxUJFpPC6z9IcAQ3wm5Y=";
      type = "gem";
    };
    version = "4.25.1";
  };
  protocol-hpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b+yiOLgHjaHNKVZ31vMGxgAa+S11/gZD0z5pVsvDrZE=";
      type = "gem";
    };
    version = "1.5.1";
  };
  protocol-http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tUGapg6nSRLbJljRZyLyPuNyKcpJex0UE/UPbAT1d7c=";
      type = "gem";
    };
    version = "0.49.0";
  };
  protocol-http1 = {
    dependencies = [ "protocol-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lJKWGkzKaQn+TSPWDiysNrj+ubTBKcRCj7zz+XPKw2o=";
      type = "gem";
    };
    version = "0.30.0";
  };
  protocol-http2 = {
    dependencies = [
      "protocol-hpack"
      "protocol-http"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kZZucIPnkum1T9WmKJGlkHjf6OHPAWLOWLOH24Esp2g=";
      type = "gem";
    };
    version = "0.22.1";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YdROHKtcu75bMQaEgc8Wl23Q3BtrB72VYX74xePgDG8=";
      type = "gem";
    };
    version = "6.0.1";
  };
  rainbow = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A5SRqjqJ9C76HW3sL8TmLt6W62rNleUvGtWBGCt5vGo=";
      type = "gem";
    };
    version = "3.1.1";
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
  sawyer = {
    dependencies = [
      "addressable"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+jpy1ipFJVF7GIV923iSaqs0JN4BKb5ncqjiuiQOeso=";
      type = "gem";
    };
    version = "0.9.2";
  };
  securerandom = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zFGT1BSkNBtuIl8MtERqzsqOUNXhiIdD+sFph2OOoLE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  traces = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0lR4NLcki7jI9PZTLGubqA744tYGjOFueHNXXXuALYE=";
      type = "gem";
    };
    version = "0.15.2";
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
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6fIkRgjuove8NX2VTGXJEM4DmcpeGKeikgesIth2cBE=";
      type = "gem";
    };
    version = "1.0.3";
  };
}
