{lib, stdenv, fetchurl, cmake, gettext}:

stdenv.mkDerivation rec {
  pname = "dfc";
  version = "3.1.1";

  src = fetchurl {
    url = "https://projects.gw-computing.net/attachments/download/615/${pname}-${version}.tar.gz";
    sha256 = "0m1fd7l85ckb7bq4c5c3g257bkjglm8gq7x42pkmpp87fkknc94n";
  };

  nativeBuildInputs = [ cmake gettext ];

  meta = {
    homepage = "https://projects.gw-computing.net/projects/dfc";
    description = "Displays file system space usage using graphs and colors";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [qknight];
    platforms = lib.platforms.all;
    mainProgram = "dfc";
  };
}
