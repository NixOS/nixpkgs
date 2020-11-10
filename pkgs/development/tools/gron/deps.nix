[
  rec {
    owner = "fatih";
    repo = "color";
    goPackagePath = "github.com/${owner}/${repo}";
    fetch = {
      type = "git";
      url = "https://github.com/${owner}/${repo}";
      rev = "v1.7.0";
      sha256 = "0v8msvg38r8d1iiq2i5r4xyfx0invhc941kjrsg5gzwvagv55inv";
    };
  }
  rec {
    owner = "nwidger";
    repo = "jsoncolor";
    goPackagePath = "github.com/${owner}/${repo}";
    fetch = {
      type = "git";
      url = "https://github.com/${owner}/${repo}";
      rev = "75a6de4340e59be95f0884b9cebdda246e0fdf40";
      sha256 = "0aiv42xijrqgrxfx6pfyrndpwqv8i1qwsk190jdczyjxlnki2nki";
    };
  }
  rec {
    owner = "pkg";
    repo = "errors";
    goPackagePath = "github.com/${owner}/${repo}";
    fetch = {
      type = "git";
      url = "https://github.com/${owner}/${repo}";
      rev = "v0.8.0";
      sha256 = "001i6n71ghp2l6kdl3qq1v2vmghcz3kicv9a5wgcihrzigm75pp5";
    };
  }
  rec {
    owner = "mattn";
    repo = "go-colorable";
    goPackagePath = "github.com/${owner}/${repo}";
    fetch = {
      type = "git";
      url = "https://github.com/${owner}/${repo}";
      rev = "v0.0.9";
      sha256 = "1nwjmsppsjicr7anq8na6md7b1z84l9ppnlr045hhxjvbkqwalvx";
    };
  }
  rec {
    owner = "mattn";
    repo = "go-isatty";
    goPackagePath = "github.com/${owner}/${repo}";
    fetch = {
      type = "git";
      url = "https://github.com/${owner}/${repo}";
      rev = "v0.0.4";
      sha256 = "0zs92j2cqaw9j8qx1sdxpv3ap0rgbs0vrvi72m40mg8aa36gd39w";
    };
  }
]
