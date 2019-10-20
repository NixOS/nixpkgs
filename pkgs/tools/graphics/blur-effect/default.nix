{ stdenv, fetchFromGitHub, pkgconfig, cmake, gdk-pixbuf, libGL, mesa }:

stdenv.mkDerivation rec {
  pname = "blur-effect";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "sonald";
    repo = pname;
    rev = version;
    sha256 = "0cjw7iz0p7x1bi4vmwrivfidry5wlkgfgdl9wly88cm3z9ib98jj";
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
  ];

  buildInputs = [
    gdk-pixbuf
    libGL
    mesa
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/sonald/blur-effect;
    description = "Off-screen image blurring utility using OpenGL ES 3.0";
    license = licenses.gpl3;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # packages 'libdrm' and 'gbm' not found
    maintainers = with maintainers; [ romildo ];
  };
}
