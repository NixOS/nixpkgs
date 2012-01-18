{stdenv, fetchurl, ruby}:

stdenv.mkDerivation {
  name = "rake-0.8.1";
  src = fetchurl {
    url = "http://rubyforge.org/frs/download.php/29752/rake-0.8.1.tgz";
    sha256 = "1kggvkkj609hj1xvpadzchki66i7ynz3qq4nc2hmfkf536fx8c03";
  };
  buildInputs = [ruby];
  patchPhase = ''
    sed -i install.rb \
        -e 's/$bindir  = destdir + $bindir/prefix = CONFIG["prefix"];$bindir = $bindir.slice(prefix.length..$bindir.length);$bindir = destdir + $bindir/' \
        -e 's/$sitedir = destdir + $sitedir/$sitedir = $sitedir.slice(prefix.length..$sitedir.length);$sitedir = destdir + $sitedir/'
  '';
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/bin
    export DESTDIR=$out
    ruby install.rb
  '';
}
