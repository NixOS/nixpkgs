{ callPackage, openssl, python3, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "15.13.0";
    sha256 = "1wd859bxd8j97xl98k61g0vwcmy83wvjj04fgway38aapk9abp4h";
  }
