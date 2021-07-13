{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "packer";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "sha256-k5GCUFzjf0mipIQlnf7VCUS2j7cFwoGCeM7T6qgGnJA=";
  };

  vendorSha256 = "sha256-5Wb7WAUGXJ7VMWiQyboH3PXJazsqitD9N0Acd+WItaY=";

  subPackages = [ "." ];

  buildFlagsArray = [ "-ldflags=-s -w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh contrib/zsh-completion/_packer
  '';

  meta = with lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "https://www.packer.io";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ma27 ];
    platforms   = platforms.unix;
  };
}
