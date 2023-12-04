{ lib, buildGoModule, fetchFromGitHub, installShellFiles, runCommand, yq-go }:

buildGoModule rec {
  pname = "yq-go";
  version = "4.40.4";

  src = fetchFromGitHub {
    owner = "mikefarah";
    repo = "yq";
    rev = "v${version}";
    hash = "sha256-cEOOaQAduL9a+EwWigzPDN1ABM6wEjEc8dV4ESFkMXA=";
  };

  vendorHash = "sha256-kFDW8HrBhSuflAbuC6Zs/61OLXPsfPQfYU7Laa7eK9c=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd yq \
      --bash <($out/bin/yq shell-completion bash) \
      --fish <($out/bin/yq shell-completion fish) \
      --zsh <($out/bin/yq shell-completion zsh)
  '';

  passthru.tests = {
    simple = runCommand "${pname}-test" { } ''
      echo "test: 1" | ${yq-go}/bin/yq eval -j > $out
      [ "$(cat $out | tr -d $'\n ')" = '{"test":1}' ]
    '';
  };

  meta = with lib; {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    changelog = "https://github.com/mikefarah/yq/raw/v${version}/release_notes.txt";
    mainProgram = "yq";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lewo SuperSandro2000 ];
  };
}
