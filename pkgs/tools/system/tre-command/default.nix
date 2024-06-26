{
  rustPlatform,
  fetchFromGitHub,
  lib,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "tre-command";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "tre";
    rev = "v${version}";
    sha256 = "sha256-JlkONhXMWLzxAf3SYoLkSvXw4bFYBnsCyyj0TUsezwg=";
  };

  cargoSha256 = "sha256-b3fScJMG/CIkMrahbELLQp1otmT5En+p8kQsip05SOc=";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    installManPage manual/tre.1
    installShellCompletion scripts/completion/tre.{bash,fish}
    installShellCompletion --zsh scripts/completion/_tre
  '';

  # this test requires package to be in a git repo to succeed
  checkFlags = [
    "--skip"
    "respect_git_ignore"
  ];

  meta = with lib; {
    description = "Tree command, improved";
    homepage = "https://github.com/dduan/tre";
    license = licenses.mit;
    maintainers = [ maintainers.dduan ];
    mainProgram = "tre";
  };
}
