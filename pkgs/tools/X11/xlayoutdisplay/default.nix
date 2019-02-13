{ stdenv, fetchFromGitHub, xorg, boost, cmake, gtest }:

stdenv.mkDerivation rec {
  name = "xlayoutdisplay-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "xlayoutdisplay";
    rev = "v${version}";
    sha256 = "1cqn98lpx9rkfhavbqalaaljw351hvqsrszgqnwvcyq05vq26dwx";
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

  '';

  meta = with stdenv.lib; {
    description = "Detects and arranges linux display outputs, using XRandR for detection and xrandr for arrangement";
    homepage = https://github.com/alex-courtis/xlayoutdisplay;
    maintainers = with maintainers; [ dtzWill ];
    license = licenses.asl20;
  };
}
