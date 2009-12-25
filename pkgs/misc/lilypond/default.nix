# note: there is a jedit plugin
args: with args;

stdenv.mkDerivation {
  name = "lilypond-2.13.9";

  /*
  # REGION AUTO UPDATE:    { name="lilypond"; type = "git"; url = "git://git.sv.gnu.org/lilypond.git"; }
  src= sourceFromHead "lilypond-7d065cae414aac445a40c0c6646c3baf6f358cb3.tar.gz"
               (throw "source not not published yet: lilypond");
  # END
  #preConfigure = "./autogen.sh";
  */

  src = fetchurl {
    url = http://download.linuxaudio.org/lilypond/sources/v2.13/lilypond-2.13.9.tar.gz;
    sha256 = "1x3jz0zbhly4rc07nry3ia3ydd6vislz81gg0ivwfm6f6q0ssk57";
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
