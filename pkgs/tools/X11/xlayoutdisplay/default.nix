{ lib, stdenv, fetchFromGitHub, xorg, boost, gtest }:

stdenv.mkDerivation rec {
  pname = "xlayoutdisplay";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8K9SoZToJTk/sL4PC4Fcsu9XzGLYfNIZlbIyxc9jf84=";
  };

  buildInputs = with xorg; [ libX11 libXrandr libXcursor boost ];
  checkInputs = [ gtest ];

  doCheck = true;
  checkTarget = "gtest";

  # Fixup reference to hardcoded boost path, dynamically link as seems fine and we don't have static for this
  postPatch = ''
    substituteInPlace config.mk --replace '/usr/lib/libboost_program_options.a' '-lboost_program_options'
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Detects and arranges linux display outputs, using XRandR for detection and xrandr for arrangement";
    homepage = "https://github.com/alex-courtis/xlayoutdisplay";
    maintainers = with maintainers; [ dtzWill ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
