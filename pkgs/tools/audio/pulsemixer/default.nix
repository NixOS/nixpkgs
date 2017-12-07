{ stdenv, fetchFromGitHub, python3, libpulseaudio }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "pulsemixer";
  version = "1.3.0-license";

  src = fetchFromGitHub {
    owner = "GeorgeFilipkin";
    repo = pname;
    rev = version;
    sha256 = "186xbzyn35w2j58l68mccj0cnf0wxj93zb7s0r26zj4cppwszn90";
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
