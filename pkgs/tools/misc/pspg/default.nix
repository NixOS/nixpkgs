{ stdenv, fetchFromGitHub, gnugrep, ncurses, pkgconfig, readline }:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "pspg";
    rev = version;
    sha256 = "0nfc1cv2l2v1rav5jj7jz5wyb2df5l3iwrvvpkvxxpv3qll8kcfv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnugrep ncurses readline ];

  preBuild = ''
    makeFlags="PREFIX=$out PKG_CONFIG=${pkgconfig}/bin/pkg-config"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/okbob/pspg;
    description = "Postgres Pager";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.jlesquembre ];
  };
}
