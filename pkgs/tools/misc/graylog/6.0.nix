{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "6.0.8";
  hash = "sha256-j+TkXoogRd24oo0grzDGGEOyQlf2+cMxY3nKCWamS6c=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
