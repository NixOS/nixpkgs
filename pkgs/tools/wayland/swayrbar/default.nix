{ lib, fetchFromSourcehut, rustPlatform, makeWrapper, withPulseaudio ? false, pulseaudio }:

rustPlatform.buildRustPackage rec {
  pname = "swayrbar";
  version = "0.3.7";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayrbar-${version}";
    sha256 = "sha256-41zlVT060Fu90N4oiZ6lWSZdJJSZjyk3GEA/u+bVNCI=";
  };

  cargoHash = "sha256-/MUolnEdYlBTfmUB/j9vHaVpU63upeMoScjHl38cGjo=";

  # don't build swayr
  buildAndTestSubdir = pname;

  nativeBuildInputs = [ makeWrapper ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = lib.optionals withPulseaudio ''
    wrapProgram "$out/bin/swayrbar" \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ pulseaudio ]}"
  '';

  meta = with lib; {
    description = "Status command for sway's swaybar implementing the swaybar-protocol";
    homepage = "https://git.sr.ht/~tsdh/swayr#a-idswayrbarswayrbara";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ sebtm ];
    mainProgram = "swayrbar";
  };
}
