{stdenv, fetchurl, cmake, gettext}:

stdenv.mkDerivation rec {
  name = "dfc-3.0.4";

  src = fetchurl {
    url = "http://projects.gw-computing.net/attachments/download/79/dfc-3.0.4.tar.gz";
    sha256 = "0bdc2edb92c7f740a0b7d3fa75eb134adf197ba711bfa589ab51c691fabd617e";
  };

  buildInputs = [ cmake gettext ];

  meta = {
    homepage = "http://projects.gw-computing.net/projects/dfc";
    description = "displays file system space usage using graphs and colors";
    license="free";
    maintainers = with stdenv.lib.maintainers; [qknight];
    platforms = with stdenv.lib.platforms; all;
  };
}

