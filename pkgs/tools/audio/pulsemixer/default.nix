{ stdenv, fetchFromGitHub, python3, libpulseaudio }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "pulsemixer";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "GeorgeFilipkin";
    repo = pname;
    rev = version;
    sha256 = "0l5zawv36d46sj3k31k5w6imnnxzyn62r83wdhr7fp5mi3ls1h5x";
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
