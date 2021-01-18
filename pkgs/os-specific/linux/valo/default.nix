{ lib, fetchFromGitHub, installShellFiles, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "valo";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n4rshhcwj5jd9wfadnvvnn6adqi747shj04snjizx1lqdyz5js9";
  };

  cargoSha256 = "1g9n7nxgasf8bw5iqpk87bhfxc0642ri16dnn12ha18917kng63z";

  postInstall = ''
    installShellCompletion --bash --name valo      completions/bash-completion/completions/valo
    installShellCompletion --fish --name valo.fish completions/fish/completions/valo.fish
    installShellCompletion --zsh  --name _valo     completions/zsh/site-functions/_valo
  '';

  nativeBuildInputs = [ installShellFiles ];

  meta = with lib; {
    description =
      "A Program to Control Backlights (and other Hardware Lights) in GNU/Linux";
    homepage = https://github.com/xrelkd/valo;
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
