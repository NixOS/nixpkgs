{ lib, fetchFromSourcehut, rustPlatform, makeWrapper, withPulseaudio ? false, pulseaudio }:

rustPlatform.buildRustPackage rec {
  pname = "swayrbar";
  version = "0.3.6";

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayrbar-${version}";
    sha256 = "sha256-Vv+Hw+iJAi2GnfkiYitDyH3H58tydUDa6GcWITok7Oc=";
  };

  cargoHash = "sha256-5alzkHzwuymo6bXFgabYQ3LWJDib0+ESQCSIPmINViY=";

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
  };
}
