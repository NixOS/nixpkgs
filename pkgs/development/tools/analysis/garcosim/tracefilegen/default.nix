{ stdenv, fetchgit, cmake }:

stdenv.mkDerivation rec {

  name = "tracefilegen-2015-11-14";

  src = fetchgit {
    url = "https://github.com/GarCoSim/TraceFileGen.git";
    rev = "4acf75b142683cc475c6b1c841a221db0753b404";
    sha256 = "0mh661l9d1lczv0mr2y9swzqqlwikyqiv1hdd71r9v8cvm54y5ij";
  };

  buildInputs = [ cmake ];

  builder = ./builder.sh;

  meta = with stdenv.lib; {
    description = "Automatically generate all types of basic memory management operations and write into trace files";
    homepage = https://github.com/GarCoSim; 
    maintainers = [ maintainers.cmcdragonkai ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

}
