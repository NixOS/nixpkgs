{ stdenv, fetchgit, cmake, libX11 }:

stdenv.mkDerivation rec {
  name = "xkb-switch-${version}";
  version = "1.3.1";

  src = fetchgit {
    url = https://github.com/ierton/xkb-switch.git;
    rev = "351c84370ad0fa4aaaab9a32817859b1d5fb2a11";
    sha256 = "0ilj3amwidi7imjvi8hr62y7j8zl809r5xhs7kv816773x32gpxq";
  };

  buildInputs = [ cmake libX11 ];

  meta = with stdenv.lib; {
    description = "Switch your X keyboard layouts from the command line";

    homepage = https://github.com/ierton/xkb-switch;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ smironov ];
    platforms = platforms.linux;
  };
}

