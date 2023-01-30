{ lib, buildGoModule, fetchFromGitHub, installShellFiles, runCommand, yq-go }:

buildGoModule rec {
  pname = "yq-go";
  version = "4.30.8";

  src = fetchFromGitHub {
    owner = "mikefarah";
    repo = "yq";
    rev = "v${version}";
    sha256 = "sha256-x0vdPi8/Iciy+22SPBpktgkQCMxd5PT674OsWaLi+Q0=";
  };

  vendorHash = "sha256-VEVy8iVnUUpjTmCj7uIMcz0jaG9XGuxA3U02QfIwsYs=";

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
