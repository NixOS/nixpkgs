{stdenv, fetchurl, perlPackages, makeWrapper}:

stdenv.mkDerivation {
  name = "slimrat-1.0";
  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/slimrat/slimrat-1.0.tar.bz2";
    sha256 = "139b71d45k4b1y47iq62a9732cnaqqbh8s4knkrgq2hx0jxpsk5a";
  };

  buildInputs = [ makeWrapper ] ++ (with perlPackages; [ perl WWWMechanize LWP ]);

  patchPhase = ''
    sed -e 's,#!.*,#!${perlPackages.perl}/bin/perl,' -i src/{slimrat,slimrat-gui}
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
    homepage = https://code.google.com/archive/p/slimrat/;
    description = "Linux Rapidshare downloader";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
    broken = true; # officially abandonned upstream
  };
}
