{ stdenv, fetchFromGitHub, python3, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "pulsemixer";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "GeorgeFilipkin";
    repo = pname;
    rev = version;
    sha256 = "162nfpyqn4gp45x332a73n07c118vispz3jicin4p67x3f8f0g3j";
  };

  inherit libpulseaudio;

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    install pulsemixer $out/bin/
  '';

  postFixup = ''
    substituteInPlace "$out/bin/pulsemixer" \
      --replace "libpulse.so.0" "$libpulseaudio/lib/libpulse.so.0"
  '';

  meta = with stdenv.lib; {
    description = "Cli and curses mixer for pulseaudio";
    homepage = https://github.com/GeorgeFilipkin/pulsemixer;
    license = licenses.mit;
    maintainers = [ maintainers.woffs ];
    platforms = platforms.all;
  };
}
