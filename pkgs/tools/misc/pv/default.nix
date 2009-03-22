{ stdenv, fetchurl } :

stdenv.mkDerivation {
  name = "pv-1.1.4";

  src = fetchurl {
    url = http://pipeviewer.googlecode.com/files/pv-1.1.4.tar.bz2;
    sha256 = "c8613c240ab4297f6ad346f0047138f551a093c603eeb581d5e83091cad3a559";
  };

  meta = {
    homepage = http://www.ivarch.com/programs/pv;
    description = "Tool for monitoring the progress of data through a pipeline";
    license = "free";
  };
}
