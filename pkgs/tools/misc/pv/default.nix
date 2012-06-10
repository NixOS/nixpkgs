{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "pv-1.3.1";

  src = fetchurl {
    url = "http://pipeviewer.googlecode.com/files/${name}.tar.bz2";
    sha256 = "1fwvdj663g3jf3rcxi788pv1l7s86sxna78xi2nl5qimng05y8jl";
  };

  meta = {
    homepage = http://www.ivarch.com/programs/pv;
    description = "Tool for monitoring the progress of data through a pipeline";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
