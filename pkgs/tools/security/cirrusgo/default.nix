{ lib
<<<<<<< HEAD
=======
, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cirrusgo";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Ph33rr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FYI/Ldu91YB/4wCiVADeYxYQOeBGro1msY5VXsnixw4=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-KCf2KQ8u+nX/+zMGZ6unWb/Vz6zPNkKtMioFo1FlnVI=";
=======
  vendorSha256 = "sha256-KCf2KQ8u+nX/+zMGZ6unWb/Vz6zPNkKtMioFo1FlnVI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool to scan SAAS and PAAS applications";
    homepage = "https://github.com/Ph33rr/cirrusgo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
