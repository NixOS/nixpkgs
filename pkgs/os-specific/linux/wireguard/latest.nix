{ stdenv, fetchurl, libmnl, iproute, kernel ? null }:

import ./generic.nix {
  version = "0.0.20161218";
  sha256  = "d805035d3e99768e69d8cdeb8fb5250a59b994ce127fceb71a078582c30f5597";
  inherit stdenv fetchurl libmnl iproute kernel;
}
