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

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
  version = "0.5.0";

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

  cargoSha256 = "0hpln1cyvgifn7vpp0spggcgirm3xx3b5cl2hi7xykd243vxdfxv";

  meta = with lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h SuperSandro2000 ];
  };
}
