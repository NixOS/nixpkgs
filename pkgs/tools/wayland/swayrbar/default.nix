{ lib, fetchFromSourcehut, rustPlatform, makeWrapper, withPulseaudio ? false, pulseaudio }:

rustPlatform.buildRustPackage rec {
  pname = "swayrbar";
  version = "0.3.8";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayrbar-${version}";
    sha256 = "sha256-pCXkgIesHqXI/m8ecytlq+U62lIrf7bOv95Hi/nyf/g=";
  };

  cargoHash = "sha256-RSdNYr6l9ayn9anczeGGh2rkKt6COqj+H71d14Gb8r0=";

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
