{ stdenv, fetchurl } :

stdenv.mkDerivation {
  name = "pv-1.2.0";

  src = fetchurl {
    url = http://pipeviewer.googlecode.com/files/pv-1.2.0.tar.bz2;
    sha256 = "0rn6rpiw7c16pgkhcslax9p1mxkxkmk6ivc9hjmsis7r69niyag3";
  };

  meta = {
    homepage = http://www.ivarch.com/programs/pv;
    description = "Tool for monitoring the progress of data through a pipeline";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
