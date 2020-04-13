{ stdenv, fetchFromGitHub, cmake, libX11, libxkbfile }:

stdenv.mkDerivation rec {
  pname = "xkb-switch";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ierton";
    repo = "xkb-switch";
    rev = version;
    sha256 = "11yn0y1kx04rqxh0d81b5q7kbyz58pi48bl7hyhlv7p8yndkfg4b";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libX11 libxkbfile ];

  meta = with stdenv.lib; {
    description = "Switch your X keyboard layouts from the command line";
    homepage = "https://github.com/ierton/xkb-switch";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ smironov ];
    platforms = platforms.linux;
  };
}
