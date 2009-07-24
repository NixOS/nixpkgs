{ stdenv, fetchurl, zlib, gd, texinfo
, libX11 ? null
, libXt ? null
, libXpm ? null
, libXaw ? null
, x11Support ? false
, readline
}:

assert x11Support -> ((libX11 != null) && 
    (libXt != null) && (libXpm != null) &&
    (libXaw != null));

stdenv.mkDerivation {
  # Gnuplot (which isn't open source) has a license that requires that
  # we "add special version identification to distinguish your version
  # in addition to the base release version number".  Hence the "nix"
  # suffix.
  name = "gnuplot-4.2.2-nix";

  src = fetchurl {
    url = mirror://sourceforge/gnuplot/gnuplot-4.2.2.tar.gz;
    sha256 = "14ca8wwdb4hdsgs51fqlrkcny3d4rm1vs54sfg5d0hr7iw2qlvvm";
  };

  configureFlags = if x11Support then ["--with-x"] else ["--without-x"];

  buildInputs = [zlib gd texinfo readline] ++
    (if x11Support then [libX11 libXt libXpm libXaw] else []);
}
