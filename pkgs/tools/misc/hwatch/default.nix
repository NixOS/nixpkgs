{ lib, fetchFromGitHub, rustPlatform, testers, hwatch, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "hwatch";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "blacknon";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-RvsL6OajXwEY77W3Wj6GMijYwn7XDnKiJyDXbNG01ag=";
  };

  cargoHash = "sha256-v7MvXnc9Xa+6QAyi2N9/WtqnvXf9M1SlR86kNjfu46Y=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd hwatch \
      --bash $src/completion/bash/hwatch-completion.bash \
      --fish $src/completion/fish/hwatch.fish \
      --zsh $src/completion/zsh/_hwatch \
  '';

  passthru.tests.version = testers.testVersion {
    package = hwatch;
<<<<<<< HEAD
=======
    command = "hwatch --version";
    version = version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    homepage = "https://github.com/blacknon/hwatch";
<<<<<<< HEAD
    description = "Modern alternative to the watch command";
=======
    description= "Modern alternative to the watch command";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      A modern alternative to the watch command, records the differences in
      execution results and can check this differences at after.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ hamburger1984 ];
<<<<<<< HEAD
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
