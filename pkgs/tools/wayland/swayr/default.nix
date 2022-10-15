{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayr";
  version = "0.22.0";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayr-${version}";
    sha256 = "sha256-HThKeuFe4slqakQE1QAfu3SMUL/Gq9DodnAKcU/gTEY=";
  };

  cargoSha256 = "sha256-c13u5EWRrTd9HbL6oLMd4xeQyAncrx5OjzW7FwPIBsE=";

  patches = [
    ./icon-paths.patch
  ];

  # don't build swayrbar
  buildAndTestSubdir = pname;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "A window switcher (and more) for sway";
    homepage = "https://git.sr.ht/~tsdh/swayr";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ artturin ];
  };
}
