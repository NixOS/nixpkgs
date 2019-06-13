{ stdenv, fetchFromGitHub, cmake, libX11, libxkbfile }:

stdenv.mkDerivation rec {
  name = "xkb-switch-${version}";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "ierton";
    repo = "xkb-switch";
    rev = version;
    sha256 = "03wk2gg3py97kx0kjzbjrikld1sa55i6mgi398jbcbiyx2gjna78";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libX11 libxkbfile ];

  meta = with stdenv.lib; {
    description = "Switch your X keyboard layouts from the command line";
    homepage = https://github.com/ierton/xkb-switch;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ smironov ];
    platforms = platforms.linux;
  };
}
