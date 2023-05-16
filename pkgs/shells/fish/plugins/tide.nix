{ lib, buildFishPlugin, fetchFromGitHub }:

# Due to a quirk in tide breaking wrapFish, we need to add additional commands in the config.fish
# Refer to the following comment to get you setup: https://github.com/NixOS/nixpkgs/pull/201646#issuecomment-1320893716
buildFishPlugin rec {
  pname = "tide";
<<<<<<< HEAD
  version = "5.6.0";
=======
  version = "5.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "IlanCosman";
    repo = "tide";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cCI1FDpvajt1vVPUd/WvsjX/6BJm6X1yFPjqohmo1rI=";
=======
    sha256 = "sha256-vi4sYoI366FkIonXDlf/eE2Pyjq7E/kOKBrQS+LtE+M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  #buildFishplugin will only move the .fish files, but tide has a tide configure function
  postInstall = ''
    cp -R functions/tide $out/share/fish/vendor_functions.d/
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "The ultimate Fish prompt";
=======
    description = "The ultimate Fish prompt.";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/IlanCosman/tide";
    license = licenses.mit;
    maintainers = [ maintainers.jocelynthode ];
  };
}

