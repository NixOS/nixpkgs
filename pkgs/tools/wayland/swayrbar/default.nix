{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayrbar";
  version = "0.3.4";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayrbar-${version}";
    sha256 = "sha256-OQhq5ZUe2OrfRFxoaAbbewoHgQVPv9cQy0VCpYe1SNo=";
  };

  cargoHash = "sha256-vM4SoRbVylN90b378Qk18A8/2S2IB88lnGCM6sqrhs8=";

  # don't build swayr
  buildAndTestSubdir = pname;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Status command for sway's swaybar implementing the swaybar-protocol";
    homepage = "https://git.sr.ht/~tsdh/swayr#a-idswayrbarswayrbara";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ sebtm ];
  };
}
