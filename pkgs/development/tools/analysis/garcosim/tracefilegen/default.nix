{ stdenv, fetchgit, cmake }:

stdenv.mkDerivation rec {

  name = "tracefilegen";

  src = fetchgit {
    url = "https://github.com/GarCoSim/TraceFileGen.git";
    rev = "4acf75b142683cc475c6b1c841a221db0753b404";
    sha256 = "69b056298cf570debd3718b2e2cb7e63ad9465919c8190cf38043791ce61d0d6";
  };

  buildInputs = [ cmake ];

  builder = ./builder.sh;
  
  meta = with stdenv.lib; {
    description = "Automatically generate all types of basic memory management operations and write into trace files";
    homepage = "https://github.com/GarCoSim";
    license = licenses.gpl2;
    platforms = platforms.all;
  };

}
