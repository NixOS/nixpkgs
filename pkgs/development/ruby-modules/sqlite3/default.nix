{stdenv, fetchurl, ruby, sqlite}:

stdenv.mkDerivation {
  name = "ruby-sqlite3-1.2.4";
  src = fetchurl {
    url = http://rubyforge.org/frs/download.php/42055/sqlite3-ruby-1.2.4.tar.bz2; 
    sha256 = "1mmhlrggzdsbhpmifv1iibrf4ch3ycm878pxil3x3xhf9l6vp0a7";
  };
  buildInputs = [ruby sqlite];
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/lib
    ruby setup.rb config --prefix=$out 
    # --bindir $out/bin --libdir $out/lib
    ruby setup.rb setup
    ruby setup.rb install
  '';
}
