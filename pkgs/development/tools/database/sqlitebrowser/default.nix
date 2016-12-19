{ stdenv, fetchFromGitHub, qt4, sqlite, cmake }:

stdenv.mkDerivation rec {
  version = "3.8.0";
  name = "sqlitebrowser-${version}";

  src = fetchFromGitHub {
    repo   = "sqlitebrowser";
    owner  = "sqlitebrowser";
    rev    = "v${version}";
    sha256 = "009yaamf6f654dl796f1gmj3rb34d55w87snsfgk33gpy6x19ccp";
  };

  buildInputs = [ qt4 sqlite cmake ];

  meta = with stdenv.lib; {
    description = "DB Browser for SQLite";
    homepage = "http://sqlitebrowser.org/";
    license = licenses.gpl3;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux; # can only test on linux
  };
}

