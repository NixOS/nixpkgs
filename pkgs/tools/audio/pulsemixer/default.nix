{ lib, stdenv, fetchFromGitHub, python3, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "pulsemixer";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "GeorgeFilipkin";
    repo = pname;
    rev = version;
    sha256 = "1jagx9zmz5pfsld8y2rj2kqg6ww9f6vqiawfy3vhqc49x3xx92p4";
  };

  inherit libpulseaudio;

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    install pulsemixer $out/bin/
  '';

  postFixup = ''
    substituteInPlace "$out/bin/pulsemixer" \
      --replace-fail "libpulse.so.0" "$libpulseaudio/lib/libpulse${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  meta = with lib; {
    description = "Cli and curses mixer for pulseaudio";
    homepage = "https://github.com/GeorgeFilipkin/pulsemixer";
    license = licenses.mit;
    maintainers = [ maintainers.woffs ];
    platforms = platforms.all;
    mainProgram = "pulsemixer";
  };
}
