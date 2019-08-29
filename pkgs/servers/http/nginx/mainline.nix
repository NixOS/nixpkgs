{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.17.3";
  sha256 = "0g0g9prwjy0rnv6n5smny5yl5dhnmflqdr3hwgyj5jpr5hfgx11v";
})
