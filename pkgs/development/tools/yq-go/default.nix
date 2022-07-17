{ lib, buildGoModule, fetchFromGitHub, installShellFiles, runCommand, yq-go }:

buildGoModule rec {
  pname = "yq-go";
  version = "4.26.1";

  src = fetchFromGitHub {
    owner = "mikefarah";
    repo = "yq";
    rev = "v${version}";
    sha256 = "sha256-5EDFttaUgef2/EQUSORY17UjbErCjVDdy3Dls1mMYLQ=";
  };

  vendorSha256 = "sha256-w9TaCYxu3a8R3oCfyNyioe2W9PrejhTj/3eaBeg7UAw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd yq \
      --bash <($out/bin/yq shell-completion bash) \
      --fish <($out/bin/yq shell-completion fish) \
      --zsh <($out/bin/yq shell-completion zsh)
  '';

  passthru.tests = {
    simple = runCommand "${pname}-test" {} ''
      echo "test: 1" | ${yq-go}/bin/yq eval -j > $out
      [ "$(cat $out | tr -d $'\n ')" = '{"test":1}' ]
    '';
  };

  meta = with lib; {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    mainProgram = "yq";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lewo SuperSandro2000 ];
  };
}
