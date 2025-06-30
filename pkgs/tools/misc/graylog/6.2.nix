{ callPackage, lib, ... }:
let
  buildGraylog = callPackage ./graylog.nix { };
in
buildGraylog {
  version = "6.2.2";
  hash = "sha256-ApUHGpGc2eeRVVJGudfE80hOEhjYwSfkMeycO6KRYMo=";
  maintainers = with lib.maintainers; [ bbenno ];
  license = lib.licenses.sspl;
}
