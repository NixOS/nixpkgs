{ lib, fetchFromGitHub }:

let
<<<<<<< HEAD
  version = "3.13.10";
=======
  version = "3.11.19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
fetchFromGitHub {
  name = "stevenblack-blocklist-${version}";

  owner = "StevenBlack";
  repo = "hosts";
  rev = version;
<<<<<<< HEAD
  sha256 = "sha256-LTo0NV1DpHI05AvfmTKNz+/NdXaNoLxgpMhV/HqeT6g=";
=======
  sha256 = "sha256-YGD3I64g/zD5iX2oIU6Qy/WqzcWcaNs1HjMUBeKcDZ4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Unified hosts file with base extensions";
    homepage = "https://github.com/StevenBlack/hosts";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
