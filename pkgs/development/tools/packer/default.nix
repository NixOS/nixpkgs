{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packer";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "sha256-jdJD7AW4IrzVl4BPdsFFrRSdCWX9l4nFM+DWIuxLiJ8=";
  };

  vendorSha256 = "sha256-ufvWgusTMbM88F3BkJ61KM2wRSdqPOlMKqDSYf7tZQA=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh contrib/zsh-completion/_packer
  '';

  meta = with lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "https://www.packer.io";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ma27 techknowlogick ];
    changelog   = "https://github.com/hashicorp/packer/blob/v${version}/CHANGELOG.md";
    platforms   = platforms.unix;
  };
}
