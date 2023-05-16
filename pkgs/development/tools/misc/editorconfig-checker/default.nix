{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, editorconfig-checker }:

buildGoModule rec {
  pname = "editorconfig-checker";
<<<<<<< HEAD
  version = "2.7.1";
=======
  version = "2.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-TycKc6Zgf9QFTH3lfNC+/O52cp2xhKsKflxuQTac794=";
=======
    hash = "sha256-8qGRcyDayXx3OflhE9Kw2AXM702/2pYB3JgfpQ0UYR8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-S93ZvC92V9nrBicEv1yQ3DEuf1FmxtvFoKPR15e8VmA=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-X main.version=${version}" ];

  postInstall = ''
    installManPage docs/editorconfig-checker.1
  '';

  passthru.tests.version = testers.testVersion {
    package = editorconfig-checker;
  };

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/editorconfig-checker/editorconfig-checker/releases/tag/${src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "A tool to verify that your files are in harmony with your .editorconfig";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva zowoq ];
  };
}
