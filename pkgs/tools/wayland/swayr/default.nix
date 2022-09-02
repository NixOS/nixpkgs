{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayr";
  version = "0.20.1";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayr-${version}";
    sha256 = "sha256-kHFo5FJMzPRlnYg5iER1ULThhfJ0pY5apJNXPyHrMzE=";
  };

  cargoSha256 = "sha256-Tm+LSL13COfKyH2021oiKme2yO9jurQ/F+U2y9klz18=";

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
