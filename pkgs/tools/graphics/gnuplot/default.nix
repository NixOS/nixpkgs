{ stdenv, fetchurl, zlib, gd, texinfo, makeWrapper
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
, fontconfig ? null, gnused ? null, coreutils ? null
}:

assert libX11 != null -> (fontconfig != null && gnused != null && coreutils != null);

stdenv.mkDerivation rec {
  name = "gnuplot-4.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/${name}.tar.gz";
    sha256 = "1ghp1jbcf95yy09lqhjcfmvb6y2101qfdbf20zs42dcs0fsssq3f";
  };

  buildInputs =
    [ zlib gd texinfo readline emacs lua texLive libX11 libXt libXpm libXaw
      wxGTK pango cairo pkgconfig makeWrapper
    ];

  configureFlags = if libX11 != null then ["--with-x"] else ["--without-x"];

  postInstall = stdenv.lib.optionalString (libX11 != null) ''
    wrapProgram $out/bin/gnuplot \
       --prefix PATH : '${gnused}/bin' \
       --prefix PATH : '${coreutils}/bin' \
       --prefix PATH : '${fontconfig}/bin' \
       --run '. ${./set-gdfontpath-from-fontconfig.sh}'
  '';

  meta = {
    homepage = "http://www.gnuplot.info";
    description = "A portable command-line driven graphing utility for many platforms";
    platforms = stdenv.lib.platforms.all;
  };
}
