{ lib, buildGoModule, fetchFromGitHub, olm }:

buildGoModule rec {
  pname = "mautrix-whatsapp";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.8.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-NbIDVBfh/6NXEvQhypOC5ToOq0EEkKKiMMahGJdXX0g=";
=======
    hash = "sha256-4dOkSnurg2Sk36Z2WNjPaO092IiRlzc9oWM6sQ+wUwM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ olm ];

<<<<<<< HEAD
  vendorHash = "sha256-5S5uq7CRixw6PvtE4xz+AWfS+VsKE4+JVZjfyXmvbsM=";
=======
  vendorSha256 = "sha256-48C9aaOe148emSsxzfKFKtnXyC39IFO8Ge7d+rIhDac=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tulir/mautrix-whatsapp";
    description = "Matrix <-> Whatsapp hybrid puppeting/relaybot bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ vskilet ma27 chvp ];
  };
}
