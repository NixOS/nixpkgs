{ lib, stdenv, fetchurl, cmake, pkg-config, boost, gd, libogg, libtheora, libvorbis }:

stdenv.mkDerivation rec {
  pname = "oggvideotools";
  version = "0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/oggvideotools/oggvideotools/oggvideotools-${version}/oggvideotools-${version}.tar.bz2";
    sha256 = "sha256-2dv3iXt86phhIgnYC5EnRzyX1u5ssNzPwrOP4+jilSM=";
  };

  patches = [
    ./fix-compile.patch
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ boost gd libogg libtheora libvorbis ];

  meta = with lib; {
    description = "Toolbox for manipulating and creating Ogg video files";
    homepage = "http://www.streamnik.de/oggvideotools.html";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
