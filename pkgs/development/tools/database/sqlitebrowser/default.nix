{ mkDerivation, lib, fetchFromGitHub, qtbase, qttools, sqlite, cmake }:

mkDerivation rec {
  version = "3.10.0";
  name = "sqlitebrowser-${version}";

  src = fetchFromGitHub {
    repo   = "sqlitebrowser";
    owner  = "sqlitebrowser";
    rev    = "v${version}";
    sha256 = "1fwr7p4b6glc3s0a06i7cg8l9p1mrcm4vyhyf2wi89cyg22rrf5c";
  };

  buildInputs = [ qtbase qttools sqlite ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DUSE_QT5=TRUE" ];

  # A regression was introduced in CMakeLists.txt on v3.9.x
  # See https://github.com/sqlitebrowser/sqlitebrowser/issues/832 and issues/755
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace 'project("DB Browser for SQLite")' 'project(sqlitebrowser)'
  '';

  meta = with lib; {
    description = "DB Browser for SQLite";
    homepage = http://sqlitebrowser.org/;
    license = licenses.gpl3;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux; # can only test on linux
  };
}
