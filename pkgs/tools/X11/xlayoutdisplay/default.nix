{ stdenv, fetchFromGitHub, xorg, boost, cmake, gtest }:

stdenv.mkDerivation rec {
  pname = "xlayoutdisplay";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ldqbwsryy7mqhxywdn2c2yi1mzlnl39sw8p3vx10w6q9drya9iv";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = with xorg; [ libX11 libXrandr libXcursor boost ];
  checkInputs = [ gtest ];

  doCheck = true;

  # format security fixup
  postPatch = ''
    substituteInPlace test/test-Monitors.cpp \
      --replace 'fprintf(lidStateFile, contents);' \
                'fputs(contents, lidStateFile);'

    substituteInPlace CMakeLists.txt --replace "set(Boost_USE_STATIC_LIBS ON)" ""
  '';

  meta = with stdenv.lib; {
    description = "Detects and arranges linux display outputs, using XRandR for detection and xrandr for arrangement";
    homepage = https://github.com/alex-courtis/xlayoutdisplay;
    maintainers = with maintainers; [ dtzWill ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
