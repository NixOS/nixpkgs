{ stdenv, fetchurl, zlib, gd, texinfo
, texLive ? null
, lua ? null
, emacs ? null
, libX11 ? null
, libXt ? null
, libXpm ? null
, libXaw ? null
, wxGTK ? null
, pango ? null
, cairo ? null
, pkgconfig ? null
, x11Support ? false
, readline
}:

assert x11Support -> ((libX11 != null) &&
    (libXt != null) && (libXpm != null) &&
    (libXaw != null));

assert (wxGTK != null) -> x11Support;

stdenv.mkDerivation {
  name = "gnuplot-4.4.0";
  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/gnuplot-4.4.0.tar.gz";
    sha256 = "0akb2lzxa3b0j4nr6anr0mhsk10b1fcnixk8vk9aa82rl1a2rph0";
  };

  configureFlags = if x11Support then ["--with-x"] else ["--without-x"];

  buildInputs = [zlib gd texinfo readline emacs lua texLive] ++
    (if x11Support then [libX11 libXt libXpm libXaw] else []) ++
    (if wxGTK != null then [wxGTK pango cairo pkgconfig] else []);
}
