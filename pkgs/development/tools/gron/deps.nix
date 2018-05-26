[
  rec {
    owner = "fatih";
    repo = "color";
    goPackagePath = "github.com/${owner}/${repo}";
    fetch = {
      type = "git";
      url = "https://github.com/${owner}/${repo}";
      rev = "v1.6.0";
      sha256 = "0k1v9dkhrxiqhg48yqkwzpd7x40xx38gv2pgknswbsy4r8w644i7";
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
]
