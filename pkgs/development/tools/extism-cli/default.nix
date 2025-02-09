{
  lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "extism-cli";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "extism";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-StMipPMLSQzrhWv0yoKkNiuHMRW7QIhmVZ/M27WDWrM=";
  };

  modRoot = "./extism";

  vendorHash = "sha256-sSKiwYT5EP0FQJbhgv9ZFDwwwvIJ66yMULbj529AZwY=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false; # Tests require network access

  postInstall = ''
    local INSTALL="$out/bin/extism"
    installShellCompletion --cmd extism \
      --bash <($out/bin/containerlab completion bash) \
      --fish <($out/bin/containerlab completion fish) \
      --zsh <($out/bin/containerlab completion zsh)
  '';

  meta = with lib; {
    description = "The extism CLI is used to manage Extism installations";
    homepage = "https://github.com/extism/cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zshipko ];
    mainProgram = "extism";
    platforms = platforms.all;
  };
}
