{ callPackage, lib, ...}:
let
  buildGraylog = callPackage ./graylog.nix {};
in buildGraylog {
  version = "5.2.4";
  sha256 = "sha256-TbZMRMLpYlg6wrsC+tDEk8sLYJ1nwJum/rL30CEGQcw=";
  maintainers = [ lib.maintainers.f2k1de ];
  license = lib.licenses.sspl;
}
