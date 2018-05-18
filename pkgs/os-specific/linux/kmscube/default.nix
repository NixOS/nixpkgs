{ stdenv, fetchgit, autoreconfHook, libdrm, libX11, libGL, mesa_noglu, pkgconfig }:

stdenv.mkDerivation rec {
  name = "kmscube-2017-03-19";

  src = fetchgit {
    url = git://anongit.freedesktop.org/libGLU_combined/kmscube;
    rev = "b88a44d95eceaeebc5b9c6972ffcbfe9eca00aea";
    sha256 = "029ccslfavz6jllqv980sr6mj9bdbr0kx7bi21ra0q9yl2vh0yca";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libdrm libX11 libGL mesa_noglu ];

  meta = with stdenv.lib; {
    description = "Example OpenGL app using KMS/GBM";
    homepage = https://github.com/robclark/kmscube;
    license = licenses.mit;
    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.linux;
  };
}
