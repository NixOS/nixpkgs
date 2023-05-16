{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkmate";
<<<<<<< HEAD
  version = "0.9.3";
=======
  version = "0.8.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-XzzN4oIG6E4NsMGl4HzFlgAGhkRieRn+jyA0bT8fcrg=";
  };

  vendorHash = "sha256-D87b/LhHnu8xE0wRdB/wLIuf5NlqrVnKt2WAF29bdZo=";
=======
    hash = "sha256-tgiZDTPIAYirPX6nGPEAt6BoYEC8uUJwT6zuHJqPF1w=";
  };

  vendorHash = "sha256-eL1fLJwzVpU9NqaAl5R/fbaqI3AnEkl6EuPkMTuY86w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "Pluggable code security analysis tool";
    homepage = "https://github.com/adedayo/checkmate";
    changelog = "https://github.com/adedayo/checkmate/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
