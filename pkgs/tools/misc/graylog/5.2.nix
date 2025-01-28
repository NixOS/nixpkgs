{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.2.12";
  hash = "sha256-VF6eLOYfnIROPj1pvyV1G3TKGj/rAa2spc/oel4LFwk=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
