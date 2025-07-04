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
  asciidoctor-bibtex = {
    dependencies = [
      "asciidoctor"
      "bibtex-ruby"
      "citeproc-ruby"
      "csl-styles"
      "latex-decode"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PpgFN2rmkXtih9e2SicInFAx+nBaoOKJ/5IZaETSh5o=";
      type = "gem";
    };
    version = "0.9.0";
  };
  asciidoctor-diagram = {
    dependencies = [
      "asciidoctor"
      "asciidoctor-diagram-ditaamini"
      "asciidoctor-diagram-plantuml"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BBcmRDOuVmZUrh+MkkWpearRsaORD+9eAmSaUTvTJIg=";
      type = "gem";
    };
    version = "2.3.1";
  };
  asciidoctor-diagram-batik = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NEtQa864r+4MNHro1j60W0aqIciLQqxh7TXWWTvuQAg=";
      type = "gem";
    };
    version = "1.17";
  };
  asciidoctor-diagram-ditaamini = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pjCyqA7gSaNe05vJO6M7VxmWOBIVWDzHPwwevNwqBo4=";
      type = "gem";
    };
    version = "1.0.3";
  };
  asciidoctor-diagram-plantuml = {
    dependencies = [ "asciidoctor-diagram-batik" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KsJKcwtNGJqC9UJweCFNN6q+dDbmAu7S9sPub3e5dZw=";
      type = "gem";
    };
    version = "1.2024.6";
  };
  asciidoctor-epub3 = {
    dependencies = [
      "asciidoctor"
      "gepub"
      "mime-types"
      "sass"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lMqvfBPwUHefSoWvUXy8VcXjHiEcWmDd6blkdzK0wvo=";
      type = "gem";
    };
    version = "2.1.3";
  };
  asciidoctor-html5s = {
    dependencies = [
      "asciidoctor"
      "thread_safe"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QWt6cdgb1ZxVb270o+26pQ5J1nhWGVGaXWjq7DFzy/0=";
      type = "gem";
    };
    version = "0.5.1";
  };
  asciidoctor-mathematical = {
    dependencies = [
      "asciidoctor"
      "asciimath"
      "mathematical"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-V0dWtWRmjgODdSyW11VLMtWlAhxQGrWvIIbiYfHBrtM=";
      type = "gem";
    };
    version = "0.3.5";
  };
  asciidoctor-multipage = {
    dependencies = [ "asciidoctor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8cDpH54LT3sbn2S/fmuPsOZTtDhjoXpIAL1mvGLEWMI=";
      type = "gem";
    };
    version = "0.0.19";
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
  asciidoctor-reducer = {
    dependencies = [ "asciidoctor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nGoTJBSEaq60Yg3OuWh+0/DoJxNbNRTC/EbYVk+aebk=";
      type = "gem";
    };
    version = "1.0.6";
  };
  asciidoctor-revealjs = {
    dependencies = [ "asciidoctor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o8SMyHyY15q0DuFZ1oe5XjkQ2c5AOsgi7ecU+x376kk=";
      type = "gem";
    };
    version = "5.1.0";
  };
  asciimath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IZFSPDPQy2wEP0EB4Hn0fNVKKhVR6ktKfwc+OijGwts=";
      type = "gem";
    };
    version = "2.0.5";
  };
  bibtex-ruby = {
    dependencies = [
      "latex-decode"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JjHHQr4YWxpt9rQxIG94zmc75lKBFnKNCs6Q+IIU/b0=";
      type = "gem";
    };
    version = "6.1.0";
  };
  citeproc = {
    dependencies = [ "namae" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gpoKLikaOv0c3jnc5IgN9iU7D+zSYiYnUmXqWaUudI8=";
      type = "gem";
    };
    version = "1.0.10";
  };
  citeproc-ruby = {
    dependencies = [
      "citeproc"
      "csl"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y85dbCIbaduMGVt+8r2rlNkbycmhbM8moTa2CqGHCik=";
      type = "gem";
    };
    version = "1.1.14";
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
  csl = {
    dependencies = [
      "namae"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MzMvq30tEbo88kgYM+r745OOhPSHkex4WMLjvX/FEVk=";
      type = "gem";
    };
    version = "1.6.0";
  };
  csl-styles = {
    dependencies = [ "csl" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6Cl7Tuna47frsoKwyug7cuL4IMSxqHUdQoCceCbFSVA=";
      type = "gem";
    };
    version = "1.0.1.11";
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
  gepub = {
    dependencies = [
      "nokogiri"
      "rubyzip"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HWrsRjenH4U2ZWP6aPWNsim6zGGTDSMcAIe0fwDy1iE=";
      type = "gem";
    };
    version = "1.0.15";
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
  latex-decode = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4mBr0FhPxTk/Kkue+Qf/SFc7i61AE72pyfjCx/+wvfg=";
      type = "gem";
    };
    version = "0.4.0";
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
  mathematical = {
    dependencies = [ "ruby-enum" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mXge1eV/wfbSvJsS5XDG4e/lDc/SO9VBLpVr6XYbIHg=";
      type = "gem";
    };
    version = "1.6.20";
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
  mime-types = {
    dependencies = [
      "logger"
      "mime-types-data"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b3HblXhAzq5EIRUx7/Pi9+DdRkX++19TXbrrYwerZGQ=";
      type = "gem";
    };
    version = "3.6.0";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TV+8caTre/oIdArcvumAk8qMewWlybxpzY3LESSwqxk=";
      type = "gem";
    };
    version = "3.2024.1001";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-E+71q0Wbv9M9YeU5Vk7CWpws9ZOwpeptTX74wZsWLuA=";
      type = "gem";
    };
    version = "2.8.7";
  };
  namae = {
    dependencies = [ "racc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NUHOSwhv1JgdI3ZjDAPihEAr/hzbq05Q4iIqcq651Z0=";
      type = "gem";
    };
    version = "1.2.0";
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
      hash = "sha256-+BnL/fsKexnJxSxvLKY98OWKYSX08Tlwe1hrlRHX/pU=";
      type = "gem";
    };
    version = "1.16.7";
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
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rb-fsevent = {
    groups = [ "default" ];
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oKcARBI5sP8Y62XjhmI2zXhhPWufeP6h+axHqF5Hvm4=";
      type = "gem";
    };
    version = "0.11.1";
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
  ruby-enum = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-52fvWujevB0tSmrv7p22Tw7vvwYz9eGLXFgWRZKCxuc=";
      type = "gem";
    };
    version = "1.0.0";
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
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P1fjk13CJVxBRIT7+NZztJCdimpXAH7XVN3jk0LSNz8=";
      type = "gem";
    };
    version = "2.3.2";
  };
  sass = {
    dependencies = [ "sass-listen" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gIsNOQU6ppBo35OeJGcf6E/VqdMxRIbhoUV9CTSkJV0=";
      type = "gem";
    };
    version = "3.7.4";
  };
  sass-listen = {
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rp3Ldt0+I0Mp5bpuIT9I5TLFo+ewtNiofxOqygzBg3c=";
      type = "gem";
    };
    version = "4.0.0";
  };
  thread_safe = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ntcHKCG1HFfo1rcBGo4oLiWu6jpAZeqzJuQ/ZvBjsFo=";
      type = "gem";
    };
    version = "0.3.6";
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
