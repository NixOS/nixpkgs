{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "6.0.12";
  hash = "sha256-O1seFUGg83L5XE1TcOVJe18gKq26b3nDPLGjNqr2VUc=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
