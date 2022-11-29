{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "cirrus-cli";
  version = "0.91.0";

  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nJd7azn42IqIx8CXL7RHJFAZUaN0uq4FumHL3uGIx9U=";
  };

  vendorSha256 = "sha256-Llq6siZn34sHsZFneT+MLXf2W9cXqi4DZwrH1R5laOY=";

  ldflags = [
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Version=v${version}"
    "-X github.com/cirruslabs/cirrus-cli/internal/version.Commit=v${version}"
  ];

  # tests fail on read-only filesystem
  doCheck = false;

  meta = with lib; {
    description = "CLI for executing Cirrus tasks locally and in any CI";
    homepage = "https://github.com/cirruslabs/cirrus-cli";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ techknowlogick ];
    mainProgram = "cirrus";
  };
}
