{ stdenv, lib, fetchFromGitHub, pkg-config, alsaLib, glib, json-glib }:

stdenv.mkDerivation {
  pname = "aseq2json";
  version = "unstable-2018-04-28";
  src = fetchFromGitHub {
    owner = "google";
    repo = "midi-dump-tools";
    rev = "8572e6313a0d7ec95492dcab04a46c5dd30ef33a";
    sha256 = "LQ9LLVumi3GN6c9tuMSOd1Bs2pgrwrLLQbs5XF+NZeA=";
  };
  sourceRoot = "source/aseq2json";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsaLib glib json-glib ];

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
}
