{ lib, python2Packages, fetchFromGitHub, pkg-config, glib, alsa-lib, libjack2  }:

python2Packages.buildPythonApplication {
  version = "2015-11-17";
  pname = "mididings";

  src = fetchFromGitHub {
    owner = "dsacre";
    repo = "mididings";
    rev = "bbec99a8c878a2a7029e78e84fc736e4a68ed5a0";
    sha256 = "1pdf5mib87zy7yjh9vpasja419h28wvgq6x5hw2hkm7bg9ds4p2m";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib alsa-lib libjack2 python2Packages.boost ];
  propagatedBuildInputs = with python2Packages; [ decorator ]
    # for livedings
    ++ [ tkinter pyliblo ]
    # for mididings.extra
    ++ [ dbus-python pyinotify ]
    # to read/write standard MIDI files
    ++ [ pysmf ]
    # so mididings knows where to look for config files
    ++ [ pyxdg ];

  preBuild = with lib.versions; ''
    substituteInPlace setup.py \
      --replace boost_python "boost_python${major python2Packages.python.version}${minor python2Packages.python.version}"
  '';

  meta = with lib; {
    description = "A MIDI router and processor based on Python, supporting ALSA and JACK MIDI";
    homepage = "http://das.nasophon.de/mididings";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
