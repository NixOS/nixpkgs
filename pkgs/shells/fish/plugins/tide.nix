{ lib, buildFishPlugin, fetchFromGitHub }:

# Due to a quirk in tide breaking wrapFish, we need to add additional commands in the config.fish
# Refer to the following comment to get you setup: https://github.com/NixOS/nixpkgs/pull/201646#issuecomment-1320893716
buildFishPlugin rec {
  pname = "tide";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "IlanCosman";
    repo = "tide";
    rev = "v${version}";
    hash = "sha256-oLD7gYFCIeIzBeAW1j62z5FnzWAp3xSfxxe7kBtTLgA=";
  };

  #buildFishplugin will only move the .fish files, but tide has a tide configure function
  postInstall = ''
    cp -R functions/tide $out/share/fish/vendor_functions.d/
  '';

  meta = with lib; {
    description = "The ultimate Fish prompt";
    homepage = "https://github.com/IlanCosman/tide";
    license = licenses.mit;
    maintainers = [ maintainers.jocelynthode ];
  };
}

