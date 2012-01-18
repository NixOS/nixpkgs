{ stdenv, fetchurl, gtk, glib, pkgconfig, mesa, wxGTK, libX11, xproto }:

stdenv.mkDerivation {
  name = "fsg-4.4";

  src = fetchurl {
    url = http://www.piettes.com/fallingsandgame/fsg-src-4.4.tar.gz;
    sha256 = "1756y01rkvd3f1pkj88jqh83fqcfl2fy0c48mcq53pjzln9ycv8c";
  };

  buildInputs = [ gtk glib pkgconfig mesa wxGTK libX11 xproto ];

/*  
#	One day Unicode will overcome?

	preBuild = "
		sed -e '
			s/\\(str\\.Printf(\\)\\(\".*\"\\)/\\1_(\\2)/; 
			s@\\<fopen(\\([^\"),]\\+\\)@fopen(wxConvertWX2MB(\\1)@
			s@\\<wxString(\\([^)]\\+\\)@wxString(wxConvertMB2WX(\\1)@
			s/\\(wxString str(\\)\\(\".*\"\\)/\\1_(\\2)/; 
			' -i MainFrame.cpp Canvas.cpp;
		sed -e '
		s@\\(^[^\"]*([^\"]*[^(]\\|^[^\"].*[^_](\\)\\(\"\\([^\"]\\|\\\"\\)*\"\\)@\\1_(\\2)@;
		' -i DownloadFileDialog.cpp;
		sed -e '
		s@currentProbIndex != 100@0@;
		' -i MainFrame.cpp;
		cp -r . /tmp/fsg
	";*/

  preBuild = ''
    sed -e '
      s@currentProbIndex != 100@0@;
    ' -i MainFrame.cpp
  '';

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp sand $out/libexec
    echo -e '#! /bin/sh\nLC_ALL=C '$out'/libexec/sand "$@"' >$out/bin/fsg
    chmod a+x $out/bin/fsg
  '';

  meta = {
    description = "Falling Sand Game - a cellular automata engine tuned towards the likes of Falling Sand";
  };
}
