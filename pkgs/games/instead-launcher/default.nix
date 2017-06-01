{ stdenv, fetchFromGitHub, instead, qmake4Hook, zlib }:

stdenv.mkDerivation rec {
  name = "instead-launcher-${version}";

  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "instead-hub";
    repo = "instead-launcher";
    rev = version;
    sha256 = "1svy8i8anspway01pnz2cy69aad03anvkq04wrdfv1h9c34gbvb9";
  };

  patches = [ ./path.patch ];

  postPatch = ''
    substituteInPlace platform.cpp --subst-var-by instead ${instead}
  '';

  nativeBuildInputs = [ qmake4Hook ];

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = https://instead.syscall.ru/wiki/en/instead-launcher;
    description = "Install and play games from INSTEAD repository";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
