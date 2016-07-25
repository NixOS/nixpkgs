{ fetchgit }:
[
  {
    goPackagePath = "gopkg.in/yaml.v2";
    src = fetchgit {
      url = "https://gopkg.in/yaml.v2";
      rev = "a83829b6f1293c91addabc89d0571c246397bbf4";
      sha256 = "1m4dsmk90sbi17571h6pld44zxz7jc4lrnl4f27dpd1l8g5xvjhh";
    };
  }
  {
    goPackagePath = "golang.org/x/crypto";
    src = fetchgit {
      url = "https://go.googlesource.com/crypto";
      rev = "575fdbe86e5dd89229707ebec0575ce7d088a4a6";
      sha256 = "1kgv1mkw9y404pk3lcwbs0vgl133mwyp294i18jg9hp10s5d56xa";
    };
  }
  {
    goPackagePath = "golang.org/x/net";
    src = fetchgit {
      url = "https://go.googlesource.com/net";
      rev = "62ac18b461605b4be188bbc7300e9aa2bc836cd4";
      sha256 = "0lwwvbbwbf3yshxkfhn6z20gd45dkvnmw2ms36diiy34krgy402p";
    };
  }
  {
    goPackagePath = "github.com/gorilla/websocket";
    src = fetchgit {
      url = "https://github.com/gorilla/websocket";
      rev = "a622679ebd7a3b813862379232f645f8e690e43f";
      sha256 = "1nc9jbcmgya1i6dmf6sbcqsnxi9hbjg6dz1z0k7zmc6xdwlq0y4q";
    };
  }
  {
    goPackagePath = "github.com/miekg/dns";
    src = fetchgit {
      url = "https://github.com/miekg/dns";
      rev = "7e024ce8ce18b21b475ac6baf8fa3c42536bf2fa";
      sha256 = "0hlwb52lnnj3c6papjk9i5w5cjdw6r7c891v4xksnfvk1f9cy9kl";
    };
  }
  {
    goPackagePath = "github.com/BurntSushi/toml";
    src = fetchgit {
      url = "https://github.com/BurntSushi/toml";
      rev = "056c9bc7be7190eaa7715723883caffa5f8fa3e4";
      sha256 = "0gkgkw04ndr5y7hrdy0r4v2drs5srwfcw2bs1gyas066hwl84xyw";
    };
  }
  {
    goPackagePath = "github.com/hashicorp/go-syslog";
    src = fetchgit {
      url = "https://github.com/hashicorp/go-syslog";
      rev = "42a2b573b664dbf281bd48c3cc12c086b17a39ba";
      sha256 = "1j53m2wjyczm9m55znfycdvm4c8vfniqgk93dvzwy8vpj5gm6sb3";
    };
  }
  {
    goPackagePath = "github.com/flynn/go-shlex";
    src = fetchgit {
      url = "https://github.com/flynn/go-shlex";
      rev = "3f9db97f856818214da2e1057f8ad84803971cff";
      sha256 = "1j743lysygkpa2s2gii2xr32j7bxgc15zv4113b0q9jhn676ysia";
    };
  }
  {
    goPackagePath = "github.com/xenolf/lego";
    src = fetchgit {
      url = "https://github.com/xenolf/lego";
      rev = "ca19a90028e242e878585941c2a27c8f3b3efc25";
      sha256 = "1zkcsbdzbmfzk3kqmcj9l13li8sz228xhrw2wj3ab4a0w6drbw3x";
    };
  }
  {
    goPackagePath = "gopkg.in/natefinch/lumberjack.v2";
    src = fetchgit {
      url = "https://gopkg.in/natefinch/lumberjack.v2";
      rev = "514cbda263a734ae8caac038dadf05f8f3f9f738";
      sha256 = "1v92v8vkip36l2fs6l5dpp655151hrijjc781cif658r8nf7xr82";
    };
  }
  {
    goPackagePath = "github.com/shurcooL/sanitized_anchor_name";
    src = fetchgit {
      url = "https://github.com/shurcooL/sanitized_anchor_name";
      rev = "10ef21a441db47d8b13ebcc5fd2310f636973c77";
      sha256 = "1cnbzcf47cn796rcjpph1s64qrabhkv5dn9sbynsy7m9zdwr5f01";
    };
  }
  {
    goPackagePath = "gopkg.in/square/go-jose.v1";
    src = fetchgit {
      url = "https://gopkg.in/square/go-jose.v1";
      rev = "40d457b439244b546f023d056628e5184136899b";
      sha256 = "0asa1kl1qbx0cyayk44jhxxff0awpkwiw6va7yzrzjzhfc5kvg7p";
    };
  }
  {
    goPackagePath = "github.com/mholt/archiver";
    src = fetchgit {
      url = "https://github.com/mholt/archiver";
      rev = "85f054813ed511646b0ce5e047697e0651b8e1a4";
      sha256 = "0b38mrfm3rwgdi7hrp4gjhf0y0f6bw73qjkfrkafxjrdpdg7nyly";
    };
  }
  {
    goPackagePath = "github.com/dustin/go-humanize";
    src = fetchgit {
      url = "https://github.com/dustin/go-humanize";
      rev = "8929fe90cee4b2cb9deb468b51fb34eba64d1bf0";
      sha256 = "1g155kxjh6hd3ibx41nbpj6f7h5bh54zgl9dr53xzg2xlxljgjy0";
    };
  }
  {
    goPackagePath = "github.com/jimstudt/http-authentication";
    src = fetchgit {
      url = "https://github.com/jimstudt/http-authentication";
      rev = "3eca13d6893afd7ecabe15f4445f5d2872a1b012";
      sha256 = "1drw3bhrxpjzwryqz9nq5s0yyjqyd42iym3bh1zjs5qsh401cq08";
    };
  }
  {
    goPackagePath = "github.com/russross/blackfriday";
    src = fetchgit {
      url = "https://github.com/russross/blackfriday";
      rev = "d18b67ae0afd61dae240896eae1785f00709aa31";
      sha256 = "1l78hz8k1ixry5fjw29834jz1q5ysjcpf6kx2ggjj1s6xh0bfzvf";
    };
  }
]
