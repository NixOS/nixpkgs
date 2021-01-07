{ stdenv, fetchFromGitHub, cmake, nasm }:

stdenv.mkDerivation rec {
  pname = "svt-av1";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "AOMediaCodec";
    repo = "SVT-AV1";
    rev = "v${version}";
    sha256 = "1wzamg89azi1f93wxvdy7silsgklckc754ca066k33drvyacicyw";
  };

  nativeBuildInputs = [ cmake nasm ];

  meta = with stdenv.lib; {
    description = "AV1-compliant encoder/decoder library core";
    homepage = "https://github.com/AOMediaCodec/SVT-AV1";
    license = licenses.bsd2;
    platforms = platforms.unix;
    broken = stdenv.isAarch64; # undefined reference to `cpuinfo_arm_linux_init'
    maintainers = with maintainers; [ chiiruno ];
  };
}
