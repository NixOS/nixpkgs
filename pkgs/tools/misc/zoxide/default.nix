{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, withFzf ? true
, fzf

  # checkInputs
, fish
, powershell
, shellcheck
, shfmt
, xonsh
, zsh
}:
let
  version = "0.5.0";
in
rustPlatform.buildRustPackage {
  pname = "zoxide";
  inherit version;

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "143lh94mw31pm9q7ib63h2k842g3h222mdabhf25hpb19lka2w5y";
  };

  # tests are broken on darwin
  doCheck = !stdenv.isDarwin;

  # fish needs a writable HOME for whatever reason
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkInputs = [
    fish
    powershell
    shellcheck
    shfmt
    xonsh
    zsh
  ];

  postPatch = lib.optionalString withFzf ''
    substituteInPlace src/fzf.rs \
      --replace '"fzf"' '"${fzf}/bin/fzf"'
  '';

  cargoSha256 = "05mp101yk1zkjj1gwbkldizq6f9f8089gqgvq42c4ngq88pc7v9a";

  meta = with lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h ];
  };
}
