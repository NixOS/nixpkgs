{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jaeles";
<<<<<<< HEAD
  version = "0.17.1";
=======
  version = "0.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jaeles-project";
    repo = pname;
    rev = "beta-v${version}";
<<<<<<< HEAD
    hash = "sha256-IGvIjO1nCilg2sPyScGTH5Zmv0rORlGwRv3NRxQk+aM=";
  };

  vendorHash = "sha256-/Ow2qdcFduZ2ZyUUfCqpZxSh9yy3+tI/2N9Wl1fKXVI=";
=======
    hash = "sha256-IGB+TYMOOO7fvRfDe9y+JSXuDSMDVJK+N4hS+kezG48=";
  };

  vendorSha256 = "sha256-R2cP5zNuGUs0/KeaGhbQm1m5gVBVhpcFrS/jsph3EBk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Tests want to download signatures
  doCheck = false;

  meta = with lib; {
    description = "Tool for automated Web application testing";
    homepage = "https://github.com/jaeles-project/jaeles";
<<<<<<< HEAD
    changelog = "https://github.com/jaeles-project/jaeles/releases/tag/beta-v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
