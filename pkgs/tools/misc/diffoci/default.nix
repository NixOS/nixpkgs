{ lib
, stdenv
, buildPackages
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "diffoci";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "reproducible-containers";
    repo = "diffoci";
    rev = "v${version}";
    hash = "sha256-BTggky5behIxbVxyDZ09uobw0FBopboE9uUBEVgCgR4=";
  };

  vendorHash = "sha256-4C35LBxSm6EkcOznQY1hT2vX9bwFfps/q76VqqPKBfI=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/reproducible-containers/diffoci/cmd/diffoci/version.Version=v${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let
      diffoci = if stdenv.buildPlatform.canExecute stdenv.hostPlatform then placeholder "out" else buildPackages.diffoci;
    in
    ''
      installShellCompletion --cmd trivy \
        --bash <(${diffoci}/bin/diffoci completion bash) \
        --fish <(${diffoci}/bin/diffoci completion fish) \
        --zsh <(${diffoci}/bin/diffoci completion zsh)
    '';

  meta = with lib; {
    description = "Diff for Docker and OCI container images";
    homepage = "https://github.com/reproducible-containers/diffoci/";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk ];
    mainProgram = "diffoci";
  };
}
