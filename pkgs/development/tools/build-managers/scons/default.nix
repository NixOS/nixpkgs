{ callPackage, python2, python3 }:

let
  mkScons = args: callPackage (import ./common.nix args) {
    python = python3;
  };
in {
  scons_3_1_2 = (mkScons {
    version = "3.1.2";
    sha256 = "1yzq2gg9zwz9rvfn42v5jzl3g4qf1khhny6zfbi2hib55zvg60bq";
  });
  scons_latest = mkScons {
    version = "4.3.0";
    sha256 = "1v5x2zqnlxg19i58782279x3zqyz2l3j79k41jf2k4a499sq3z1f";
  };
}
