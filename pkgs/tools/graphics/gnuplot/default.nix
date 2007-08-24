{stdenv, fetchurl, zlib, libpng, texinfo,
	libX11 ? null,
	libXt ? null,
	libXpm ? null,
	libXaw ? null,
	x11Support ? false
}:

assert x11Support -> ((libX11 != null) && 
	(libXt != null) && (libXpm != null) &&
	(libXaw != null));

stdenv.mkDerivation {
  # Gnuplot (which isn't open source) has a license that requires that
  # we "add special version identification to distinguish your version
  # in addition to the base release version number".  Hence the "nix"
  # suffix.
  name = "gnuplot-4.0-nix";

#  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/gnuplot/gnuplot-4.0.0.tar.gz;
    md5 = "66258443d9f93cc4f46b147dac33e63a";
  };

  configureFlags = if x11Support then ["--with-x"] else ["--without-x"];

  buildInputs = [zlib libpng texinfo] ++
	(if x11Support then [libX11 libXt libXpm libXaw] else []);
}
