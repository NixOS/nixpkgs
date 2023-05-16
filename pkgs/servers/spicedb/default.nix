
{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "spicedb";
<<<<<<< HEAD
  version = "1.23.0";
=======
  version = "1.20.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-PCXF5sKQmsQiHwtqerOqlKgbgaHa8R/a+oEZIiqbJXc=";
  };

  vendorHash = "sha256-1Z9gg2ze/TKsv4yB4+XpZeI0Dmhlg7p13DPZBb4EejU=";
=======
    hash = "sha256-gTQ6AiFcx9ckygZt8l5BWHfk8wv0Z7xCirPzCPkloKA=";
  };

  vendorHash = "sha256-sL2i9kpMuJIdkDXOXJVMzYBiIsU7duu/tRfDaLPjbwo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/spicedb" ];

  meta = with lib; {
    description = "Open source permission database";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar.
    '';
    homepage = "https://authzed.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
