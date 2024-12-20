{
  activesupport = {
    dependencies = [
      "concurrent-ruby"
      "i18n"
      "minitest"
      "tzinfo"
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
      sha256 = "02sh4q8izyfdnh7z2nj5mn5sklfvqgx9rrag5j3l51y8aqkrg2yk";
      type = "gem";
    };
    version = "6.0.3.2";
  };
  anystyle = {
    dependencies = [
      "anystyle-data"
      "bibtex-ruby"
      "gli"
      "namae"
      "wapiti"
    ];
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "maglev";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
        version = "1.8";
      }
      {
        engine = "rbx";
        version = "1.9";
      }
      {
        engine = "rbx";
        version = "2.0";
      }
      {
        engine = "rbx";
        version = "2.1";
      }
      {
        engine = "rbx";
        version = "2.2";
      }
      {
        engine = "rbx";
        version = "2.3";
      }
      {
        engine = "rbx";
        version = "2.4";
      }
      {
        engine = "rbx";
        version = "2.5";
      }
      {
        engine = "rbx";
        version = "2.6";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
    ];
    source = {
      path = ./.;
      type = "path";
    };
    version = "1.3.10";
  };
  anystyle-data = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "maglev";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
        version = "1.8";
      }
      {
        engine = "rbx";
        version = "1.9";
      }
      {
        engine = "rbx";
        version = "2.0";
      }
      {
        engine = "rbx";
        version = "2.1";
      }
      {
        engine = "rbx";
        version = "2.2";
      }
      {
        engine = "rbx";
        version = "2.3";
      }
      {
        engine = "rbx";
        version = "2.4";
      }
      {
        engine = "rbx";
        version = "2.5";
      }
      {
        engine = "rbx";
        version = "2.6";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ry6836mq48d85hjcfp7xiw0yk3ivpiwjvmdwv5jag30ijfyaccy";
      type = "gem";
    };
    version = "1.2.0";
  };
  bibtex-ruby = {
    dependencies = [ "latex-decode" ];
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
        engine = "maglev";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
        version = "1.8";
      }
      {
        engine = "rbx";
        version = "1.9";
      }
      {
        engine = "rbx";
        version = "2.0";
      }
      {
        engine = "rbx";
        version = "2.1";
      }
      {
        engine = "rbx";
        version = "2.2";
      }
      {
        engine = "rbx";
        version = "2.3";
      }
      {
        engine = "rbx";
        version = "2.4";
      }
      {
        engine = "rbx";
        version = "2.5";
      }
      {
        engine = "rbx";
        version = "2.6";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00zwmmmjrbrxhajdvn1d4rnv2qw00arcj021cwyx3hl6dsv22l2w";
      type = "gem";
    };
    version = "5.1.4";
  };
  builder = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "maglev";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
        version = "1.8";
      }
      {
        engine = "rbx";
        version = "1.9";
      }
      {
        engine = "rbx";
        version = "2.0";
      }
      {
        engine = "rbx";
        version = "2.1";
      }
      {
        engine = "rbx";
        version = "2.2";
      }
      {
        engine = "rbx";
        version = "2.3";
      }
      {
        engine = "rbx";
        version = "2.4";
      }
      {
        engine = "rbx";
        version = "2.5";
      }
      {
        engine = "rbx";
        version = "2.6";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      type = "gem";
    };
    version = "3.2.4";
  };
  byebug = {
    groups = [ "debug" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nx3yjf4xzdgb8jkmk2344081gqr22pgjqnmjg2q64mj5d6r9194";
      type = "gem";
    };
    version = "11.1.3";
  };
  citeproc = {
    dependencies = [ "namae" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13vl5sjmksk5a8kjcqnjxh7kn9gn1n4f9p1rvqfgsfhs54p0m6l2";
      type = "gem";
    };
    version = "1.0.10";
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
      sha256 = "1vnxrbhi7cq3p4y2v9iwd10v1c7l15is4var14hwnb2jip4fyjzz";
      type = "gem";
    };
    version = "1.1.7";
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
      sha256 = "0m925b8xc6kbpnif9dldna24q1szg4mk0fvszrki837pfn46afmz";
      type = "gem";
    };
    version = "1.4.4";
  };
  docile = {
    groups = [
      "coverage"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qrwiyagxzl8zlx3dafb0ay8l14ib7imb2rsmx70i5cp420v8gif";
      type = "gem";
    };
    version = "1.3.2";
  };
  edtf = {
    dependencies = [ "activesupport" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xknzamagsx68iq7zdiswr077sxirig77yggbcsw51m8365ajzpc";
      type = "gem";
    };
    version = "3.0.5";
  };
  gli = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "maglev";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
        version = "1.8";
      }
      {
        engine = "rbx";
        version = "1.9";
      }
      {
        engine = "rbx";
        version = "2.0";
      }
      {
        engine = "rbx";
        version = "2.1";
      }
      {
        engine = "rbx";
        version = "2.2";
      }
      {
        engine = "rbx";
        version = "2.3";
      }
      {
        engine = "rbx";
        version = "2.4";
      }
      {
        engine = "rbx";
        version = "2.5";
      }
      {
        engine = "rbx";
        version = "2.6";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q598mvl20isn3ja1ya0p72svmqwx3m6fjp5slnv0b2c5mh0ahvv";
      type = "gem";
    };
    version = "2.19.2";
  };
  gnuplot = {
    groups = [ "profile" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cvb84lahhy6qxkkgg0pfk9b85qrb1by2p3jlpqgczl6am58vhnj";
      type = "gem";
    };
    version = "2.6.2";
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
      sha256 = "153sx77p16vawrs4qpkv7qlzf9v5fks4g7xqcj1dwk40i6g7rfzk";
      type = "gem";
    };
    version = "1.8.5";
  };
  language_detector = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "89102790194150b3a8110ce691f9989b8ce70f8d";
      sha256 = "0wxs9i0wqmwysrz1c1i85i4f670m217y12rj5slcmd1y4ylsmvyi";
      type = "git";
      url = "https://github.com/feedbackmine/language_detector.git";
    };
    version = "0.1.2";
  };
  latex-decode = {
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
        engine = "maglev";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
        version = "1.8";
      }
      {
        engine = "rbx";
        version = "1.9";
      }
      {
        engine = "rbx";
        version = "2.0";
      }
      {
        engine = "rbx";
        version = "2.1";
      }
      {
        engine = "rbx";
        version = "2.2";
      }
      {
        engine = "rbx";
        version = "2.3";
      }
      {
        engine = "rbx";
        version = "2.4";
      }
      {
        engine = "rbx";
        version = "2.5";
      }
      {
        engine = "rbx";
        version = "2.6";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dqanr69as05vdyp9gx9737w3g44rhyk7x96bh9x01fnf1yalyzd";
      type = "gem";
    };
    version = "0.3.1";
  };
  lmdb = {
    groups = [ "extra" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qk2ycgyyk052dvbgik35mr4n9im4k1j6v7anbjqhx52y5f07sfg";
      type = "gem";
    };
    version = "0.5.3";
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
      sha256 = "09bz9nsznxgaf06cx3b5z71glgl0hdw469gqx3w7bqijgrb55p5g";
      type = "gem";
    };
    version = "5.14.1";
  };
  namae = {
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
        engine = "maglev";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
        version = "1.8";
      }
      {
        engine = "rbx";
        version = "1.9";
      }
      {
        engine = "rbx";
        version = "2.0";
      }
      {
        engine = "rbx";
        version = "2.1";
      }
      {
        engine = "rbx";
        version = "2.2";
      }
      {
        engine = "rbx";
        version = "2.3";
      }
      {
        engine = "rbx";
        version = "2.4";
      }
      {
        engine = "rbx";
        version = "2.5";
      }
      {
        engine = "rbx";
        version = "2.6";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00w0dgvmdy8lw2b5q9zvhqd5k98a192vdmka96qngi9cvnsh5snw";
      type = "gem";
    };
    version = "1.0.1";
  };
  rake = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w6qza25bq1s825faaglkx1k6d59aiyjjk3yw3ip5sb463mhhai9";
      type = "gem";
    };
    version = "13.0.1";
  };
  redis = {
    groups = [ "extra" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19hm66kw5vx1lmlh8bj7rxlddyj0vfp11ajw9njhrmn8173d0vb5";
      type = "gem";
    };
    version = "4.2.1";
  };
  redis-namespace = {
    dependencies = [ "redis" ];
    groups = [ "extra" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05i6s898z5w31z385cba1683pgg5nnmj4m686cbravg7j4pgbcgv";
      type = "gem";
    };
    version = "1.8.0";
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
      sha256 = "1hzsig4pi9ybr0xl5540m1swiyxa74c8h09225y5sdh2rjkkg84h";
      type = "gem";
    };
    version = "3.9.0";
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
      sha256 = "1xndkv5cz763wh30x7hdqw6k7zs8xfh0f86amra9agwn44pcqs0y";
      type = "gem";
    };
    version = "3.9.2";
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
      sha256 = "1bxkv25qmy39jqrdx35bfgw00g24qkssail9jlljm7hywbqvr9bb";
      type = "gem";
    };
    version = "3.9.2";
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
      sha256 = "19vmdqym1v2g1zbdnq37zwmyj87y9yc9ijwc8js55igvbb9hx0mr";
      type = "gem";
    };
    version = "3.9.1";
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
      sha256 = "0dandh2fy1dfkjk8jf9v4azbbma6968bhh06hddv0yqqm8108jir";
      type = "gem";
    };
    version = "3.9.3";
  };
  ruby-prof = {
    groups = [ "profile" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12cd91m08ih0imfpy4k87618hd4mhyz291a6bx2hcskza4nf6d27";
      type = "gem";
    };
    version = "1.4.1";
  };
  simplecov = {
    dependencies = [
      "docile"
      "simplecov-html"
    ];
    groups = [ "coverage" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b082xrklq6k755cc3rzpnfdjv5338rlky9him36jasw8s9q68mr";
      type = "gem";
    };
    version = "0.19.0";
  };
  simplecov-html = {
    groups = [
      "coverage"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v7b4mf7njw8kv4ghl4q7mwz3q0flbld7v8blp4m4m3n3aq11bn9";
      type = "gem";
    };
    version = "0.12.2";
  };
  thread_safe = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tzinfo = {
    dependencies = [ "thread_safe" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1i3jh086w1kbdj3k5l60lc3nwbanmzdf8yjj3mlrx9b2gjjxhi9r";
      type = "gem";
    };
    version = "1.2.7";
  };
  unicode-scripts = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04xfy4f61xf7qnbfa68aqscmyxk7wx3swn571cijsfqalhz8swjg";
      type = "gem";
    };
    version = "1.6.0";
  };
  wapiti = {
    dependencies = [ "builder" ];
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "maglev";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.8";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "1.9";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.0";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.1";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.2";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.3";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.4";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.5";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "maglev";
        version = "2.6";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
      }
      {
        engine = "rbx";
        version = "1.8";
      }
      {
        engine = "rbx";
        version = "1.9";
      }
      {
        engine = "rbx";
        version = "2.0";
      }
      {
        engine = "rbx";
        version = "2.1";
      }
      {
        engine = "rbx";
        version = "2.2";
      }
      {
        engine = "rbx";
        version = "2.3";
      }
      {
        engine = "rbx";
        version = "2.4";
      }
      {
        engine = "rbx";
        version = "2.5";
      }
      {
        engine = "rbx";
        version = "2.6";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.8";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "1.9";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.0";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.1";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.2";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.3";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.4";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.5";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
      {
        engine = "ruby";
        version = "2.6";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1aw2l759cfmii9a67pn8pswip11v08nabkzm825mrmxa6r91izqs";
      type = "gem";
    };
    version = "1.0.7";
  };
  yard = {
    groups = [ "extra" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "126m49mvh4lbvlvrprq7xj2vjixbq3xqr8dwr089vadvs0rkn4rd";
      type = "gem";
    };
    version = "0.9.25";
  };
  zeitwerk = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jvn50k76kl14fpymk4hdsf9sk00jl84yxzl783xhnw4dicp0m0k";
      type = "gem";
    };
    version = "2.4.0";
  };
}
