{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "opcr-policy";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "opcr-io";
    repo = "policy";
    rev = "v${version}";
    sha256 = "sha256-CoTp9IhsG09jZuxxiYgboNDmJ+AAiyw7lIjwL1Jq8u4=";
  };
  vendorHash = "sha256-bsReLqKR1jfu2pU912B/kyBlB6TjM8vY8IfiNEvTwcc=";

  ldflags = [ "-s" "-w" "-X github.com/opcr-io/policy/pkg/version.ver=${version}" ];

  subPackages = [ "cmd/policy" ];
  # disable go workspaces
  GOWORK = "off";

  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/policy --help
    $out/bin/policy version | grep "version: ${version}"

    runHook postInstallCheck
  '';

  meta = with lib; {
    mainProgram = "policy";
    homepage = "https://www.openpolicyregistry.io/";
    changelog = "https://github.com/opcr-io/policy/releases/tag/v${version}";
    description = "CLI for managing authorization policies";
    longDescription = ''
      The policy CLI is a tool for building, versioning and publishing your authorization policies.
      It uses OCI standards to manage artifacts, and the Open Policy Agent (OPA) to compile and run.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ naphta jk ];
  };
}
