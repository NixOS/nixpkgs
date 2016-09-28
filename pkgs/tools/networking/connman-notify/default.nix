{ stdenv, fetchFromGitHub, pythonPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "connman-notify-${version}";
  version = "2014-06-23";

  src = fetchFromGitHub {
    owner = "wavexx";
    repo = "connman-notify";
    rev = "0ed9b5e4a0e1f03c83c4589cabf410cac66cd11d";
    sha256 = "0lhk417fdg3qxs1marpqp277bdxhwnbyrld9xj224bfk5v7xi4bg";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    pythonPackages.python
    pythonPackages.dbus-python
    pythonPackages.pygobject
    pythonPackages.pygtk
    pythonPackages.notify
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vai connman-notify $out/bin/
  '';

  preFixup = ''
    wrapProgram $out/bin/connman-notify --prefix PYTHONPATH : "$PYTHONPATH"
  '';  

  meta = with stdenv.lib; {
    description = "Desktop notification integration for connman";
    homepage = https://github.com/wavexx/connman-notify;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
