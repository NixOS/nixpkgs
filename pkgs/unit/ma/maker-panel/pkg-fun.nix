{ lib
, fetchFromGitHub
, rustPlatform
, go-md2man
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "maker-panel";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "twitchyliquid64";
    repo = "maker-panel";
    rev = version;
    sha256 = "0dlsy0c46781sb652kp80pvga7pzx6xla64axir92fcgg8k803bi";
  };

  cargoSha256 = "1ar62dn0khlbm47chakrsrxd1y76gpq0sql4g9j7dqqrvkavgd7w";

  nativeBuildInputs = [ go-md2man installShellFiles ];

  postBuild = ''
    go-md2man --in docs/spec-reference.md --out maker-panel.5
  '';

  postInstall = ''
    installManPage maker-panel.5
  '';

  meta = with lib; {
    description = "Make mechanical PCBs by combining shapes together.";
    homepage = "https://github.com/twitchyliquid64/maker-panel";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ twitchyliquid64 ];
  };
}
