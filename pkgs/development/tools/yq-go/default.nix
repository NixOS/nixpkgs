{ lib, buildGoModule, fetchFromGitHub, installShellFiles, runCommand, yq-go }:

buildGoModule rec {
  pname = "yq-go";
<<<<<<< HEAD
  version = "4.35.1";
=======
  version = "4.33.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mikefarah";
    repo = "yq";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-L0F3e2SsBAI6b3lrBJl9W2392ZlW0jHwJJ7MlvJ64es=";
  };

  vendorHash = "sha256-XJW7ftx+V7H22EraQZlRFi+Li8fsl7ZALVnaiuE1rXI=";
=======
    hash = "sha256-hsADk1h9bxqgvIddU0JTIv/uSJnukoJb39i0tngnImE=";
  };

  vendorHash = "sha256-EW2coQdrFfs6xYeJb+6gab8+CVT3O8x4cSRuj1o+3ok=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
    changelog = "https://github.com/mikefarah/yq/raw/v${version}/release_notes.txt";
    mainProgram = "yq";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ lewo SuperSandro2000 ];
  };
}
