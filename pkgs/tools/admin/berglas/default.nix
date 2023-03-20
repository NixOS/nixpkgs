{ lib, buildGoModule, fetchFromGitHub }:

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
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OMmvoUzdi5rie/YCkylSKjNm2ty2HnnAuFZrLAgJHZk=";
  };

  vendorHash = "sha256-WIbT1N7tRAt5vJO6j06fwUAaFxfAevRo0+r2wyy+feE=";

  postPatch = skipTestsCommand;

  meta = with lib; {
    description = "A tool for managing secrets on Google Cloud";
    homepage = "https://github.com/GoogleCloudPlatform/berglas";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
