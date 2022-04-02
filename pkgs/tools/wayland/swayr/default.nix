{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayr";
  version = "0.15.0";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "v${version}";
    sha256 = "sha256-GLOJjGr29v4oVNCWgjPWluIiSeLoIYeOw2HwmSfxA8Y=";
  };

  cargoSha256 = "sha256-gg/IHrgfDZT+3FNM/se5X1YMcHX127jMNI/WDEpMzy4=";

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
