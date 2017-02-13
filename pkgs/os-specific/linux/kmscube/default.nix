{ stdenv, fetchFromGitHub, autoreconfHook, libdrm, libX11, mesa_noglu, pkgconfig }:

stdenv.mkDerivation rec {
  name = "kmscube-2016-09-19";

  src = fetchFromGitHub {
    owner = "robclark";
    repo = "kmscube";
    rev = "8c6a20901f95e1b465bbca127f9d47fcfb8762e6";
    sha256 = "045pf4q3g5b54cdbxppn1dxpcn81h630vmhrixz1d5bcl822nhwj";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libdrm libX11 mesa_noglu ];

  meta = with stdenv.lib; {
    description = "Example OpenGL app using KMS/GBM";
    homepage = "https://github.com/robclark/kmscube";
    license = licenses.mit;
    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.linux;
  };
}
