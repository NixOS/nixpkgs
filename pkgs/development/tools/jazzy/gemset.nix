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
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hCvL+Kkpd/gPtHUGYaI3z13U/dRCBms8NeiK+0iGR/U=";
      type = "gem";
    };
    version = "7.2.2.1";
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
  algoliasearch = {
    dependencies = [
      "httpclient"
      "json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JsHN3zwuxL1gwUg4nkJwLJj9rIYogdxrB6TAuJ/+yFM=";
      type = "gem";
    };
    version = "1.27.5";
  };
  atomos = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fUOyLyRUo2us5VMtMHhbBt43ETmcsca/kyVz7aU2eJ8=";
      type = "gem";
    };
    version = "0.1.3";
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
  CFPropertyList = {
    dependencies = [
      "base64"
      "nkf"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xFchYUrKjV62+iFvLsKOw43hqUUF6XZqIOmHRUksPEw=";
      type = "gem";
    };
    version = "3.0.7";
  };
  claide = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bTxcCJ3ekE2WqjDnMwbQ1L1ESxrMubMSXOFKPAGD+C4=";
      type = "gem";
    };
    version = "1.1.0";
  };
  cocoapods = {
    dependencies = [
      "addressable"
      "claide"
      "cocoapods-core"
      "cocoapods-deintegrate"
      "cocoapods-downloader"
      "cocoapods-plugins"
      "cocoapods-search"
      "cocoapods-trunk"
      "cocoapods-try"
      "colored2"
      "escape"
      "fourflusher"
      "gh_inspector"
      "molinillo"
      "nap"
      "ruby-macho"
      "xcodeproj"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-D/HIYPMt89uLFt8JtY2hprsqEv5V9tXovplKdPrdHl4=";
      type = "gem";
    };
    version = "1.16.2";
  };
  cocoapods-core = {
    dependencies = [
      "activesupport"
      "addressable"
      "algoliasearch"
      "concurrent-ruby"
      "fuzzy_match"
      "nap"
      "netrc"
      "public_suffix"
      "typhoeus"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-S7G1xCBpHmDPNvoifexrxIwJbDTJe7eqUS6n8yRvwSs=";
      type = "gem";
    };
    version = "1.16.2";
  };
  cocoapods-deintegrate = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UXwqRI71Y6/pm252aHBMJ/XengJxWojuneaXTcGz9qI=";
      type = "gem";
    };
    version = "1.0.5";
  };
  cocoapods-downloader = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-u26+Gzlm3EBV3lT3oot3NIWsck/fV12b7iIS0jXnttE=";
      type = "gem";
    };
    version = "2.1";
  };
  cocoapods-plugins = {
    dependencies = [ "nap" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cl0XzpC1L4Yuc0dmI/2RRBtEMLdC2KBxAAgx77RAypo=";
      type = "gem";
    };
    version = "1.0.0";
  };
  cocoapods-search = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GxM7DmcZ7UOb2EDoShgozKRkJatzoR7/XglsOy3wVYk=";
      type = "gem";
    };
    version = "1.0.1";
  };
  cocoapods-trunk = {
    dependencies = [
      "nap"
      "netrc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-X1vajBcq/q1I+i1DpxjPU0sTE8NnuhGUzr3rm/7p7TE=";
      type = "gem";
    };
    version = "1.6.0";
  };
  cocoapods-try = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FFuUbG53R+0DAdl1FlFXlRFT0nRp5rJ2PIPiXIS53v4=";
      type = "gem";
    };
    version = "1.2.0";
  };
  colored2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sTwr1+6uLPc1amJQHTmOcv3nh4C9Jq7GqXlXgpPCi0o=";
      type = "gem";
    };
    version = "3.1.2";
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
  escape = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5J9EritPR8ajq9VErnf+QVeAJ5TjLxm453PLxNzsQWk=";
      type = "gem";
    };
    version = "0.0.4";
  };
  ethon = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-u6DaHOqKw+H1zdfLHLX8eNesViwzc28Y8MPrK2MFPZ4=";
      type = "gem";
    };
    version = "0.16.0";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jvaw29EQHm/8CdPKZAsqIYQMxScxrYp97Z+4nl+w/Dk=";
      type = "gem";
    };
    version = "1.17.1";
  };
  fourflusher = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Gz3mHHx5G2pOZPMeNxnrJSA9FRdGu1GaApK/8QZcyqk=";
      type = "gem";
    };
    version = "2.3.1";
  };
  fuzzy_match = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-td5PlYFlicW1w60TdwwK9Tm3UTHBWBNbPzu7p10M/KU=";
      type = "gem";
    };
    version = "2.0.4";
  };
  gh_inspector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BMynFxuHFk4FOqQxR5cdO39QD8tYF3aYiGtIqfxKGTk=";
      type = "gem";
    };
    version = "1.1.3";
  };
  httpclient = {
    dependencies = [ "mutex_m" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-S2RZWOSUsvhsL4ovMEyVm6onOjEOd6KTHduYbYPkmMg=";
      type = "gem";
    };
    version = "2.9.0";
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
  jazzy = {
    dependencies = [
      "cocoapods"
      "mustache"
      "open4"
      "redcarpet"
      "rexml"
      "rouge"
      "sassc"
      "sqlite3"
      "xcinvoke"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9VYEAF/Z0amQbkCz8YtiwGfNsWO9BkGwUsTH8IJ3Zuc=";
      type = "gem";
    };
    version = "0.15.3";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NODq2pMCKyoKM0W7C179226f9b58SOQJz7VP+KNqiwY=";
      type = "gem";
    };
    version = "2.10.2";
  };
  liferaft = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Yx7BPFLS5ihR1Odh9f9eCQ7yZDf5LcRR7/o/gvpaWs0=";
      type = "gem";
    };
    version = "0.0.6";
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
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkcTbNrATOgXULtsCXM7N4lb8GliVU5LQFbXgWjXCnU=";
      type = "gem";
    };
    version = "2.8.8";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ORtsbLQ6SAK/t8k68evirGaiECk/Sj+32zby/H3Cx1Y=";
      type = "gem";
    };
    version = "5.25.5";
  };
  molinillo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-77/ycWMk4qMLzNProf86c19NXVP/3bxqLzLAypQzBF0=";
      type = "gem";
    };
    version = "0.8.0";
  };
  mustache = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kIkf3VC1ORnKM0yMEDHq2hIV540ibVeV5SPWEjonF9A=";
      type = "gem";
    };
    version = "1.1.1";
  };
  mutex_m = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z8sErBa2nEgTd3Ai/c7aJOn3mOSAkqK4F+tMCngrB1E=";
      type = "gem";
    };
    version = "0.3.0";
  };
  nanaimo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+vBpVRurF/FRacH3ShxzwiBlfnG26QCRmJehDZkdByM=";
      type = "gem";
    };
    version = "0.4.0";
  };
  nap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lJaRZg+dBB11vmEbsqjS/VWcRnU33qwkH0CX2bXupXY=";
      type = "gem";
    };
    version = "1.1.0";
  };
  netrc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3hzjPajJmrHZeHFybLp1FRET8RcUa+y+RaqFyz2r7j8=";
      type = "gem";
    };
    version = "0.11.0";
  };
  nkf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+8FRvaAlRR9if6/fyz9PE9CyKuEfWMbTopOcdsX18SY=";
      type = "gem";
    };
    version = "0.2.0";
  };
  open4 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-od8DcxBiTsweodgSZLEcg+ltDDwcYEMQjTfTltzQ9LE=";
      type = "gem";
    };
    version = "1.3.4";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-i+Fh4kIfjUWwCYwELAZIZ4lzHqk9w6iW0wVU7ji1c7g=";
      type = "gem";
    };
    version = "4.0.7";
  };
  redcarpet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1ESRDmqlVIDGvNwM2wV2JuijLAVMKeeT+mQrovFV9EU=";
      type = "gem";
    };
    version = "3.6.1";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ksgcbe5wGbvGYA1MLWQdcw1lwWWUFADr2SQlkGfmkN0=";
      type = "gem";
    };
    version = "4.5.1";
  };
  ruby-macho = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kHXlLg+ScLVSqQsk/MYhmtFJsNFerhvDZOzQrImE9ck=";
      type = "gem";
    };
    version = "2.5.1";
  };
  sassc = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TGCisKOzZoXIO4DVeJQBwvZ4wWUuMogxWhVR2BHZ+D4=";
      type = "gem";
    };
    version = "2.4.0";
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
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+nf2PHCVSPRtTptrtFzaUqo4gaoSzIWZETJ1jolocBw=";
      type = "gem";
    };
    version = "1.7.3";
  };
  typhoeus = {
    dependencies = [ "ethon" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HBfbg2S9RaswLcYeRgFzw+aYNYlr6Io98HwgbVxV73w=";
      type = "gem";
    };
    version = "1.4.1";
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
  xcinvoke = {
    dependencies = [ "liferaft" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Z+k2pa+mRlnFhofD0xaUfih9zdtjdpy5d4CJvvnB/po=";
      type = "gem";
    };
    version = "0.3.0";
  };
  xcodeproj = {
    dependencies = [
      "CFPropertyList"
      "atomos"
      "claide"
      "colored2"
      "nanaimo"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jMenO0UFwifeqwRNzhGO3nhwQccCvEdjaFai5Wb4VNM=";
      type = "gem";
    };
    version = "1.27.0";
  };
}
