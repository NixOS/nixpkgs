{ stdenv, fetchurl, autoreconfHook, intltool
, python, wrapPython, mpd, pygtk, dbus, pynotify
}:

stdenv.mkDerivation rec {
  name = "mpDris2-${version}";
  version = "0.6";

  src = fetchurl {
    url = "https://github.com/eonpatapon/mpDris2/archive/${version}.tar.gz";
    sha256 = "0zdmamj2ldhr6y3s464w8y2x3yizda784jnlrg3j3myfabssisvz";
  };

  makeFlags = [
    "DATADIRNAME=share"
  ];

  nativeBuildInputs = [ autoreconfHook intltool ];
  propagatedBuildInputs = [ python wrapPython ];
  pythonPath = [ dbus mpd pygtk pynotify ];
  postInstall = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    description = "MPRIS 2 support for mpd";
    homepage = https://github.com/eonpatapon/mpDris2/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pjones ];
  };
}
