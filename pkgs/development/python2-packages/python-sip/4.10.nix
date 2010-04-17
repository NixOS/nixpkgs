{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.10.1";
  
  src = fetchurl {
    url = "http://www.riverbankcomputing.co.uk/static/Downloads/sip4/${name}.tar.gz";
    sha256 = "16pdk86amcl4hnc9vv2y1ihl8ym9hjkh49andm4jahv4630qhc9h";
  };
  
  configurePhase = "python ./configure.py -d $out/lib/${python.libPrefix}/site-packages -b $out/bin -e $out/include";
  
  buildInputs = [ python ];
  
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
