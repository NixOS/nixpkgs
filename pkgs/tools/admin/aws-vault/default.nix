{ buildGoModule, lib, fetchFromGitHub, installShellFiles }:
buildGoModule rec {
  pname = "aws-vault";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bmqmT/gkdgczrDfZdI+FySX5CuesJXWKS0JatzaubIw=";
  };

  vendorSha256 = "sha256-Lb5iiuT/Fd3RMt98AafIi9I0FHJaSpJ8pH7r4yZiiiw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd aws-vault \
      --bash $src/contrib/completions/bash/aws-vault.bash \
      --fish $src/contrib/completions/fish/aws-vault.fish \
      --zsh $src/contrib/completions/zsh/aws-vault.zsh
  '';


  doCheck = false;

  subPackages = [ "." ];

  # set the version. see: aws-vault's Makefile
  buildFlagsArray = ''
    -ldflags=
    -X main.Version=v${version}
  '';

  meta = with lib; {
    description =
      "A vault for securely storing and accessing AWS credentials in development environments";
    homepage = "https://github.com/99designs/aws-vault";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
