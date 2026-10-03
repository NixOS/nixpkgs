{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

# Due to a quirk in tide breaking wrapFish, we need to add additional commands in the config.fish
# Refer to the following comment to get you setup: https://github.com/NixOS/nixpkgs/pull/201646#issuecomment-1320893716
buildFishPlugin rec {
  pname = "tide";
  version = "7.1.2";

  src = fetchFromGitHub {
    owner = "plttn";
    repo = "tide";
    rev = "v${version}";
    hash = "sha256-R2oIGbDPF81NurJ5R2Jos6P5mxYTyb1n1cpI1AZ35H4=";
  };

  #buildFishplugin will only move the .fish files, but tide has a tide configure function
  postInstall = ''
    cp -R functions/tide $out/share/fish/vendor_functions.d/
  '';

  meta = {
    description = "Ultimate Fish prompt";
    homepage = "https://github.com/plttn/tide";
    changelog = "https://github.com/plttn/tide/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jocelynthode ];
  };
}
