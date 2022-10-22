{ lib, fetchFromGitHub, rustPlatform, testers, hwatch, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "hwatch";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "blacknon";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-FVqvwqsHkV/yK5okL1p6TiNUGDK2ZnzVNO4UDVkG+zM=";
  };

  cargoSha256 = "sha256-E4qh2cfpVNUa9OyJowSsaHU7pYiNu7IpxwISP0djVRA=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd hwatch \
      --bash $src/completion/bash/hwatch-completion.bash \
      --fish $src/completion/fish/hwatch.fish \
      --zsh $src/completion/zsh/_hwatch \
  '';

  passthru.tests.version = testers.testVersion {
    package = hwatch;
    command = "hwatch --version";
    version = version;
  };

  meta = with lib; {
    homepage = "https://github.com/blacknon/hwatch";
    description= "Modern alternative to the watch command";
    longDescription = ''
      A modern alternative to the watch command, records the differences in
      execution results and can check this differences at after.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ hamburger1984 ];
    platforms = platforms.linux;
  };
}
