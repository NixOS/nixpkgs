{ stdenv, pkgs }:
let
  src = pkgs.fetchFromGitHub {
    owner  = "crytic";
    repo   = "echidna";
    rev    = "09155a7e845b6430bb2c0beb7a01cf602ceb554a";
    sha256 = "13gpnj77849m1b24w02c2wl7xyyndw3kq3w5xprvap1bdzjlsmps";
  };
  drv = import "${src}" {};
in drv // {
  meta = with stdenv.lib; {
    description = "Ethereum smart contract fuzzer";
    homepage = "https://github.com/crytic/echidna";
    license = licenses.agpl3;
    maintainers = with maintainers; [ arturcygan ];
  };
}
