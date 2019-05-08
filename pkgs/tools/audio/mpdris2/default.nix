{ stdenv, fetchurl, autoreconfHook, intltool
, python2Packages
}:

stdenv.mkDerivation rec {
  pname = "mpDris2";
  name = "${pname}-${version}";
  version = "0.8";

  src = fetchurl {
    url = "https://github.com/eonpatapon/${pname}/archive/${version}.tar.gz";
    sha256 = "14a3va3929qaq1sp9hs9w4bs6lykdvshkbc58kbsc5nzvlgmrcdn";
  };

  preConfigure = ''
    intltoolize -f
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ intltool python2Packages.wrapPython ];
  propagatedBuildInputs = with python2Packages; [ python pygtk dbus-python  ];
  pythonPath = with python2Packages; [ mpd pygtk dbus-python notify mutagen ];
  postInstall = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    description = "MPRIS 2 support for mpd";
    homepage = https://github.com/eonpatapon/mpDris2/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pjones ];
  };
}
