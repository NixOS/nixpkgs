{ lib
, buildNpmPackage
, fetchFromGitHub
, nix-update-script
}:

buildNpmPackage rec {
  pname = "ansible-language-server";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ansible";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-e6cOWoryOxWnl8q62rlGmSgwLVnoxLMwNFoGlUZw2bQ=";
  };

  npmDepsHash = "sha256-Lzwj0/2fxa44DJBsgDPa43AbRxggqh881X/DFnlNLig=";
=======
    hash = "sha256-IBySScjfF2bIbiOv09uLMt9QH07zegm/W1vmGhdWxGY=";
  };

  npmDepsHash = "sha256-rJ1O2OsrJhTIfywK9/MRubwwcCmMbu61T4zyayg+mAU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  npmBuildScript = "compile";

  # We remove/ignore the prepare and prepack scripts because they run the
  # build script, and therefore are redundant.
  #
  # Additionally, the prepack script runs npm ci in addition to the
  # build script. Directly before npm pack is run, we make npm unaware
  # of the dependency cache, causing the npm ci invocation to fail,
  # wiping out node_modules, which causes a mysterious error stating that tsc isn't installed.
  postPatch = ''
    sed -i '/"prepare"/d' package.json
    sed -i '/"prepack"/d' package.json
  '';

  npmPackFlags = [ "--ignore-scripts" ];
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/ansible/ansible-language-server/releases/tag/v${version}";
    description = "Ansible Language Server";
    homepage = "https://github.com/ansible/ansible-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
