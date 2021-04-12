{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, withFzf ? true
, fzf
, libiconv
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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "ZeGFsVBpEhKi4EIhpQlCuriFzmHAgLYw3qE/zqfyqgU=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

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

  cargoSha256 = "Hzn01+OhdBrZD1woXN4Pwf/S72Deln1gyyBOWyDC6iM=";

  meta = with lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h SuperSandro2000 ];
  };
}
