{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "conftest";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "sha256-mSiZjpsFZfkM522f1WcJgBexiBS0o3uf1g94pjhgGVU=";
  };

  vendorSha256 = "sha256-iCIuEvwkbfBZ858yZZyVf5om6YLsGKRvzFmYzJBrRf4=";

  doCheck = false;

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X github.com/open-policy-agent/conftest/internal/commands.version=${version}"
  ];

  meta = with lib; {
    description = "Write tests against structured configuration data";
    longDescription = ''
      Conftest helps you write tests against structured configuration data.
      Using Conftest you can write tests for your Kubernetes configuration,
      Tekton pipeline definitions, Terraform code, Serverless configs or any
      other config files.

      Conftest uses the Rego language from Open Policy Agent for writing the
      assertions. You can read more about Rego in 'How do I write policies' in
      the Open Policy Agent documentation.
    '';
    inherit (src.meta) homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
