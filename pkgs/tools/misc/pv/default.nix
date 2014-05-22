{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "pv-1.5.3";

  src = fetchurl {
    url = "http://www.ivarch.com/programs/sources/${name}.tar.bz2";
    sha256 = "03prg025kzivl1a5xqlf45szpnpqrmkzcvnf7lb2fc1v3jdrkwvn";
  };

  meta = {
    homepage = http://www.ivarch.com/programs/pv;
    description = "Tool for monitoring the progress of data through a pipeline";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
