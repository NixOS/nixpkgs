{ stdenv, fetchFromGitHub, xorg, boost, cmake, gtest }:

stdenv.mkDerivation rec {
  pname = "xlayoutdisplay";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wm6a48ym0wn2w0872mfq40ghajfrg1bccj1g342w899qh5x3bc4";
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
