{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packer";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    sha256 = "sha256-SaQGUVXtAI/FdqRZc4AjDkeEl9lE5i/wKsHKNGLpx8Y=";
  };

  vendorSha256 = "sha256-0GE5chSTonJFT7xomfa9a9QsnFpTFX7proo9joaDrOU=";

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
