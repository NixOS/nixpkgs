{ buildGoModule, lib, fetchFromGitHub, installShellFiles }:
buildGoModule rec {
  pname = "aws-vault";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "99designs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0892fhjmxnms09bfbjnngnnnli2d4nkwq44fw98yb3d5lbpa1j1j";
  };

  vendorSha256 = "18lmxx784377x1v0gr6fkdx5flhcajsqlzyjx508z0kih6ammc0z";

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
