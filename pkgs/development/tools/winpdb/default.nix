{ stdenv, fetchurl, buildPythonApplication, wxPython, makeDesktopItem }:

buildPythonApplication rec {
  name = "winpdb-1.4.8";
  namePrefix = "";

  src = fetchurl {
    url = "https://winpdb.googlecode.com/files/${name}.tar.gz";
    sha256 = "0vkpd24r40j928vc04c721innv0168sbllg97v4zw10adm24d8fs";
  };

  propagatedBuildInputs = [ wxPython ];

  desktopItem = makeDesktopItem {
    name = "winpdb";
    exec = "winpdb";
    icon = "winpdb";
    comment = "Platform independend Python debugger";
    desktopName = "Winpdb";
    genericName = "Python Debugger";
    categories = "Application;Development;Debugger;";
  };

  # Don't call gnome-terminal with "--disable-factory" flag, which is
  # unsupported since GNOME >= 3.10. Apparently, debian also does this fix:
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=757718
  postPatch = ''
    sed -i "s/--disable-factory//" rpdb2.py
  '';

  postInstall = ''
    mkdir -p "$out"/share/applications
    cp "$desktopItem"/share/applications/* "$out"/share/applications/

    mkdir -p "$out"/share/icons
    cp artwork/winpdb-icon.svg "$out"/share/icons/winpdb.svg
  '';

  meta = with stdenv.lib; {
    description = "Platform independent Python debugger";
    longDescription = ''
      Winpdb is a platform independent GPL Python debugger with support for
      multiple threads, namespace modification, embedded debugging, encrypted
      communication and is up to 20 times faster than pdb.
    '';
    homepage = http://winpdb.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
