{ stdenv, fetchurl, makeWrapper, perl, perlPackages }:

let
  version = "1.1.29";

in

#note: bins-edit-gui does not work

stdenv.mkDerivation {
  name = "bins-${version}";

  src = fetchurl {
    url = "http://download.gna.org/bins/bins-${version}.tar.gz";
    sha256 = "0n4pcssyaic4xbk25aal0b3g0ibmi2f3gpv0gsnaq61sqipyjl94";
  };

  buildInputs = with perlPackages; [ makeWrapper perl
                                     ImageSize ImageInfo PerlMagick
                                     URI HTMLParser HTMLTemplate HTMLClean
                                     XMLGrove XMLHandlerYAWriter
                                     TextIconv TextUnaccent
                                     DateTimeFormatDateParse ]; #TODO need Gtk (not Gtk2?) for bins-edit-gui

  patches = [ ./bins_edit-isa.patch
              ./hashref.patch ];

  installPhase = ''
    export DESTDIR=$out;
    export PREFIX=.;

    echo | ./install.sh

    for f in bins bins_edit bins-edit-gui; do
      substituteInPlace $out/bin/$f \
        --replace /usr/bin/perl ${perl}/bin/perl \
        --replace /etc/bins $out/etc/bins \
        --replace /usr/local/share $out/share;
      wrapProgram $out/bin/$f --set PERL5LIB "$PERL5LIB";
    done
  '';

  meta = {
    description = "Generates static HTML photo albums";
    homepage = http://bins.sautret.org;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
