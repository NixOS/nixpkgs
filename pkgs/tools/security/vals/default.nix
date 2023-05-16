{ lib, buildGoModule, fetchFromGitHub, testers, vals }:

buildGoModule rec {
  pname = "vals";
<<<<<<< HEAD
  version = "0.27.1";
=======
  version = "0.25.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "variantdev";
    repo = pname;
<<<<<<< HEAD
    sha256 = "sha256-2Wjp1Q7c4CrhCnPTQUyrzVPL89XYOp2bnySQril/RQc=";
  };

  vendorHash = "sha256-J0fhxfGDJKZfRWPPockIAUENCPffQlQmwjkgls+ocoE=";
=======
    sha256 = "sha256-MofzTQM/dREw9b+IzjvexKoYZZ/ptbdWICROtwYK4X8=";
  };

  vendorHash = "sha256-6DJiqDEgEHQbyIt4iShoBnagBvspd3W3vD56/FGjESs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Tests require connectivity to various backends.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = vals;
    command = "vals version";
  };

  meta = with lib; {
    description = "Helm-like configuration values loader with support for various sources";
    license = licenses.asl20;
    homepage = "https://github.com/variantdev/vals";
    changelog = "https://github.com/variantdev/vals/releases/v${version}";
    maintainers = with maintainers; [ stehessel ];
  };
}
