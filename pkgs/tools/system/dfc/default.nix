{stdenv, fetchurl, cmake, gettext}:

stdenv.mkDerivation rec {
  name = "dfc-${version}";
  version = "3.1.1";

  src = fetchurl {
    url = "https://projects.gw-computing.net/attachments/download/615/${name}.tar.gz";
    sha256 = "0m1fd7l85ckb7bq4c5c3g257bkjglm8gq7x42pkmpp87fkknc94n";
  };

  nativeBuildInputs = [ cmake gettext ];

  meta = {
    homepage = https://projects.gw-computing.net/projects/dfc;
    description = "Displays file system space usage using graphs and colors";
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [qknight];
    platforms = stdenv.lib.platforms.all;
  };
}
