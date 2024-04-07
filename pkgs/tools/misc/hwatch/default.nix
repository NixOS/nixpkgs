{ lib, fetchFromGitHub, rustPlatform, testers, hwatch, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "hwatch";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "blacknon";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-Klv1VIJv4/R7HvvB6H+WxTeJxQYFqAFU3HC6oafD/90=";
  };

  cargoHash = "sha256-Aos/QP8tLiKFmAZss19jn5h/murZR2jgTYRYalUONHw=";

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
