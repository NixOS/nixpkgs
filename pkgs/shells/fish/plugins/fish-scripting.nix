{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "fish-scripting";
  version = "0-unstable-2024-09-19";

  src = fetchFromGitHub {
    owner = "lewisacidic";
    repo = "fish-scripting";
    rev = "4da565fde4ea4b9159a64768181269e26398a283";
    hash = "sha256-4HGQW05+Y/2Psb1Iw+3N6MaNurpbkQrSK66W+5wGQbQ=";
  };

  meta = {
    description = "Fish abbreviations for some scripting commands";
    homepage = "https://github.com/lewisacidic/fish-scripting";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ui-1 ];
  };
}
