{ stdenv, fetchurl, pkgconfig, libconfuse }:

stdenv.mkDerivation rec {
  name = "genimage-${version}";
  version = "9";

  src = fetchurl {
    url = "http://public.pengutronix.de/software/genimage/genimage-${version}.tar.xz";
    sha256 = "0y4h8x8lqxam8m90rdfq8cg5137kvilxr3d1qzddpx7nxpvmmwv9";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libconfuse ];

  postInstall = ''
    # As there is no manpage or built-in --help, add the README file for
    # documentation.
    docdir="$out/share/doc/genimage"
    mkdir -p "$docdir"
    cp -v README "$docdir"
  '';

  meta = with stdenv.lib; {
    homepage = https://git.pengutronix.de/cgit/genimage;
    description = "Generate filesystem images from directory trees";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
