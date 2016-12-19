{stdenv, fetchurl, perl, WWWMechanize, LWP, makeWrapper}:

stdenv.mkDerivation {
  name = "slimrat-1.0";
  src = fetchurl {
    url = http://slimrat.googlecode.com/files/slimrat-1.0.tar.bz2;
    sha256 = "139b71d45k4b1y47iq62a9732cnaqqbh8s4knkrgq2hx0jxpsk5a";
  };

  buildInputs = [ perl WWWMechanize LWP makeWrapper ];

  patchPhase = ''
    sed -e 's,#!.*,#!${perl}/bin/perl,' -i src/{slimrat,slimrat-gui}
  '';

  installPhase = ''
    mkdir -p $out/share/slimrat $out/bin
    cp -R src/* $out/share/slimrat
    # slimrat-gui does not work (it needs the Gtk2 perl package)
    for i in slimrat; do
      makeWrapper $out/share/slimrat/$i $out/bin/$i \
        --prefix PERL5LIB : $PERL5LIB
    done
  '';

  meta = {
    homepage = http://code.google.com/p/slimrat/;
    description = "Linux Rapidshare downloader";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };
}
