{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "packer";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "sha256-Ey1gkld7WosJgoqnNp4Lz2x3PTI+w5p+A8Cwv4+uUZw=";
  };

  vendorSha256 = null;

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
