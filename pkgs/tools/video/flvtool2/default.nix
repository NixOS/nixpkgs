{ stdenv, fetchurl, ruby }:

stdenv.mkDerivation rec {
  name = "flvtool2-1.0.6";
  
  src = fetchurl {
    url = "http://rubyforge.org/frs/download.php/17497/${name}.tgz";
    sha256 = "1pbsf0fvqrs6xzfkqal020bplb68dfiz6c5sfcz36k255v7c5w9a";
  };

  buildInputs = [ ruby ];

  configurePhase =
    ''
      substituteInPlace bin/flvtool2 --replace "/usr/bin/env ruby" "ruby -I$out/lib/ruby/site_ruby/1.8"
      ruby setup.rb config --prefix=$out --siterubyver=$out/lib/ruby/site_ruby/1.8
    '';
  
  installPhase =
    ''
      ruby setup.rb install
    '';

  meta = {
    homepage = http://www.inlet-media.de/flvtool2/;
    description = "A tool to manipulate Macromedia Flash Video files";
  };
}
