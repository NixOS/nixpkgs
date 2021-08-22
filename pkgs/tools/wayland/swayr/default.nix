{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayr";
  version = "0.6.2";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "v${version}";
    sha256 = "sha256-ZnZ9g8o1+VfhpDqxqtknNJ7dcyt5yuQcH3txxA3HICU=";
  };

  cargoSha256 = "sha256-0EhHFxbQi3Jgu13pXIjYYFYDEOQjwN5h+jE+22gJG0s=";

  patches = [
    ./icon-paths.patch
  ];

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
