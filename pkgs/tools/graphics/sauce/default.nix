{ lib
, fetchFromGitHub
, buildGoModule
, installShellFiles
}:

buildGoModule rec {
  pname = "sauce";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "cadecuddy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DqJirsbNl8bJuuYZN9nKHMDCgs6agkdx7s0o7h90So8=";
  };

  vendorHash = "sha256-E7fMnrMtOrPPkWwUZ30MvwSmAKxgSb4MpEcqP4zFEck=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd sauce \
      --bash <($out/bin/sauce completion bash) \
      --fish <($out/bin/sauce completion fish) \
      --zsh <($out/bin/sauce completion zsh)
  '';

  meta = with lib; {
    description = "A CLI tool that identifies anime from an image";
    homepage = "https://github.com/cadecuddy/sauce";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
