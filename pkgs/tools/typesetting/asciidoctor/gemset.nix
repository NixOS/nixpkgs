{
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
      hash = "sha256-c9dg0JO/mX6IwqTQv+QyjoOOB5mRWu5rMWKDbFJnwrA=";
      type = "gem";
    };
    version = "1.1.1";
  };
  asciidoctor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UiCIB/I336DKKYgvixPWC4IElhFq0ZHPGXylbyt/3fM=";
      type = "gem";
    };
    version = "2.0.23";
  };
  asciidoctor-pdf = {
    dependencies = [
      "asciidoctor"
      "concurrent-ruby"
      "matrix"
      "prawn"
      "prawn-icon"
      "prawn-svg"
      "prawn-table"
      "prawn-templates"
      "treetop"
      "ttfunk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A0oUKWTWJ7gv1PCKCUq+2umB5jLn8cUB072cLfvgc/k=";
      type = "gem";
    };
    version = "2.3.19";
  };
  coderay = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FMAGKRoRRL484FDzSoJbJ8CofwkWe3P5TR4en/HfUs=";
      type = "gem";
    };
    version = "1.1.3";
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
  css_parser = {
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GUDc4B47m+GNaIDm1lFi2YTMBP8omYz0dZvrmZJ1IJ4=";
      type = "gem";
    };
    version = "1.19.1";
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
  matrix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cQg8y9Z6FKQ7+njT5NwPS1A7nMGOW0sdaG3A+e98TMA=";
      type = "gem";
    };
    version = "0.4.2";
  };
  pdf-core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TzaLLxK1fsl5hy1L9L0aZ+hkjgyBq4mAFDHS/In04Ls=";
      type = "gem";
    };
    version = "0.9.0";
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
      hash = "sha256-YecqSDnPKzc1pLCNywDiPFelHRmUlKWxG9eOSde5F1g=";
      type = "gem";
    };
    version = "2.12.0";
  };
  polyglot = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WdZu9ePBZkMcOcuLfB0Cr0GQUTUvJ5EvakOYGz3vFq8=";
      type = "gem";
    };
    version = "0.3.5";
  };
  prawn = {
    dependencies = [
      "pdf-core"
      "ttfunk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ggYnRPcSbC13UB2iU6FUJxeQJU36jDCbjlLnm8XeKr0=";
      type = "gem";
    };
    version = "2.4.0";
  };
  prawn-icon = {
    dependencies = [ "prawn" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2sjUgd7g9gp2nAyrD9G67HNRtIBr+bqVnNbGX2aUtvU=";
      type = "gem";
    };
    version = "3.0.0";
  };
  prawn-svg = {
    dependencies = [
      "css_parser"
      "matrix"
      "prawn"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-r/950zKUD21ZYE0LKBD1TUbpM1UzoqpOiS+31RR3epA=";
      type = "gem";
    };
    version = "0.34.2";
  };
  prawn-table = {
    dependencies = [ "prawn" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-M21G454AP3e/lzM3qVivamgwC5QchcsiKIhy3Cs2rds=";
      type = "gem";
    };
    version = "0.2.2";
  };
  prawn-templates = {
    dependencies = [
      "pdf-reader"
      "prawn"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EXqgPbVwFHy4b8195P2JaZT3AuraHWmYSKlSmofNMfE=";
      type = "gem";
    };
    version = "0.1.2";
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
  "pygments.rb" = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QXKezGliS9P8a8wT1sy2/wJjM0xC9mv89RehIK3bsJM=";
      type = "gem";
    };
    version = "3.0.0";
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
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-em1tlR4yAuTOOSaDhiX6bt6zVoDm0eOBf1PBQhIiC2Q=";
      type = "gem";
    };
    version = "4.4.0";
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
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-33TymkUdrtJlkahejgzrsZiJLLdbZXM5QwOs2ic/uk0=";
      type = "gem";
    };
    version = "2.4.0";
  };
  treetop = {
    dependencies = [ "polyglot" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Uit1oSi16j9bjuLAn2O5Zg7UJd65pGRMTGiTxdGrCk=";
      type = "gem";
    };
    version = "1.6.12";
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
}
