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
    version = "4.1.0";
    sha256 = "11axk03142ziax6i3wwy9qpqp7r3i7h5jg9y2xzph9i15rv8vlkj";
  };
}
