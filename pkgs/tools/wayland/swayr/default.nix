{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayr";
  version = "0.16.1";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "v${version}";
    sha256 = "sha256-c/VHD5VceddhKanuId4rG1Tl+9Bg7zUmIqq4gMsy1e0=";
  };

  cargoSha256 = "sha256-0aGMWuU6DvBr9tvgDd1GZqhlY8bGCuPs8pSc5A03L3w=";

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
