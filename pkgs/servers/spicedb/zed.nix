{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
<<<<<<< HEAD
  version = "0.12.1";
=======
  version = "0.10.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-3aG47DeYVwDj0tX26oOWVE8yq8sVtxA4uw+LOIjKNuI=";
  };

  vendorHash = "sha256-kUMCbRIhSb5Bqo1P9J08xVUJmUdxaq5iU34sR+nuol4=";
=======
    hash = "sha256-ZI5aoL4CCqSv7Sw5RApa4AeVVE97tA5HXM5tdF12hqE=";
  };

  vendorHash = "sha256-hIhByVm4QpDhnXuWbscKYIgE/Bi0psBE0PvmuCq2NhQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Command line for managing SpiceDB";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar. zed is the command line client for SpiceDB.
    '';
    homepage = "https://authzed.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
