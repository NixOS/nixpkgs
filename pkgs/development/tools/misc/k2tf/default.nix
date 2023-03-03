{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "k2tf";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sl1pm4t";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zkkRzCTZCvbwBj4oIhTo5d3PvqLMJPzT3zV9jU3PEJs=";
  };

  vendorSha256 = "sha256-iCRiBCppqCZrCUQipoVgc4jUnLkX6QVFjxI6sv6n7tU=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" "-X main.commit=v${version}" ];

  meta = with lib; {
    description = "Kubernetes YAML to Terraform HCL converter";
    homepage = "https://github.com/sl1pm4t/k2tf";
    license = licenses.mpl20;
    maintainers = [ maintainers.flokli ];
  };
}
