{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.2.3";
  sha256 = "sha256-QeWlJuJYd8ZnyxwlxILq+tuAmQ5lW9kldcsXUiLlvS4=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
