{ lib, buildGoModule, fetchFromGitHub, testers, berglas }:

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
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Jf6yPVydM7UnG1yiLEFe+7FMkWANIQebZ3QAwg6/OQs=";
  };

  vendorHash = "sha256-3WDBl/GqCgRFMmh6TQvtHhACCRzf9sdIO8fel8CAMP0=";

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

  meta = with lib; {
    description = "A tool for managing secrets on Google Cloud";
    homepage = "https://github.com/GoogleCloudPlatform/berglas";
    license = licenses.asl20;
  };
}
