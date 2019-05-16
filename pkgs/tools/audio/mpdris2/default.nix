{ stdenv, fetchurl, autoreconfHook, intltool
, pythonPackages
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
  buildInputs = [ intltool pythonPackages.wrapPython ];
  propagatedBuildInputs = with pythonPackages; [ python pygtk dbus-python  ];
  pythonPath = with pythonPackages; [ mpd pygtk dbus-python notify mutagen ];
  postInstall = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    description = "MPRIS 2 support for mpd";
    homepage = https://github.com/eonpatapon/mpDris2/;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pjones ];
  };
}
