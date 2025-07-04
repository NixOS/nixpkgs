{
  actionmailer = {
    dependencies = [
      "actionpack"
      "actionview"
      "activejob"
      "activesupport"
      "mail"
      "rails-dom-testing"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sCrlI8Msitdi1NuUHnbzwQjBBgMBMiR+56e4yGvHsh8=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionpack = {
    dependencies = [
      "actionview"
      "activesupport"
      "nokogiri"
      "racc"
      "rack"
      "rack-session"
      "rack-test"
      "rails-dom-testing"
      "rails-html-sanitizer"
      "useragent"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-F7IWCnvL1aVp0Gsa5UpLtczHuggV1z/1doEAp53B9zQ=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionview = {
    dependencies = [
      "activesupport"
      "builder"
      "erubi"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-afyIDPPYsbryGwSM97to8e7wh2D/gQTX1gpqG+izWaU=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionview_precompiler = {
    dependencies = [ "actionview" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-M7a9bsTBuFbgL99fZRLJ60qSrBwFRelBs+NUt9VA7Rw=";
      type = "gem";
    };
    version = "0.4.0";
  };
  active_model_serializers = {
    dependencies = [ "activemodel" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-c1Dj07allGu+wDMkHZCAE8yF/01YQjDmqgdCJVR8dUw=";
      type = "gem";
    };
    version = "0.8.4";
  };
  activejob = {
    dependencies = [
      "activesupport"
      "globalid"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8vlahXOzlKpPfCSEPwxKYGXAc6XGTW8V7NmNmMLCPls=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g5iGH57ixGcag1erOemzigRf1lb2aFo91YkMJBnb/a8=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
      "timeout"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eaMfccMtUThxfCEE4P8QX12CkiJHyFvcoUTycg5n+rk=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
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
    groups = [
      "default"
      "development"
      "test"
    ];
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
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
  annotate = {
    dependencies = [
      "activerecord"
      "rake"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mmG6ofsTiAqjqNn2JVOIm7Kjt5cPiLvGbTrHWlZ3gNM=";
      type = "gem";
    };
    version = "3.2.0";
  };
  ast = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HigCMuajN1TN5UK8XvhVILdNsqrHPsFKzvRTeERHzBI=";
      type = "gem";
    };
    version = "2.4.2";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8UNMwDqyJIdW6wLPpF6QDlmgYdf73Eqf2Cpd0j15bT8=";
      type = "gem";
    };
    version = "1.3.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZbNvVfbqjDvIjNDGPs+hwSIkOIRj/m3JoX+mqp+oHjo=";
      type = "gem";
    };
    version = "1.894.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "jmespath"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2jYy92xhueUtoXb/eSHj8shJ+7LpcgntPZfY9D3CFiE=";
      type = "gem";
    };
    version = "3.191.3";
  };
  aws-sdk-kms = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DntJqkTfWXCd9MVQDh5N9WE38M2S64RmJfRr1Yaufb0=";
      type = "gem";
    };
    version = "1.77.0";
  };
  aws-sdk-s3 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sdk-kms"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eizvCHxz6swqUHEkQK+XqePY6proB5S2qCeUz3xfTuk=";
      type = "gem";
    };
    version = "1.143.0";
  };
  aws-sdk-sns = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PHwiE/ufvgL8myNH1gSnU3vbeJgKTR19O2I6ao7wgeI=";
      type = "gem";
    };
    version = "1.72.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hN2ZdouRuTtj0djlPug3z9BqtAKBJ3KniZp4+fkRfLw=";
      type = "gem";
    };
    version = "1.8.0";
  };
  base64 = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  benchmark = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DxL4xJVUXjcQw+TwSA9j8GtMhCzJTOx/M6lW9RgOh0o=";
      type = "gem";
    };
    version = "0.4.0";
  };
  better_errors = {
    dependencies = [
      "erubi"
      "rack"
      "rouge"
    ];
    groups = [ "development" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-95jxusk/PndZJbf8skz/vPC7Yu4iEPU1DxYaa3X8CnM=";
      type = "gem";
    };
    version = "2.10.1";
  };
  bigdecimal = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/x0IDFSGtacLfyBWpjkJqIwo9Iq6sGZWCanXav62Mw=";
      type = "gem";
    };
    version = "3.1.9";
  };
  binding_of_caller = {
    dependencies = [ "debug_inspector" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KykCq/9CRt3PvE2ptpvEoBniKuswDC/2KJoXPUuQspo=";
      type = "gem";
    };
    version = "1.0.1";
  };
  bootsnap = {
    dependencies = [ "msgpack" ];
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rExCrzl/fuFVIYIBmNrv9UXkw2DSdyxgH73CwH2Sr1U=";
      type = "gem";
    };
    version = "1.18.4";
  };
  builder = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SXkY0vncpSj9ykuI2E5O9DhyVtmEuBVOnV0/5anIg18=";
      type = "gem";
    };
    version = "3.3.0";
  };
  bullet = {
    dependencies = [
      "activesupport"
      "uniform_notifier"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-d/Av3hmh3+8CjbQlNeWBsre0mQa+Wqk0SU8TZaR43k0=";
      type = "gem";
    };
    version = "8.0.0";
  };
  byebug = {
    groups = [
      "development"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JIWUTSuyEoPFk9Vi+a4QGb+AACFDzDolWq/9Tpz0o1s=";
      type = "gem";
    };
    version = "11.1.3";
  };
  capybara = {
    dependencies = [
      "addressable"
      "matrix"
      "mini_mime"
      "nokogiri"
      "rack"
      "rack-test"
      "regexp_parser"
      "xpath"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QtunIFeOocpl/XpB0WPdNoUCwZGARVj24PcbORBUru8=";
      type = "gem";
    };
    version = "3.40.0";
  };
  cbor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nuCX/FjZvF5AbREs0tThEsc1TsFvi2/zTkcyweRLTrc=";
      type = "gem";
    };
    version = "0.5.9.8";
  };
  certified = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qkzfDpDn7pb24M49quOeqo8EhhJODZLa9k0hBa65Bpw=";
      type = "gem";
    };
    version = "1.0.0";
  };
  cgi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q0nh4gJcnMc1NMUsk8/8Da/JPgqB7cCDDYUaOyxJpDA=";
      type = "gem";
    };
    version = "0.4.1";
  };
  chunky_png = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-idWzG1XAz02jz4mitOvDF42Kvoy68Rah26lWaFAv3P4=";
      type = "gem";
    };
    version = "1.4.0";
  };
  coderay = {
    groups = [
      "default"
      "development"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FMAGKRoRRL484FDzSoJbJ8CofwkWe3P5TR4en/HfUs=";
      type = "gem";
    };
    version = "1.1.3";
  };
  colored2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y+EDgYOXYofvxDA09cyhf7GAtN7vIH2ounjQUcvOKzc=";
      type = "gem";
    };
    version = "4.0.3";
  };
  concurrent-ruby = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gTs+N6ym3yoho7nx1Jf4y6skorlMqzJb/+Ze4PbL68Y=";
      type = "gem";
    };
    version = "1.3.5";
  };
  connection_pool = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IzuS+NOOA4wTSczqZd03cnJ9Zp1tLnH5iXyL9c1T6/w=";
      type = "gem";
    };
    version = "2.5.0";
  };
  cose = {
    dependencies = [
      "cbor"
      "openssl-signature_algorithm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1dTbzWsDXVE+3E4aubwQ6c4TtAEcluPRuP5eZBP9beU=";
      type = "gem";
    };
    version = "1.3.1";
  };
  cppjieba_rb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MZp6tXtuwoqNGyI0h+zRFEMvGTDXdA2y+ZwZkebI+q8=";
      type = "gem";
    };
    version = "0.4.4";
  };
  crack = {
    dependencies = [
      "bigdecimal"
      "rexml"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yDrv20KM3Htmx/KH5IjHlvBVwIOeblRf7CxwR3Q8Skk=";
      type = "gem";
    };
    version = "1.0.0";
  };
  crass = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FFgIqVuezsVYJmryBttKwjqHtEmdqx6VldhfwEr1F0=";
      type = "gem";
    };
    version = "1.0.6";
  };
  css_parser = {
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Z1P1uLSd1tXGqQ8wDVqCr4OZwZ27pW2IYIF0DscBRRg=";
      type = "gem";
    };
    version = "1.21.0";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b/DBNeZeSF0YZN3mwXA7YNNMyeGb7YRSg0oLKKUZvU4=";
      type = "gem";
    };
    version = "3.3.2";
  };
  date = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vyaOFO9xWACb/q7EC1+jxycZBuiLGW2VionUtAir5k8=";
      type = "gem";
    };
    version = "3.4.1";
  };
  debug_inspector = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-m9+gLuvD2hY4M+aomxVAhCMvV2YIfllXO3BSHHfqaKI=";
      type = "gem";
    };
    version = "1.2.0";
  };
  diff-lcs = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JzIj37QGhVSENtMrRzOqZzUXacfepiHafZ3UgT5j3f4=";
      type = "gem";
    };
    version = "1.5.1";
  };
  diffy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QmS559sA0c1Cb80y42Vld5FjztwjQKlbDm8CXnH5qqc=";
      type = "gem";
    };
    version = "3.4.3";
  };
  digest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+i5wkuxoP2XYL63eX/TKOzLiPuCxnx/BpeCZk60tOZE=";
      type = "gem";
    };
    version = "3.2.0";
  };
  digest-xxhash = {
    groups = [ "migrations" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qYnYMJwDxBNqS+qZgewKFGonUN5/Pft7ViSjA4qlmNc=";
      type = "gem";
    };
    version = "0.2.9";
  };
  discourse-fonts = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-p9JcE+3TMlrkABDKJ3Uw1p/HlSoFqnsv8HwdB0ErcqE=";
      type = "gem";
    };
    version = "0.0.18";
  };
  discourse-seed-fu = {
    dependencies = [
      "activerecord"
      "activesupport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T2HZXBHtVGCQRs0E6zpRtTHF+oY/qG0b6n10Jk5cdeQ=";
      type = "gem";
    };
    version = "2.3.12";
  };
  discourse_dev_assets = {
    dependencies = [
      "faker"
      "literate_randomizer"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oeZycv8kbb1tW0z2XNrqhrk3Hc4cqX9rafjUTYY1jVk=";
      type = "gem";
    };
    version = "0.0.4";
  };
  docile = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lhWb55m/pzzbchuEDpgCEm5OA9/CaGPbc2RyBMcn8h4=";
      type = "gem";
    };
    version = "1.4.1";
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
  dry-initializer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-N9WXmPkS3Aoe/hSk20qTBpiQB7MC3NXyXQoqIMFmxOM=";
      type = "gem";
    };
    version = "3.2.0";
  };
  email_reply_trimmer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BYQ/pe4aIDcjXx88h26SL2E+K0QG/qW7FCEtFwjWxSU=";
      type = "gem";
    };
    version = "0.2.0";
  };
  erubi = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oIIQOwiF28Xs8Rcv7eiX+evbdFpLl6Xo3GOVPbHuStk=";
      type = "gem";
    };
    version = "1.13.1";
  };
  excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jb1kUw8VLt2+9KK8whM7L9i/PsECNFeAukJ+m6xLpqo=";
      type = "gem";
    };
    version = "1.2.3";
  };
  execjs = {
    groups = [
      "assets"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-a8uL6PAFL/nTcLZdHAgPJAZlbhUEUqCr2xhaEzBIRQ0=";
      type = "gem";
    };
    version = "2.10.0";
  };
  exifr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-doN0zGtv83Q6y6V8HDUim92Ma5+8EoWVIEf8EhXEuJQ=";
      type = "gem";
    };
    version = "1.4.1";
  };
  extralite-bundle = {
    groups = [ "migrations" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-m4YTR18kQRgGX7YqtptS/MJzayZdOUj5Tu5wCQdR4/Q=";
      type = "gem";
    };
    version = "2.8.2";
  };
  fabrication = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LHnxDRuIA0ouvUfOd6y6ZoR/xGNlgcgoKzQIrcaOhao=";
      type = "gem";
    };
    version = "2.31.0";
  };
  faker = {
    dependencies = [ "i18n" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-h1TkuzvEVkHSdhIwYChqAB6l+kmktdqhYr+MAV/hVPM=";
      type = "gem";
    };
    version = "2.23.0";
  };
  fakeweb = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HsmWvhMCCgCzRkVgwJGAtCRHfGmPWfgu3yuZsWz6Cag=";
      type = "gem";
    };
    version = "1.3.0";
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
  faraday-retry = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QUb+0UVJwFgL8UWR/KQZpAcX3g3STyZ6jsLZpyhndgg=";
      type = "gem";
    };
    version = "2.2.1";
  };
  fast_blank = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jp/DBBT+1OZAO8SkkIHh6lOfi5Im5ZJ27R7676uqF+o=";
      type = "gem";
    };
    version = "1.0.1";
  };
  fastimage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I8Yp8fPn1hvPzAbCWz0kGLxr9B0uYV2/UTLA47Y+zOk=";
      type = "gem";
    };
    version = "2.3.1";
  };
  ffi = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jvaw29EQHm/8CdPKZAsqIYQMxScxrYp97Z+4nl+w/Dk=";
      type = "gem";
    };
    version = "1.17.1";
  };
  fspath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-taybr7l+LI+PnjA82Y69SEvnb+mqWIvE0BxtmeeMnXU=";
      type = "gem";
    };
    version = "3.1.2";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cL92cRhx+EPbunK+uGEyKaSUKdGGaChHb5ydbMwyfOk=";
      type = "gem";
    };
    version = "1.2.1";
  };
  google-protobuf = {
    dependencies = [
      "bigdecimal"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mlV2wAWfV9fgcQe9qCh6wU0MWccf6TmyYIVdP0a5tWY=";
      type = "gem";
    };
    version = "4.29.3";
  };
  guess_html_encoding = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yrZGi5RfOGc/xBrRR/u8iWk7PGw0sDsHHi7WaaYD4Jg=";
      type = "gem";
    };
    version = "0.0.11";
  };
  hana = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VCXbQtZR/qCIWYEcKdIERvFq8ZYwgWKJTbIIysXOmw0=";
      type = "gem";
    };
    version = "1.3.7";
  };
  hashdiff = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LDDu3tbtPc6EAdK1uZ5pY/5fFO2F5g3Z4zxUWkS3Gnc=";
      type = "gem";
    };
    version = "1.1.2";
  };
  hashie = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nWxOUfKjbUYWy8ijItYZoWLY9CgVp5JZYDn8lVlWA9o=";
      type = "gem";
    };
    version = "5.0.0";
  };
  highline = {
    dependencies = [ "reline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Z8vTTRn27xGn7h2C/6tdNt/Vs76GH0UPwXFscSX0u0o=";
      type = "gem";
    };
    version = "3.1.2";
  };
  htmlentities = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Elpzxsny0bYhALfDxAHjYkRBtmN2Kvp/5ChHZDWmc9o=";
      type = "gem";
    };
    version = "4.3.4";
  };
  http_accept_language = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AEPw1VoUjPRbYE290ZfLNkNxM+mQAWxoyJLUnb6jFjQ=";
      type = "gem";
    };
    version = "2.1.1";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zrpXP4E4/ywJFUJ/H8W99Ko6uK6IyM4lXrPs8KEaXQ8=";
      type = "gem";
    };
    version = "1.14.7";
  };
  image_optim = {
    dependencies = [
      "exifr"
      "fspath"
      "image_size"
      "in_threads"
      "progress"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-W//QiRJo6NGJ1G7kuFmZGFgbuhAy0kTmrOR3mkNHdsA=";
      type = "gem";
    };
    version = "0.31.4";
  };
  image_size = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xqWAUT/nSUfiXl0/CuoeM63Wwg99AAfvplUEMXt/Apo=";
      type = "gem";
    };
    version = "3.4.0";
  };
  in_threads = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kafmE40nncYy9ZuKmkCeRxSJSOKXwPackvmiR5oYIUk=";
      type = "gem";
    };
    version = "1.6.0";
  };
  io-console = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zWqfrLxphx1pssuLkm/G6n7wbwblBegaZPFKRw/d76I=";
      type = "gem";
    };
    version = "0.8.0";
  };
  irb = {
    dependencies = [
      "pp"
      "rdoc"
      "reline"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2bynRaxCB6i3KKUrmLdmypCbhv8aUEvN49b4yE+q6JA=";
      type = "gem";
    };
    version = "1.15.1";
  };
  iso8601 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KYwrFbe+X6laE3KBPTaiJXZWzY6QbfvB9ctAmFFCWqI=";
      type = "gem";
    };
    version = "0.13.0";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I413SlhyPWwJBJTIh5temRjBlIX36EDywcdTLPhOvLE=";
      type = "gem";
    };
    version = "1.6.2";
  };
  json = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0r3vRkQFL62RwXhdSCY3Vv4y/KwIuWoguxWEDpZVDRE=";
      type = "gem";
    };
    version = "2.9.1";
  };
  json-schema = {
    dependencies = [
      "addressable"
      "bigdecimal"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-s4Ka2bzfxQENihYMTCvruP7Y0F0i3mVkj2umRrBx+b8=";
      type = "gem";
    };
    version = "5.1.1";
  };
  json_schemer = {
    dependencies = [
      "bigdecimal"
      "hana"
      "regexp_parser"
      "simpleidn"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VsthF7tXSNklszrT9BW1E9QdJdC79X/mPAp4/wVZfCQ=";
      type = "gem";
    };
    version = "2.4.0";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5kJK4dgT9j52GgTWKE4Q5+xTHW9wGRf63NDZst6vHMU=";
      type = "gem";
    };
    version = "2.10.1";
  };
  kgio = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vaeiFGEVmYpbBxVOcI4KwCw43O5+eTwz4uFPYA/f/8Y=";
      type = "gem";
    };
    version = "2.11.4";
  };
  language_server-protocol = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xIRiZHhmT9E0gtgYCUfFCoWQSEsSWLmbeu2ztp34lmk=";
      type = "gem";
    };
    version = "3.17.0.4";
  };
  libv8-node = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dv9WlII7YULbn5u9FdpRWq4qK2AxRJzPpxVahKfcIc4=";
      type = "gem";
    };
    version = "22.7.0.4";
  };
  listen = {
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-255EJODlg0SAOFGXwTnLawrg7yjMEzEM/Ryng3fVnGc=";
      type = "gem";
    };
    version = "3.9.0";
  };
  literate_randomizer = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BQc8mzg5g7HtfibEC5Y0aOkbyG5mOz7v86SvkbhCF7E=";
      type = "gem";
    };
    version = "0.4.0";
  };
  logger = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GW7ex8xEtmz7QPl1XOEbOS8h95Z2lq8V0nTd5+3/AgM=";
      type = "gem";
    };
    version = "1.7.0";
  };
  lograge = {
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "request_store"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QjcadYI3dfFm9ydjn13c5z3RSUUqVfyUuQwwMhPcmuE=";
      type = "gem";
    };
    version = "0.14.0";
  };
  logstash-event = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iafcYPrGcHCl9gugdAnlQbCctYkGw5HpDLdLnyF0Z64=";
      type = "gem";
    };
    version = "1.2.02";
  };
  logster = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-w/kMudiWKt8B2fUS+4q7NEAJvUUeE03oy+mcWYu6u64=";
      type = "gem";
    };
    version = "2.20.0";
  };
  loofah = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YeanEIg6u4IQiH89yGjPPtZllMUJ2f9ph2Ie+mZR7h4=";
      type = "gem";
    };
    version = "2.24.0";
  };
  lru_redux = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7nHQzKsWTFHeFGwntICmizYx1bQpe4/+jtocct6Hr/s=";
      type = "gem";
    };
    version = "1.1.0";
  };
  lz4-ruby = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ARvl7iMM/dyDCNTi4LBTAMe8dVqIfeeZN3ymxbau3ok=";
      type = "gem";
    };
    version = "0.3.3";
  };
  mail = {
    dependencies = [
      "mini_mime"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Dufrc8rN1XHh4XLF7yaDKnumFcQimS29c/JwLW/ya0=";
      type = "gem";
    };
    version = "2.8.1";
  };
  matrix = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cQg8y9Z6FKQ7+njT5NwPS1A7nMGOW0sdaG3A+e98TMA=";
      type = "gem";
    };
    version = "0.4.2";
  };
  maxminddb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UJM75Dj77Z3Oq+9BY+q0GIS9iDDRcf249zm+52nEkH4=";
      type = "gem";
    };
    version = "0.1.22";
  };
  memory_profiler = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eaF995gKFAyDxGl4WQVAnTAnymFMQsCGCJ0Si4BaqPg=";
      type = "gem";
    };
    version = "1.1.0";
  };
  message_bus = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ew9tE1ixcYb+KuxiFe8SgzPEe3WGaYcMElCyaO+5uJc=";
      type = "gem";
    };
    version = "4.3.8";
  };
  messageformat-wrapper = {
    dependencies = [ "mini_racer" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7OqHlibkEtG8hBxFfaz8uxpiz4jKg1c+TqNLs3HxYLw=";
      type = "gem";
    };
    version = "1.1.0";
  };
  method_source = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GBMBycRbcxtHabyB6IYOcvkWGtfWbdmRA8mrhPVg9cU=";
      type = "gem";
    };
    version = "1.1.0";
  };
  mini_mime = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hoG34uQhXyoVn5QAtYFthenYxsa0kelqEnl+eY+LzO8=";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = [
      "default"
      "development"
      "generic_import"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DNfH+CTgEMBy4z9ovALYWgCutvzgW7SBnAPf08FAwok=";
      type = "gem";
    };
    version = "2.8.9";
  };
  mini_racer = {
    dependencies = [ "libv8-node" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UZ7VjzvosaSdPlS4MPWp+aDSs8YUZ19mTXWq1zIbCpk=";
      type = "gem";
    };
    version = "0.17.0.pre13";
  };
  mini_scheduler = {
    dependencies = [ "sidekiq" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0vCE842o12xYRKkvDWvQH8mYKotebHZ5ts9EyC2jNQM=";
      type = "gem";
    };
    version = "0.18.0";
  };
  mini_sql = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UpZjf2pK9btD4GeIA36aKWj/nI62WSi+/LqMtB9C1u4=";
      type = "gem";
    };
    version = "1.6.0";
  };
  mini_suffix = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jR0z+S9poiR8m30nFzI12pBHnZVc24Y7Y6f1OEO3Iuc=";
      type = "gem";
    };
    version = "0.3.3";
  };
  minio_runner = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8SLU9RhZshLB4RCqx4JQ44c17h2RXvBOo9nZu0SjC7A=";
      type = "gem";
    };
    version = "0.1.2";
  };
  minitest = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nPLK4lrE38kMmI68O5F/U8BUl4tnMnPaG9ILywd4+Uc=";
      type = "gem";
    };
    version = "5.25.4";
  };
  mocha = {
    dependencies = [ "ruby2_keywords" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j31TjV0+vHX8eIs9kvurkTqTp4Ri0qPOmdG93nr3+FE=";
      type = "gem";
    };
    version = "2.7.1";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/7BJefUeZAaCPAOr5Q4dosglxVo33uE4UYzdCdnTrqg=";
      type = "gem";
    };
    version = "1.7.5";
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
  multi_xml = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T84QDGivWI/5G4upCguz8EZvBskJ8hoy9JYgWRQLphs=";
      type = "gem";
    };
    version = "0.7.1";
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
  net-imap = {
    dependencies = [
      "date"
      "net-protocol"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-q+aokyxoJpgEsPC0maDRlyCY5+a4thp8UIsSfr3haCo=";
      type = "gem";
    };
    version = "0.5.5";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hItOmCATwVsvA4J5Imh2O3SMzpHJ6R42sPJ+0mQg3/M=";
      type = "gem";
    };
    version = "0.1.2";
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
  nio4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2V3uaOC7JRuP+QrDQjpRHjt4QSTl23/19IE6IgrnPKk=";
      type = "gem";
    };
    version = "2.7.4";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-k3kc+zMYb+B3654bimhVtWIeMo+B9WUzRXL6OYNm+L8=";
      type = "gem";
    };
    version = "1.18.2";
  };
  oauth = {
    dependencies = [
      "oauth-tty"
      "snaky_hash"
      "version_gem"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OJArfw9e2R6FjWNT9eHgaywWqKoP2RmEZx6rGh0c3es=";
      type = "gem";
    };
    version = "1.1.0";
  };
  oauth-tty = {
    dependencies = [ "version_gem" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NOJcMH2kUJ1N7sJm/zaQu/QuORNV9JYgHAKSaIYtixc=";
      type = "gem";
    };
    version = "1.0.5";
  };
  oauth2 = {
    dependencies = [
      "faraday"
      "jwt"
      "multi_json"
      "multi_xml"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Zzn8yIcryU9HawyuPovXilbYNksbebB1d5TCXhUtXBA=";
      type = "gem";
    };
    version = "1.4.11";
  };
  oj = {
    dependencies = [
      "bigdecimal"
      "ostruct"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b8XBU+3YinI+jU3TBo0/Zvqrm6KKBjtN5tHl0LZaMyQ=";
      type = "gem";
    };
    version = "3.16.9";
  };
  omniauth = {
    dependencies = [
      "hashie"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ApQCAbeixEs9xKSqLvXmuYPZAiUHyy3UYv3AQkmRyco=";
      type = "gem";
    };
    version = "1.9.2";
  };
  omniauth-facebook = {
    dependencies = [ "omniauth-oauth2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RArY3Z7cnr7B/WYHt4dmfIznDSlpwgMNfpykKica+FQ=";
      type = "gem";
    };
    version = "9.0.0";
  };
  omniauth-github = {
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-i0KumIuWfv5GcD6jcLMgxNTxad7mwzfGcv463FcDc3U=";
      type = "gem";
    };
    version = "1.4.0";
  };
  omniauth-google-oauth2 = {
    dependencies = [
      "jwt"
      "oauth2"
      "omniauth"
      "omniauth-oauth2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ikR0ra2KaK8Wgx+OgEcfhBxRlCTfDyUbKs5ebtbu9oI=";
      type = "gem";
    };
    version = "0.8.2";
  };
  omniauth-oauth = {
    dependencies = [
      "oauth"
      "omniauth"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jb8iyQI0KA+oJSAEkPA/8c59dvGk+9bIgsbFsWnFjag=";
      type = "gem";
    };
    version = "1.2.1";
  };
  omniauth-oauth2 = {
    dependencies = [
      "oauth2"
      "omniauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P1qPmfpy4PkdKr10dc65cqSuZ+1Z4EnzFMDButgfR0U=";
      type = "gem";
    };
    version = "1.7.3";
  };
  omniauth-twitter = {
    dependencies = [
      "omniauth-oauth"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xcxsd812d0X/qeu9X71pSj+pnR0tgqTX3vC/O2ExsmQ=";
      type = "gem";
    };
    version = "1.4.0";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/zpXP8l6sw9pSD/dyAAp+RZpvzZTKFm9GC0YNvRa7nk=";
      type = "gem";
    };
    version = "3.3.0";
  };
  openssl-signature_algorithm = {
    dependencies = [ "openssl" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o7QLXoJ2Fi1KblDHyXza8URvmyw5Rqb6LBRijgyVfoA=";
      type = "gem";
    };
    version = "1.3.0";
  };
  optimist = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Acnkgmu8rgSPls4Hnu9mJWSCkBawjx8b3AJLD7OYdxw=";
      type = "gem";
    };
    version = "3.2.0";
  };
  ostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CaP7fswfpAOfJUGMwFrpyCvVIEcsXGpvUV8D5JiMuBc=";
      type = "gem";
    };
    version = "0.6.1";
  };
  parallel = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2Gurt6K4FL6fS4FYe/C2zi2n1Flp+rJNiuS/K7TUx+8=";
      type = "gem";
    };
    version = "1.26.3";
  };
  parallel_tests = {
    dependencies = [ "parallel" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CVBjqlbR8N68rO+Qepp8D2uAxPCEwnHDeMv+BIHCM1o=";
      type = "gem";
    };
    version = "4.9.0";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dEkBF3Hj54gSl4WbhJ3iam9PzNUVvs6VIKh+fSEWEZs=";
      type = "gem";
    };
    version = "3.3.7.0";
  };
  pg = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dh7733O2ZRbwwm/L5lFdx1AMPwqhobhT/q4kVDPGT9w=";
      type = "gem";
    };
    version = "1.5.9";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lH7DEgxvkhlfjuiqJaeyxSl7sQbYO0G6oCmDaGV3tv8=";
      type = "gem";
    };
    version = "0.6.2";
  };
  prettier_print = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pyg4tfI/rP8h+QpUI83N2hnkJxCStB9Op/ULg5Keb/k=";
      type = "gem";
    };
    version = "1.2.1";
  };
  prettyprint = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K8nhVYGpR0IGSjzIsPudRarj0Dobqm74CSJiegdm8ZM=";
      type = "gem";
    };
    version = "0.2.0";
  };
  progress = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ng7TBt+kPWF06EfVY8cHNtyiSeIzPP7EsDhzBshs1XM=";
      type = "gem";
    };
    version = "3.6.0";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xP5U7+2sodNRKAtFuISa82MYRpb8rBxy4EFfm9rEM00=";
      type = "gem";
    };
    version = "0.14.2";
  };
  pry-byebug = {
    dependencies = [
      "byebug"
      "pry"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yPl1wyJVv9sp4VH1UyEwvmT/PQBC3IWNCQfoSRJVgfg=";
      type = "gem";
    };
    version = "3.10.1";
  };
  pry-rails = {
    dependencies = [ "pry" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pp4o4ko0110fYLzyQRkqVCU/j374piy6HnV1CpZTWT0=";
      type = "gem";
    };
    version = "0.3.11";
  };
  pry-stack_explorer = {
    dependencies = [
      "binding_of_caller"
      "pry"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-otvqm0fErQDPXBziFJn4EouRUInpABX3uvtulFO680A=";
      type = "gem";
    };
    version = "0.6.1";
  };
  psych = {
    dependencies = [
      "date"
      "stringio"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hKVLuVLRRgT+oi2Zk4NIgUZ4eC9YsSZI/N+k0vzoWe4=";
      type = "gem";
    };
    version = "5.2.3";
  };
  public_suffix = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YdROHKtcu75bMQaEgc8Wl23Q3BtrB72VYX74xePgDG8=";
      type = "gem";
    };
    version = "6.0.1";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8lwGhz6z1d5fCk68eDrMgaTM/lgMdgz+MjSXeYAYrYc=";
      type = "gem";
    };
    version = "6.6.0";
  };
  racc = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5KXuP48rpFYUpEmBFNbcfaHFGg8N2BDYkZBupx06pys=";
      type = "gem";
    };
    version = "2.2.10";
  };
  rack-mini-profiler = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K/DefVeV9UWB5FOySOQsxQ6NBSnvrHOChlOprSQHqAE=";
      type = "gem";
    };
    version = "3.3.1";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PHS6f8WQZkU9Ya+by6W2/nqbPatvRFQY07OR1eqO+/8=";
      type = "gem";
    };
    version = "3.2.0";
  };
  rack-session = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oCEV5UILTeA2g5uYEeP3ln1zRGpVS0KqRRBq8zWFHXY=";
      type = "gem";
    };
    version = "1.0.2";
  };
  rack-test = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AFo2aSwwasC0qTUDVe4ID9Cd3vEUil+LKsY2xyD1xGM=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rackup = {
    dependencies = [
      "rack"
      "webrick"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uoZgSiiYn+EEO/8g2BmzYJRMoIFWQGgS3KZ0KySzwkk=";
      type = "gem";
    };
    version = "1.0.1";
  };
  rails-dom-testing = {
    dependencies = [
      "activesupport"
      "minitest"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5RVxLkjfH2h6HXw4D9ewe4VY+qJkZEdNpkGDp0JvqTs=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rails-html-sanitizer = {
    dependencies = [
      "loofah"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NfziyoJC2od1yDtrqcG8qtZ1HZ63PBq6qEA0dauJpWA=";
      type = "gem";
    };
    version = "1.6.2";
  };
  rails_failover = {
    dependencies = [
      "activerecord"
      "concurrent-ruby"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QvcW7/di6e/+zDit01KVNHICSv+1DvYDRuq7EUh9fF8=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rails_multisite = {
    dependencies = [
      "activerecord"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-e9e4O4nikjddWVzHcUrgYeMFbn8pUpWvjEV1ticRhqo=";
      type = "gem";
    };
    version = "6.1.0";
  };
  railties = {
    dependencies = [
      "actionpack"
      "activesupport"
      "irb"
      "rackup"
      "rake"
      "thor"
      "zeitwerk"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4/Eb8RbdbQ2HRSKEPMxw7A+J+/7T6cLuSKR3jNBC/h8=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  rainbow = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A5SRqjqJ9C76HW3sL8TmLt6W62rNleUvGtWBGCt5vGo=";
      type = "gem";
    };
    version = "3.1.1";
  };
  raindrops = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qg65/2g08tniMrpoi9Scswvok7xaNFLnRyLJTB+rRzA=";
      type = "gem";
    };
    version = "0.20.1";
  };
  rake = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rss42uZdfXS2AgpKydSK/tjrgUnAQOzPBSO+yRkHBZ0=";
      type = "gem";
    };
    version = "13.2.1";
  };
  rb-fsevent = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q5ALly5zAdZXD2S4UKWqZ4M+59h7RY7pKAXVa3MYrv4=";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oKcARBI5sP8Y62XjhmI2zXhhPWufeP6h+axHqF5Hvm4=";
      type = "gem";
    };
    version = "0.11.1";
  };
  rbtrace = {
    dependencies = [
      "ffi"
      "msgpack"
      "optimist"
    ];
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6MumTUYr+4uhAte+Lsqsx4kkfVKsWH2AA1SdkJy5xdw=";
      type = "gem";
    };
    version = "0.5.1";
  };
  rchardet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JoiUhs3YOzeGUrr3YD9x2T5DG7Ebwje0zYxlFRr0pZA=";
      type = "gem";
    };
    version = "1.9.0";
  };
  rdoc = {
    dependencies = [ "psych" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vsZvubAZvmT3un0s0q7LKDo6Af7yOpWzPiNJxtGqAEA=";
      type = "gem";
    };
    version = "6.11.0";
  };
  redcarpet = {
    groups = [ "generic_import" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-itGInANV/0xHF0rxTt0G1i9FoybaHabooSHVm9zS6ek=";
      type = "gem";
    };
    version = "3.6.0";
  };
  redis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OH7ghmlP/8ljKq6x7+SnsWJ8p4O/NzMgNGqKIM2TMzo=";
      type = "gem";
    };
    version = "4.8.1";
  };
  redis-namespace = {
    dependencies = [ "redis" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6RoaorLYiLbeodSrjTnhrm+sNCYWH+udkd1cylmKIjk=";
      type = "gem";
    };
    version = "1.11.0";
  };
  regexp_parser = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y28N3eiHcs1kv/Hbv2jfZtN2BD/i5mqe93/LGwxUjGE=";
      type = "gem";
    };
    version = "2.10.0";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-V2IDddy+VuwJuscZK/t0YMcWu/AFTclDReyqVDjlOdI=";
      type = "gem";
    };
    version = "0.6.0";
  };
  request_store = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4bddU0ajFfRSJCpoyTfvjkiyFblFOnemwKzcopNMiMs=";
      type = "gem";
    };
    version = "1.7.0";
  };
  rexml = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  rinku = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-i2BnDjFD89srN++iYpcc42GewjCSBFSY758HfYKCjX0=";
      type = "gem";
    };
    version = "2.0.6";
  };
  rotp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ddQAh+Ze0NgCLDMFWmMGwcQA0cEiYZMlM7XWy82GiFQ=";
      type = "gem";
    };
    version = "6.3.0";
  };
  rouge = {
    groups = [
      "default"
      "development"
    ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ksgcbe5wGbvGYA1MLWQdcw1lwWWUFADr2SQlkGfmkN0=";
      type = "gem";
    };
    version = "4.5.1";
  };
  rqrcode = {
    dependencies = [
      "chunky_png"
      "rqrcode_core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I+6oi7RMfubWyrk1TQjCh/frzcYRLh/nvMLQENH/78E=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rqrcode_core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z0mJ3ILSTih3mEc4xO5WkwhiX+0qgQlg8bAtaNAwjRo=";
      type = "gem";
    };
    version = "1.2.0";
  };
  rrule = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vRI7TffrCGpjiNnEfo7KrTcIQz0RxXoZWlDU0N1OlhY=";
      type = "gem";
    };
    version = "0.6.0";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1JCRSsHVpaZKDhQAwdVN3SpQEyTXA7jP6D9Fgze6uZM=";
      type = "gem";
    };
    version = "3.13.0";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lPvabkc45Hjxx1MrfMJBJy/NyLnqwDqXM4sRIuRXMwA=";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Dmta9ZuQAUdpjqD/gEVsTy5pysQ5T705L70cpWH2bFg=";
      type = "gem";
    };
    version = "3.13.3";
  };
  rspec-html-matchers = {
    dependencies = [
      "nokogiri"
      "rspec"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1CS/6wEEiER4vimbZpW1bC0EMrt33Jzt7LUTjpHA6a4=";
      type = "gem";
    };
    version = "0.10.0";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IyczXe8OFmUyWpthfjr5riAnJ0HYCsVQM2MJp8Wave8=";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-multi-mock = {
    dependencies = [ "rspec" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KJRw8o0dnc3sq/cOmhT5ew3H49ugkN++TJjGTr1TeUw=";
      type = "gem";
    };
    version = "0.3.1";
  };
  rspec-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec-support"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lFhbacQIbKea+uXMjSxeMU9q0yqIySf5wGW5lZbj7kc=";
      type = "gem";
    };
    version = "7.1.0";
  };
  rspec-support = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zqOiRj/ZuEudzJaF79gOpwGqj3s97LOzznle1nc32+w=";
      type = "gem";
    };
    version = "3.13.2";
  };
  rss = {
    dependencies = [ "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tGI0wEVRuSUYD4vt/G9gRb8tmZhBf+2nLzAOeYAiZzc=";
      type = "gem";
    };
    version = "0.3.1";
  };
  rswag-specs = {
    dependencies = [
      "activesupport"
      "json-schema"
      "railties"
      "rspec-core"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-i6JghcQIsL0u0h3IAVyA9BfH00xjcgq3EzwlSbW9KpE=";
      type = "gem";
    };
    version = "2.16.0";
  };
  rtlcss = {
    dependencies = [ "mini_racer" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IT1aAL9hJn+Tp6UW1pnXfhzF85Z0OrszwB4/MkOnv2A=";
      type = "gem";
    };
    version = "0.2.1";
  };
  rubocop = {
    dependencies = [
      "json"
      "language_server-protocol"
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-09/R5ISjphnc92xqT7ppTNgzkh5P0lTREYRcJrzs/Po=";
      type = "gem";
    };
    version = "1.71.1";
  };
  rubocop-ast = {
    dependencies = [ "parser" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T99nkv5EOpoYrLEtvIIl0NZM0WVOQf7bMOecGO27Jq4=";
      type = "gem";
    };
    version = "1.38.0";
  };
  rubocop-capybara = {
    dependencies = [ "rubocop" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XSZO/di2xwgaPUiJ3s8UUaHPquwgTYFTTiNryCWygKs=";
      type = "gem";
    };
    version = "2.21.0";
  };
  rubocop-discourse = {
    dependencies = [
      "activesupport"
      "rubocop"
      "rubocop-capybara"
      "rubocop-factory_bot"
      "rubocop-rails"
      "rubocop-rspec"
      "rubocop-rspec_rails"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1Gt//rb9B5GB281UoEjvmOx/IRqwkT4pYrQEc0AwxI4=";
      type = "gem";
    };
    version = "3.9.3";
  };
  rubocop-factory_bot = {
    dependencies = [ "rubocop" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jeE81O3O5cqADyVRiBZ+zvjb/D0frp8Vc06dLnVTkqo=";
      type = "gem";
    };
    version = "2.26.1";
  };
  rubocop-rails = {
    dependencies = [
      "activesupport"
      "rack"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QcL89I1dYvSl9XTV8cl7uvTLqI7jZ5NsmLNCLQR7F6o=";
      type = "gem";
    };
    version = "2.29.1";
  };
  rubocop-rspec = {
    dependencies = [ "rubocop" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hyHBO2qMlTCnrEgc6pQjAi+Ub89yQovagon4tX5NSIU=";
      type = "gem";
    };
    version = "3.4.0";
  };
  rubocop-rspec_rails = {
    dependencies = [
      "rubocop"
      "rubocop-rspec"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iIES6D+dfvetI5fp1poLlhSkuuJPByw5mAShgPgMTEY=";
      type = "gem";
    };
    version = "2.30.0";
  };
  ruby-prof = {
    groups = [ "development" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AmOTRIz5L9JKkXOb9xzNK/6I/ooUAe6K/ElIoW1i6iQ=";
      type = "gem";
    };
    version = "1.7.1";
  };
  ruby-progressbar = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gPycR6m2QNaDTg3Hs8lMnfN/CMsHK3dh5KceIs/ymzM=";
      type = "gem";
    };
    version = "1.13.0";
  };
  ruby-readability = {
    dependencies = [
      "guess_html_encoding"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-c1HdyJrGLs3TUzassTE6wp3B2tl0XVnyUQnsIhXGWAw=";
      type = "gem";
    };
    version = "0.7.2";
  };
  ruby2_keywords = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/9E3QMVztzAc96LmH8hXsqjj06/zJUXW+DANi64Q4+8=";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyzip = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hXfIjtwf3ok165EGTFyxrvmtVJS5QM8Zx3Xugz4HVhU=";
      type = "gem";
    };
    version = "2.4.1";
  };
  sanitize = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jp0bnXMm5pMHcjr1ZD7AMv+GrWFucqOzbTAax1onOYQ=";
      type = "gem";
    };
    version = "7.0.0";
  };
  sass-embedded = {
    dependencies = [
      "google-protobuf"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oqatxM5pXs54D0A4jSB945blCR3dKHZ0QMeQekUBvto=";
      type = "gem";
    };
    version = "1.77.5";
  };
  sassc-embedded = {
    dependencies = [ "sass-embedded" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-e/9/1d8giwe9MAqiW5wFK9A2CHx7imLs/F0rFGJv7R4=";
      type = "gem";
    };
    version = "1.77.7";
  };
  securerandom = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zFGT1BSkNBtuIl8MtERqzsqOUNXhiIdD+sFph2OOoLE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  selenium-devtools = {
    dependencies = [ "selenium-webdriver" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OGLsHz6UCgMPSSs2kdEa81VEeJ+WH80GM8uJ5OpCUew=";
      type = "gem";
    };
    version = "0.135.0";
  };
  selenium-webdriver = {
    dependencies = [
      "base64"
      "logger"
      "rexml"
      "rubyzip"
      "websocket"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3bLYju4jzdtdap2t2QlCep5RY3GDOOEake7y++rRAOk=";
      type = "gem";
    };
    version = "4.31.0";
  };
  shoulda-matchers = {
    dependencies = [ "activesupport" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kFW7f0uzQhJfuGCAl5iFXGMOBe9edYN7MWi45u4WCLA=";
      type = "gem";
    };
    version = "6.4.0";
  };
  sidekiq = {
    dependencies = [
      "connection_pool"
      "rack"
      "redis"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tPk7IgTEIiDQtSanuODEm1+dqCwc4aBdK68ej3RMGX8=";
      type = "gem";
    };
    version = "6.5.12";
  };
  simplecov = {
    dependencies = [
      "docile"
      "simplecov-html"
      "simplecov_json_formatter"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/iYix4NP8juYBmuwqFQoSycppWmsZZ+CYh/CLvNiE6U=";
      type = "gem";
    };
    version = "0.22.0";
  };
  simplecov-html = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XasLfuYS5g6Yh61XaTgy/fRpW0wMhZ6upflcGHke8Qs=";
      type = "gem";
    };
    version = "0.13.1";
  };
  simplecov_json_formatter = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UpQY++jeFxOsKy1hKqPapW0xaXXTByRDmfpIOMYBtCg=";
      type = "gem";
    };
    version = "0.1.4";
  };
  simpleidn = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CM6W8D+hYFKGviJlG6D8nAstYnLJsnomC8iL4FsNLCk=";
      type = "gem";
    };
    version = "0.2.3";
  };
  snaky_hash = {
    dependencies = [
      "hashie"
      "version_gem"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Gsh+wVf8/npGDoIeDNSK4eb14+CCq1IPA/Maklnb3DE=";
      type = "gem";
    };
    version = "2.0.1";
  };
  sprockets = {
    dependencies = [
      "base64"
      "concurrent-ruby"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-csIPJWVI+KN/59tB2WvobDJi/dr06+nWnsgxc5T+04M=";
      type = "gem";
    };
    version = "3.7.5";
  };
  sprockets-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "sprockets"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qeiObOn4yRLTSapUAVCRZexCMmuvnpQqhd5LdtvEEZ4=";
      type = "gem";
    };
    version = "3.5.2";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "generic_import" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-h/oANuY2nD88/sp0mGXCsrY2SdOxeyI9GTmo7tSEGms=";
      type = "gem";
    };
    version = "2.5.0";
  };
  sshkey = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZVujUdbgGkjf5Z1lUwr4l1x3e4zFegYXcN4yKP8tEc0=";
      type = "gem";
    };
    version = "3.0.0";
  };
  stackprof = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-r/bShlbIUudM9jLMIEb4SQM9wd7f/ny4wDDWG1dF6Aw=";
      type = "gem";
    };
    version = "0.2.27";
  };
  stringio = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IE8YKPhc2znVfKxKvG3ESwRQWiI/ExWH8uIK43KboTE=";
      type = "gem";
    };
    version = "3.1.2";
  };
  syntax_tree = {
    dependencies = [ "prettier_print" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pQoBwkZgGvPCWO27axLkQ3PReWarO+vR9yJLO5lKND0=";
      type = "gem";
    };
    version = "6.2.0";
  };
  syntax_tree-disable_ternary = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7BPwv7uQli6IO5dIrLdD6bYsA6dtaPUDav1iSPo3sT0=";
      type = "gem";
    };
    version = "1.0.0";
  };
  test-prof = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GllRPtnTOh9coXwLidpOcPYKkcg+xi6ahz27mRQTU+8=";
      type = "gem";
    };
    version = "1.4.4";
  };
  thor = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7vApO54kFYzK16s4Oug1NLetTtmcCflvGmsDZVCrvto=";
      type = "gem";
    };
    version = "1.3.2";
  };
  timeout = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lQnwebK1X+QjbXljO9deNMHB5+P7S1bLX9ph+AoP4w4=";
      type = "gem";
    };
    version = "0.4.3";
  };
  trilogy = {
    groups = [ "migrations" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-otY7ZjumikdY4V0fmvsij10W78f+fOpoaZ4cEG72Bn8=";
      type = "gem";
    };
    version = "2.9.0";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ja+CjMd7z31jsOO9tsqkfiJy3Pr0+/5G+MOp3wh6gps=";
      type = "gem";
    };
    version = "2.0.6";
  };
  tzinfo-data = {
    dependencies = [ "tzinfo" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LYwaUBqT8myy4KUBnAfx3q73bpnMozCPW9zajkEf3ws=";
      type = "gem";
    };
    version = "1.2025.1";
  };
  uglifier = {
    dependencies = [ "execjs" ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ddQrgbEL/SHnpCf6ux1J/16nvaPEpQOd2yp40ZTG9ao=";
      type = "gem";
    };
    version = "4.2.1";
  };
  unf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5rzC4QHYDj+UWXU9t0fVkmqtoaqvYeYp6TNZ2ppbBKs=";
      type = "gem";
    };
    version = "0.2.0";
  };
  unicode-display_width = {
    dependencies = [ "unicode-emoji" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jK8q8cDy8H7InvnhjH2IwnkOIXxIK/x4qqZerdVBWsE=";
      type = "gem";
    };
    version = "3.1.4";
  };
  unicode-emoji = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LCxO9/NT5YCUlxJihaULIwVsxuYbZEM3ZKNe/2w2Uyo=";
      type = "gem";
    };
    version = "4.0.4";
  };
  unicorn = {
    dependencies = [
      "kgio"
      "raindrops"
    ];
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rd2Yet1MKwhMGICmg3OvQnl6cErXRB+v+bFLSYKqD8A=";
      type = "gem";
    };
    version = "6.1.0";
  };
  uniform_notifier = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mbOe5KCGTjtJ83W15YA+sm017W6xcZyWQHVzqHvE27U=";
      type = "gem";
    };
    version = "1.16.0";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-swNQTOt+WQV3H6f6FLZJZS+pSd8YtYgNac+xJJR5Hic=";
      type = "gem";
    };
    version = "1.0.2";
  };
  useragent = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cA5kE61LuVS7Y1R/oJjd33sOvnW0DMb5O41UJVsXOEQ=";
      type = "gem";
    };
    version = "0.16.11";
  };
  version_gem = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xpdSxtapRGrSGgMGYamIuhC6BcGtJJUyMy7MfvpTRiE=";
      type = "gem";
    };
    version = "1.1.4";
  };
  web-push = {
    dependencies = [
      "jwt"
      "openssl"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-W03S8rujvYlR2mQWSS/pIKbyA9FNMID5Q8XQHAzEsY0=";
      type = "gem";
    };
    version = "3.0.1";
  };
  webmock = {
    dependencies = [
      "addressable"
      "crack"
      "hashdiff"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vgE1f2/Hc2BjN8p587ozK31Sy+XCdYdnGrwFctvscSI=";
      type = "gem";
    };
    version = "3.24.0";
  };
  webrick = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tC08lPFm8/tz2H6bNZ3vm1g2xCb8i+rPOPIYSiGyqYk=";
      type = "gem";
    };
    version = "1.9.1";
  };
  websocket = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-t+enTiQQtehcJYWLJrMyLykWHjAJNfcKDg08NeBGJzc=";
      type = "gem";
    };
    version = "1.2.11";
  };
  xpath = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bf2nnZG7O5SblH7MWRnwQu8vOZuQQBPrPvbSDdOkCC4=";
      type = "gem";
    };
    version = "3.2.0";
  };
  yaml-lint = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-45YLFxdmrhhzOKFpgV6Z/hD8sNnCKxxTno1X4RQyTIo=";
      type = "gem";
    };
    version = "0.1.2";
  };
  yard = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pukQOZ545hP4C6mt2bp8OUsak18IPMy++CkDo9KiaZI=";
      type = "gem";
    };
    version = "0.9.37";
  };
  zeitwerk = {
    groups = [
      "default"
      "development"
      "migrations"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CUWYYFDkkHFAiVN4503x/ogqInHtCHzGxtawDUFaJ1Y=";
      type = "gem";
    };
    version = "2.7.1";
  };
}
