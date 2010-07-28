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
, readline
}:

stdenv.mkDerivation {
  name = "gnuplot-4.4.0";
  
  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/gnuplot-4.4.0.tar.gz";
    sha256 = "0akb2lzxa3b0j4nr6anr0mhsk10b1fcnixk8vk9aa82rl1a2rph0";
  };

  configureFlags = if libX11 != null then ["--with-x"] else ["--without-x"];

  buildInputs =
    [ zlib gd texinfo readline emacs lua texLive libX11 libXt libXpm libXaw
      wxGTK pango cairo pkgconfig
    ];
}
