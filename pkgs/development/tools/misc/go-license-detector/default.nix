{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "go-license-detector";
<<<<<<< HEAD
  version = "4.3.1";
=======
  version = "4.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "go-enry";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-S9LKXjn5dL5FETOOAk+bs7bIVdu2x7MIhfjpZuXzuLo=";
  };

  vendorHash = "sha256-MtQsUsFd9zQGbP7NGZ4zcSoa6O2WSWvGig0GUwCc6uM=";
=======
    sha256 = "sha256-MubQpxpUCPDBVsEz4NmY8MFEoECXQtzAaZJ89vv5bDc=";
  };

  vendorSha256 = "sha256-a9yCnGg+4f+UoHbGG8a47z2duBD3qXcAzPKnE4PQsvM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [ git ];

  meta = with lib; {
    description = "Reliable project licenses detector";
    homepage = "https://github.com/go-enry/go-license-detector";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "license-detector";
  };
}
