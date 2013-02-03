{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "pv-1.3.4";

  src = fetchurl {
    url = "http://www.ivarch.com/programs/sources/${name}.tar.bz2";
    sha256 = "114b730pghgg4gv9d798817n3am88p2b0xgdavch1vhklzh33c16";
  };

  meta = {
    homepage = http://www.ivarch.com/programs/pv;
    description = "Tool for monitoring the progress of data through a pipeline";
    license = "free";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
