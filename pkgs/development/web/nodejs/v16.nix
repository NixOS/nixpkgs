{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.5.0";
    sha256 = "16dapj5pm2y1m3ldrjjlz8rq9axk85nn316iz02nk6qjs66y6drz";
  }
