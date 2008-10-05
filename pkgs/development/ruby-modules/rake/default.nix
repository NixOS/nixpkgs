{stdenv, fetchurl, ruby}:

stdenv.mkDerivation {
  name = "rake-0.8.1";
  src = fetchurl {
    url = "http://rubyforge.org/frs/download.php/29752/rake-0.8.1.tgz";
    sha256 = "1kggvkkj609hj1xvpadzchki66i7ynz3qq4nc2hmfkf536fx8c03";
  };
  buildInputs = [ruby];
  buildPhase = "true";
  installPhase = ''
    ensureDir $out/lib
    ensureDir $out/bin
    ruby setup.rb config --prefix=$out 
    # --bindir $out/bin --libdir $out/lib
    ruby setup.rb setup
    ruby setup.rb install
  '';
}
