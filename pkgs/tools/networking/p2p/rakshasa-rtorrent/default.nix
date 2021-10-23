{ lib
, pkgs
, callPackage
}:

rec {
  libtorrent = callPackage ./libtorrent.nix { };
  rtorrent = callPackage ./rtorrent.nix { };
}
