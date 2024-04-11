{ lib, fetchFromGitHub, rustPlatform, testers, hwatch, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "hwatch";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "blacknon";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-S6hnmNnwdWd6iFM01K52oiKXiqu/0v5yvKKoeQMEqy0=";
  };

  cargoHash = "sha256-P4XkbV6QlokedKumX3UbCfEaAqH9VF9IKVyZIumZ6u0=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd hwatch \
      --bash $src/completion/bash/hwatch-completion.bash \
      --fish $src/completion/fish/hwatch.fish \
      --zsh $src/completion/zsh/_hwatch \
  '';

  passthru.tests.version = testers.testVersion {
    package = hwatch;
  };

  meta = with lib; {
    homepage = "https://github.com/blacknon/hwatch";
    description = "Modern alternative to the watch command";
    longDescription = ''
      A modern alternative to the watch command, records the differences in
      execution results and can check this differences at after.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ hamburger1984 ];
    mainProgram = "hwatch";
  };
}
