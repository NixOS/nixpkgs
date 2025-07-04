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
      hash = "sha256-Q2Ngkkz3WN+p1gqyKor+bai6v28ShtQIfwqcV2v4Moo=";
      type = "gem";
    };
    version = "7.2.2";
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
      hash = "sha256-TKeZUiS5mC78zum0SkRkpzIBxXedeMtaTZnsLzms8HE=";
      type = "gem";
    };
    version = "0.3.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qJRn7VpE+K4Bgkr0nLxXWHH6B4My6Pd+pCVyXB/+J74=";
      type = "gem";
    };
    version = "3.1.8";
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
      hash = "sha256-1KqSYzmwqGtbUFSgqMWAFj5vXcvf0PS7kWsaJXBzHDI=";
      type = "gem";
    };
    version = "1.3.4";
  };
  connection_pool = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-D0DPmXCR8fBP9m2mfqvWGp/g1JKLmjZFIoUyUS+rYvQ=";
      type = "gem";
    };
    version = "2.4.1";
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
      hash = "sha256-UWMOQ0JQeDEcBWynX5Ybs72hZBqzbkStTEVeCw5KIxw=";
      type = "gem";
    };
    version = "1.17.0";
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
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-td5PlYFlicW1w60TdwwK9Tm3UTHBWBNbPzu7p10M/KU=";
      type = "gem";
    };
    version = "2.0.4";
  };
  gh_inspector = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BMynFxuHFk4FOqQxR5cdO39QD8tYF3aYiGtIqfxKGTk=";
      type = "gem";
    };
    version = "1.1.3";
  };
  httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KVHkmRIURkw+khB+RkOFJ9IwSOY0867pHHGeC9+uvaY=";
      type = "gem";
    };
    version = "2.8.3";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3CKadPXRgfCZQt1gq11uZn9zksTugm81CW2zbR/jYUw=";
      type = "gem";
    };
    version = "1.14.6";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LZq6A68xZ0AejPjeUNrtW1rsW1piLxXEt84v2NSaBw8=";
      type = "gem";
    };
    version = "2.7.6";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OtlYftOUC/eJfqZKZzlxQVUj9PfWsixeOvUhlwVmllM=";
      type = "gem";
    };
    version = "1.6.1";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PbZ5WoBjTe8c+G/aedLYO1myXOXhhvpnX3PFZVidKtg=";
      type = "gem";
    };
    version = "5.25.1";
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
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lJaRZg+dBB11vmEbsqjS/VWcRnU33qwkH0CX2bXupXY=";
      type = "gem";
    };
    version = "1.1.0";
  };
  netrc = {
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
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1xh1uFKZ80Ht9H1E3wIS52WMvfNa62nO/bY/V68xN8k=";
      type = "gem";
    };
    version = "3.3.9";
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
  securerandom = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mPBFDA6kbS+aS22085Hb2D3AgElZLq2hVXOfQOA0G94=";
      type = "gem";
    };
    version = "0.3.1";
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
