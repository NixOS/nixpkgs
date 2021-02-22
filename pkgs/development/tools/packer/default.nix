{ lib, buildGoPackage, fetchFromGitHub, installShellFiles }:
buildGoPackage rec {
  pname = "packer";
  version = "1.7.0";

  goPackagePath = "github.com/hashicorp/packer";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "sha256-x62C44vTIysk9Lx9HZeTBf8k1+P5hfMIijvTWu3cZrA=";
  };

  buildFlagsArray = [ "-ldflags=-s -w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh go/src/${goPackagePath}/contrib/zsh-completion/_packer
  '';

  meta = with lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "https://www.packer.io";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ cstrahan zimbatm ma27 ];
    platforms   = platforms.unix;
  };
}
