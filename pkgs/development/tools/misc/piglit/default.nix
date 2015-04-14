{ stdenv, lib, fetchgit, cmake, glproto, libdrm, libpthreadstubs,
  libX11, libXau, libXdamage, libXdmcp, libXext, libxshmfence, libXxf86vm,
  makeWrapper, mesa, pkgconfig, python, pythonPackages, udev, waffle }:

stdenv.mkDerivation rec {
  name = "piglit-${version}";
  version = "a04c0af968922b694221899d6da5f5a752a304f8";

  src = fetchgit {
    url = git://anongit.freedesktop.org/git/piglit;
    rev = "${version}";
    sha256 = "6989b07fee2b3e716deaf37d948b62b05cfc74f77281a52fdc788b83666071c5";
  };

  patches = [
    # The wrapper provided with piglit expects itself to be named 'piglit.py'.
    # This patch accounts for the fact that wrapProgram will rename that
    # wrapper script to '.piglit-wrapped'.
    ./hack-for-wrapper.patch
  ];

  buildInputs = [ cmake glproto libdrm libpthreadstubs
    libX11 libXau libXdamage libXdmcp libXext libxshmfence libXxf86vm
    makeWrapper mesa pkgconfig python udev waffle ];
  propagatedBuildInputs = with pythonPackages; [ Mako numpy six ];

  postInstall = ''
    wrapProgram "$out"/bin/piglit --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  meta = with lib; {
    description = "Test suite for OpenGL implementations";
    homepage    = http://piglit.freedesktop.org/;
    license     = with licenses; [ mit gpl2 gpl3 bsd3 ];
    maintainers = with maintainers; [ auntie ];
    platforms   = platforms.linux;
  };
}
