{ stdenv, lib, fetchFromGitHub, pkg-config, alsa-lib, glib, json-glib }:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "aseq2json";
  version = "unstable-2018-04-28";
  src = fetchFromGitHub {
    owner = "google";
    repo = "midi-dump-tools";
    rev = "8572e6313a0d7ec95492dcab04a46c5dd30ef33a";
    sha256 = "LQ9LLVumi3GN6c9tuMSOd1Bs2pgrwrLLQbs5XF+NZeA=";
  };
<<<<<<< HEAD
  sourceRoot = "${finalAttrs.src.name}/aseq2json";
=======
  sourceRoot = "source/aseq2json";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib glib json-glib ];

  installPhase = ''
    install -D --target-directory "$out/bin" aseq2json
  '';

  meta = with lib; {
    description = "Listens for MIDI events on the Alsa sequencer and outputs as JSON to stdout";
    homepage = "https://github.com/google/midi-dump-tools";
    license = licenses.asl20;
    maintainers = [ maintainers.queezle ];
    platforms = platforms.linux;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
