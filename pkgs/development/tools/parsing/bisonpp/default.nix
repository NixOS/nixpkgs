{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "bisonpp";
  version = "1.21-45";

  src = fetchFromGitHub {
    owner = "jarro2783";
    repo = "bisonpp";
    rev = version;
    sha256 = "0mp6cvbm2rfjwff3n9xz0gfxmdamad55nlr9f5q5dy0h6c43mh8x";
  };

  meta = with stdenv.lib; {
    description = "The original bison++ project, brought up to date with modern compilers";
    homepage = https://github.com/jarro2783/bisonpp;
    license = licenses.gpl2;
    maintainers = with maintainers; [ costrouc ];
    platforms = platforms.all;
  };
}
