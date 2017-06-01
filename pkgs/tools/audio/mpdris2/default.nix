{ stdenv, fetchurl, autoreconfHook, intltool
, pythonPackages
}:

stdenv.mkDerivation rec {
  name = "mpDris2";
  version = "0.7";

  src = fetchurl {
    url = "https://github.com/eonpatapon/${name}/archive/${version}.tar.gz";
    sha256 = "095swrjw59lh8qiwmjjjdbxl9587axilkj4mh2sx5m0kiq929z21";
  };

  preConfigure = ''
    intltoolize -f
  '';

  buildInputs = [ intltool autoreconfHook pythonPackages.wrapPython ];
  propagatedBuildInputs = with pythonPackages; [ python pygtk dbus-python ];
  pythonPath = with pythonPackages; [ mpd pygtk dbus-python notify ];
  postInstall = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    description = "MPRIS 2 support for mpd";
    homepage = https://github.com/eonpatapon/mpDris2/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pjones ];
  };
}
