{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  hwatch,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "hwatch";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "blacknon";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-3RFiVDXjPFBMK+f/9s9t3cdIH+R/88Fp5uKbo5p2X+g=";
  };

  cargoHash = "sha256-MC0Ch9ai4XmhhRz/9nFYEA3A7kgBv2x9q4yc5IJ7CZ8=";

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
