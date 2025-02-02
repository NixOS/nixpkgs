{
  lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "extism-cli";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "extism";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-t0SbjTuM298Cka2zhavR6bOGDriz2XUGcfAy25se7M4=";
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
    description = "The extism CLI is used to manage Extism installations";
    homepage = "https://github.com/extism/cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zshipko ];
    mainProgram = "extism";
    platforms = platforms.all;
  };
}
