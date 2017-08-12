{stdenv, fetchurl, cmake, gettext}:

stdenv.mkDerivation rec {
  name = "dfc-3.0.5";

  src = fetchurl {
    url = "http://projects.gw-computing.net/attachments/download/467/${name}.tar.gz";
    sha256 = "0yl5dl1nydinji71zz37c7myg3vg9jzxq89rcjqlfcy5dcfpm51w";
  };

  buildInputs = [ cmake gettext ];

  meta = {
    homepage = http://projects.gw-computing.net/projects/dfc;
    description = "Displays file system space usage using graphs and colors";
    license="free";
    maintainers = with stdenv.lib.maintainers; [qknight];
    platforms = with stdenv.lib.platforms; all;
  };
}

