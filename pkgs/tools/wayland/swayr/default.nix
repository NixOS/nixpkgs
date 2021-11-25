{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayr";
  version = "0.10.0";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "v${version}";
    sha256 = "sha256-nXJIgzm92OSSGHpN2+09Y8ILpU8Mf51vcVB0kMXBPZc=";
  };

  cargoSha256 = "sha256-vExZzJ3Rw+MiU4ikEqzIo51qZW0sxwE/zoVEdUKLXwY=";

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
