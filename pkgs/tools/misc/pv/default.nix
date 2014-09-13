{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "pv-1.5.7";

  src = fetchurl {
    url = "http://www.ivarch.com/programs/sources/${name}.tar.bz2";
    sha256 = "15srxzyssr8l25bl3rws476nx3fl58bdlh55gyv8cc3hpdhm0ly8";
  };

  meta = {
    homepage = http://www.ivarch.com/programs/pv;
    description = "Tool for monitoring the progress of data through a pipeline";
    license = "Artistic-2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
