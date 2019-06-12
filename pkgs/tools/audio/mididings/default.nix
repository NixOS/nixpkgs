{ stdenv, pythonPackages, fetchurl, pkgconfig, glib, alsaLib, libjack2, libsmf }:

pythonPackages.buildPythonApplication rec {
  version = "20120419";
  pname = "mididings";

  src = fetchurl {
    url = "http://das.nasophon.de/download/mididings-${version}.tar.gz";
    sha256 = "0kfbryffl3568ilnh8r13xza8ikn1cf7mi31x65vmx891qlyr13z";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib alsaLib libjack2 pythonPackages.boost libsmf ];
  propagatedBuildInputs = with pythonPackages; [ decorator ]
    # for livedings
    ++ [ tkinter pyliblo ]
    # for mididings.extra
    ++ [ dbus-python pyinotify ];

  setupPyBuildFlags = [ "--enable-smf" ];

  preBuild = with stdenv.lib.versions; ''
    substituteInPlace setup.py \
      --replace /usr/lib "${pythonPackages.boost}/lib" \
      --replace boost_python "boost_python${major pythonPackages.python.version}${minor pythonPackages.python.version}"
  '';

  meta = with stdenv.lib; {
    description = "A MIDI router and processor based on Python, supporting ALSA and JACK MIDI";
    homepage = "http://das.nasophon.de/mididings";
    license = licenses.gpl2;
    maintainers = [ maintainers.gnidorah ];
    platforms = platforms.linux;
  };
}
