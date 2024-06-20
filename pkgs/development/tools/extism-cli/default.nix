{
  lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "extism-cli";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "extism";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-b+X0pFrKhcfzucUM8akV061zslkdF1Jc9X1aqCqXagU=";
  };

  vendorHash = "sha256-5QSZDPRMlLVyOQGCSxNC5BBiuegschkHA0sWvOVAODI=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "./extism" ];

  doCheck = false; # Tests require network access

  postInstall = ''
    local INSTALL="$out/bin/extism"
    installShellCompletion --cmd extism \
      --bash <($out/bin/containerlab completion bash) \
      --fish <($out/bin/containerlab completion fish) \
      --zsh <($out/bin/containerlab completion zsh)
  '';

  meta = with lib; {
    description = "Extism CLI is used to manage Extism installations";
    homepage = "https://github.com/extism/cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zshipko ];
    mainProgram = "extism";
    platforms = platforms.all;
  };
}
