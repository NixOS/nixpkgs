{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "asnmap";
<<<<<<< HEAD
  version = "1.0.4";
=======
  version = "1.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-J5Dn5eDzwj+ApwQ3ibTsMbwCobRAb1Cli+hbf74I9VQ=";
  };

  vendorHash = "sha256-0vU7YWZKiqi3WsjSTNvtUiskIczADgfRRC7rwCx8ho4=";
=======
    hash = "sha256-nkDa54+4bAMtQ/s/vn7x9hAt7p+ErKMOZ70MoH45CoM=";
  };

  vendorHash = "sha256-owpu0oANYipso33HOwwSqL8G0VDT53B9HeLQA/GvmxU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Tool to gather network ranges using ASN information";
    homepage = "https://github.com/projectdiscovery/asnmap";
    changelog = "https://github.com/projectdiscovery/asnmap/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
