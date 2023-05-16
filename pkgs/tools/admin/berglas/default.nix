<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, testers, berglas }:
=======
{ lib, buildGoModule, fetchFromGitHub }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  skipTests = {
    access = "Access";
    create = "Create";
    delete = "Delete";
    list = "List";
    read = "Read";
    replace = "Replace";
    resolver = "Resolve";
    revoke = "Revoke";
    update = "Update";
  };

  skipTestsCommand =
    builtins.foldl' (acc: goFileName:
      let testName = builtins.getAttr goFileName skipTests; in
      ''
        ${acc}
        substituteInPlace pkg/berglas/${goFileName}_test.go \
          --replace "TestClient_${testName}_storage" "SkipClient_${testName}_storage" \
          --replace "TestClient_${testName}_secretManager" "SkipClient_${testName}_secretManager"
      ''
    ) "" (builtins.attrNames skipTests);
in

buildGoModule rec {
  pname = "berglas";
<<<<<<< HEAD
  version = "1.0.3";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-4hbRX0kKMWixcu5SWjrM5lVvhLMOaeBdG4GH5NVAh70=";
  };

  vendorHash = "sha256-qcFS07gma7GVxhdrYca0E6rcczNcZmU8JcjjcpEaxp0=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/GoogleCloudPlatform/berglas/internal/version.Version=${version}"
  ];

  postPatch = skipTestsCommand;

  passthru.tests = {
    version = testers.testVersion {
      package = berglas;
    };
  };

=======
    sha256 = "sha256-OMmvoUzdi5rie/YCkylSKjNm2ty2HnnAuFZrLAgJHZk=";
  };

  vendorHash = "sha256-WIbT1N7tRAt5vJO6j06fwUAaFxfAevRo0+r2wyy+feE=";

  postPatch = skipTestsCommand;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A tool for managing secrets on Google Cloud";
    homepage = "https://github.com/GoogleCloudPlatform/berglas";
    license = licenses.asl20;
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
