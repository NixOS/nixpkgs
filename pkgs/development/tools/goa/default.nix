{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "goa";
<<<<<<< HEAD
  version = "3.12.4";
=======
  version = "3.11.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ox4UPwotJBA8qxZpqyKmOW2bqbSWHX+yIpGvFnf2Rzo=";
  };
  vendorHash = "sha256-AIhAMgpVLMxeYoj4Jl4O92/etOtFD++ddV18R8aYRuY=";
=======
    sha256 = "sha256-Po5i6pb7Qu6kYLO7rdW9SJFDf42rPx8mvSfNxtW3Qcg=";
  };
  vendorHash = "sha256-vND29xb5bG+MnBiOCP9PWC+VGqIwdUO0uVOcP5Wc4zA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
