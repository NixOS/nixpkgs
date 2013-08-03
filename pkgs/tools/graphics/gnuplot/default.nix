{ stdenv, fetchurl, zlib, gd, texinfo, makeWrapper, readline
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
, fontconfig ? null
, gnused ? null
, coreutils ? null }:

assert libX11 != null -> (fontconfig != null && gnused != null && coreutils != null);

stdenv.mkDerivation rec {
  name = "gnuplot-4.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/gnuplot/${name}.tar.gz";
    sha256 = "1xd7gqdhlk7k1p9yyqf9vkk811nadc7m4si0q3nb6cpv4pxglpyz";
  };

  buildInputs =
    [ zlib gd texinfo readline emacs lua texLive libX11 libXt libXpm libXaw
      pango cairo pkgconfig makeWrapper ]
    # compiling with wxGTK causes a malloc (double free) error on darwin
    ++ stdenv.lib.optional (!stdenv.isDarwin) wxGTK;

  configureFlags = if libX11 != null then ["--with-x"] else ["--without-x"];

  postInstall = stdenv.lib.optionalString (libX11 != null) ''
    wrapProgram $out/bin/gnuplot \
       --prefix PATH : '${gnused}/bin' \
       --prefix PATH : '${coreutils}/bin' \
       --prefix PATH : '${fontconfig}/bin' \
       --run '. ${./set-gdfontpath-from-fontconfig.sh}'
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.gnuplot.info;
    description = "A portable command-line driven graphing utility for many platforms";
    platforms   = platforms.all;
    maintainers = with maintainers; [ lovek323 ];
  };
}
