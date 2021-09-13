{ lib, stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "pv-1.6.20";

  src = fetchurl {
    url = "https://www.ivarch.com/programs/sources/${name}.tar.bz2";
    sha256 = "00y6zla8h653sn4axgqz7rr0x79vfwl62a7gn6lzn607zwg9acg8";
  };

  meta = {
    homepage = "http://www.ivarch.com/programs/pv";
    description = "Tool for monitoring the progress of data through a pipeline";
    license = lib.licenses.artistic2;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; all;
  };
}
