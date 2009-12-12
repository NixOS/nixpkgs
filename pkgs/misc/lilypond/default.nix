# note: there is a jedit plugin
args: with args;

stdenv.mkDerivation {
  name = "lilypond-2.13.3";

  /*
  # REGION AUTO UPDATE:    { name="lilypond"; type = "git"; url = "git://git.sv.gnu.org/lilypond.git"; }
  src= sourceFromHead "lilypond-7d065cae414aac445a40c0c6646c3baf6f358cb3.tar.gz"
               (throw "source not not published yet: lilypond");
  # END
  #preConfigure = "./autogen.sh";
  */

  src = fetchurl {
    url = http://download.linuxaudio.org/lilypond/sources/v2.13/lilypond-2.13.3.tar.gz;
    sha256 = "1ihnkgpd19q3sns7k6wvx4x1ccb1cw9ins3qasfs5n7srhc3cvac";
  };

  configureFlags = [ "--disable-documentation" "--with-ncsb-dir=${ghostscript}/share/ghostscript/fonts"];
  # configureFlags = "--disable-documentation";

  buildInputs = [
    automake autoconf
    ghostscript texinfo imagemagick texi2html guile texinfo
    python gettext flex perl bison pkgconfig texLive fontconfig freetype pango
    fontforge help2man];


  meta = { 
    description = "music typesetting system";
    homepage = http://lilypond.org/;
    license = "GPL";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };

  patches = [ ./findlib.patch ];
}
