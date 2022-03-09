{ lib, fetchFromGitHub, installShellFiles, buildGoModule }:

buildGoModule rec {
  pname = "autorestic";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "cupcakearmy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JOiFsH9r92Gac7DH7h/4Q6hwXBtqLwHNQpW3gKBybHo=";
  };

  vendorSha256 = "sha256-WzmgV0wUsGfMVeho6M8wXJKD9adaAKRYmaJYaAcXwFc=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd autorestic \
         --bash <($out/bin/autorestic completion bash) \
         --fish <($out/bin/autorestic completion fish) \
         --zsh <($out/bin/autorestic completion zsh)
  '';

  meta = with lib; {
    description = "High level CLI utility for restic";
    homepage = "https://github.com/cupcakearmy/autorestic";
    license = licenses.asl20;
    maintainers = with maintainers; [ renesat ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
