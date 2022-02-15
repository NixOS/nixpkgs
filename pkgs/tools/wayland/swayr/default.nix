{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayr";
  version = "0.13.0";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "v${version}";
    sha256 = "sha256-V4ETsraJo9X10fPMGSuiokPiSlZGYHncOdfheGom1go=";
  };

  cargoSha256 = "sha256-3ErzkS8u+4Ve26jpDbsYr4BVDm/XEgydYdZ2ErtVuVA=";

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
