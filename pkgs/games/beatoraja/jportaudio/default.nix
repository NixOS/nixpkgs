{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  jre,
  portaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jportaudio";
  version = "0-unstable-2026-02-13";

  src = fetchFromGitHub {
    owner = "philburk";
    repo = "portaudio-java";
    rev = "d185a5322ecbe8bd209e14e7341fb73d0c7d2cc3";
    hash = "sha256-XG1bJm0hDSF4cE2OvQ5bvN8pmaKwIl9zDlsRCnTXnLc=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    jre
    portaudio
  ];

  postInstall = ''
    # the jportaudio library bundled in beatoraja looks for libjportaudio.so instead
    ln -s $out/lib/libjportaudio_0_1_0.so $out/lib/libjportaudio.so
  '';

  meta = {
    description = "Java wrapper for the PortAudio audio library";
    homepage = "https://github.com/philburk/portaudio-java";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
})
