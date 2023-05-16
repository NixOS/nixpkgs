<<<<<<< HEAD
{ lib, fetchFromSourcehut, rustPlatform, makeWrapper, withPulseaudio ? false, pulseaudio }:

rustPlatform.buildRustPackage rec {
  pname = "swayrbar";
  version = "0.3.6";
=======
{ lib, fetchFromSourcehut, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "swayrbar";
  version = "0.3.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~tsdh";
    repo = "swayr";
    rev = "swayrbar-${version}";
<<<<<<< HEAD
    sha256 = "sha256-Vv+Hw+iJAi2GnfkiYitDyH3H58tydUDa6GcWITok7Oc=";
  };

  cargoHash = "sha256-5alzkHzwuymo6bXFgabYQ3LWJDib0+ESQCSIPmINViY=";
=======
    sha256 = "sha256-uYQGwccSwqHJ1w8CyxXimmENnGx7e3EMA1MKZuZDTIk=";
  };

  cargoHash = "sha256-PdPaUqJUycUhleaND6XwKkRvwO0MHbvw5lzz95bdfCQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # don't build swayr
  buildAndTestSubdir = pname;

<<<<<<< HEAD
  nativeBuildInputs = [ makeWrapper ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preCheck = ''
    export HOME=$TMPDIR
  '';

<<<<<<< HEAD
  postInstall = lib.optionals withPulseaudio ''
    wrapProgram "$out/bin/swayrbar" \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ pulseaudio ]}"
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Status command for sway's swaybar implementing the swaybar-protocol";
    homepage = "https://git.sr.ht/~tsdh/swayr#a-idswayrbarswayrbara";
    license = with licenses; [ gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ sebtm ];
  };
}
