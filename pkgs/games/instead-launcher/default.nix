{ stdenv, fetchFromGitHub, instead, qmake4Hook, zlib }:

stdenv.mkDerivation rec {
  name = "instead-launcher-${version}";

  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "instead-hub";
    repo = "instead-launcher";
    rev = version;
    sha256 = "1q0hdgfy9pr48zvxr9x614ka6bd0g8sicdk2a673nwfdyd41p9cw";
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
