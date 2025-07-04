{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y/D7zeQu3xFtbamKlDfxndFpIVLx76P8xHQeRDx3IRc=";
      type = "gem";
    };
    version = "2.8.5";
  };
  afm = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yD5pjnWasAYzMf+EyjnEZzsDMY9N3L6OkBd90B5Mcho=";
      type = "gem";
    };
    version = "0.2.2";
  };
  Ascii85 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nOaURnvWmrI0l2iv0nxSrXIc3G9kKuqolXF7/XraRLc=";
      type = "gem";
    };
    version = "1.1.0";
  };
  async = {
    dependencies = [
      "console"
      "fiber-annotation"
      "io-event"
      "timers"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-C254wvgfJajC6b9BghTPLSAnP5FJubjNoy/hiZRnBiA=";
      type = "gem";
    };
    version = "2.6.3";
  };
  console = {
    dependencies = [
      "fiber-annotation"
      "fiber-local"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Syf0i1CJZGXmF70k9lStCQcSX9DM/P06EHNwvUhflxE=";
      type = "gem";
    };
    version = "1.23.1";
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
      hash = "sha256-by7S+mgEeWLWByuWRCDLqR2Czm+o7iUZUMF/ymrzwqA=";
      type = "gem";
    };
    version = "1.15.5";
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KTeaC8DEJ5L4oG322oLw8r2piq0XrJ8Wi+owl8DqPe8=";
      type = "gem";
    };
    version = "1.0.0";
  };
  hashery = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0jnMIxBAGQP2t51FjCu+9b90xG8/l0rpwQYft0pASGI=";
      type = "gem";
    };
    version = "2.1.2";
  };
  html-proofer = {
    dependencies = [
      "addressable"
      "async"
      "nokogiri"
      "pdf-reader"
      "rainbow"
      "typhoeus"
      "yell"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lfOjRFrBtmDvz82oKMsTnjbe5HNAtQH1aBELOhYd8FM=";
      type = "gem";
    };
    version = "5.0.8";
  };
  io-event = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2ejKJBRWhHrBV6Cx116MLmyHipnkdPYX0T53lHC4hgA=";
      type = "gem";
    };
    version = "1.2.3";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GAvEGTcBu+ubbALfWmuBhb/38yq9Rm3ZfWUy025Fsgo=";
      type = "gem";
    };
    version = "2.8.4";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NBOIGE6XXQkebjjOPzsziL+35Kw9eQ79jjkSSEQEC9E=";
      type = "gem";
    };
    version = "1.16.0";
  };
  pdf-reader = {
    dependencies = [
      "Ascii85"
      "afm"
      "hashery"
      "ruby-rc4"
      "ttfunk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AyOFJfmDQPdZjOXikqLL6Kh/mipWF8jN1eJGe2URXSc=";
      type = "gem";
    };
    version = "2.11.0";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-M31HXaK9LqHeBEZ1HLlyrUMkO0sAqoz5HLkE+lk9Mlk=";
      type = "gem";
    };
    version = "5.0.3";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-r2QSSDb908AOgwcD1/hz6l3qvekj83AGo59aXg2hY4c=";
      type = "gem";
    };
    version = "1.7.1";
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
  ruby-rc4 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AMxAo50gtT9UWefqAGqSz1hOm8J14qb3qhUVUQ6JbAM=";
      type = "gem";
    };
    version = "0.1.5";
  };
  timers = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-99h2VjY/ePZkOBg8AA759JBXrZG8v5H129y7X+2NX14=";
      type = "gem";
    };
    version = "4.3.5";
  };
  ttfunk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I3C6SEsYkccL3K/TRIz9gqMt15SALYHXIKZMFdPvKpY=";
      type = "gem";
    };
    version = "1.7.0";
  };
  typhoeus = {
    dependencies = [ "ethon" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-//mIDV3DWVDncGzxMv0pfzd8BJEBeUvhzwHJVWf2QtQ=";
      type = "gem";
    };
    version = "1.4.0";
  };
  yell = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HRZvPMO23Emll3jqcVbtbY3nlMFRBtSP/Wy7BhubJrw=";
      type = "gem";
    };
    version = "2.2.2";
  };
  zeitwerk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-recvIjp1yR87ArLJQaV/tpe8RD1hXzjCh3MYXghpjdc=";
      type = "gem";
    };
    version = "2.6.11";
  };
}
