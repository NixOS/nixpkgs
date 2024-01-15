{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.1.7";
  sha256 = "sha256-OIdDBrLJEXhnQF98F0ncsoYcrH4KtHUz9Di1Jefsi6w=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
