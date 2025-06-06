{lib, stdenv, fetchgit, cmake, libGLU, libGL, xorg }:

stdenv.mkDerivation rec {
  pname = "glee";
  rev = "f727ec7463d514b6279981d12833f2e11d62b33d";
  version = "20170205-${lib.strings.substring 0 7 rev}";

  src = fetchgit {
    inherit rev;
    url = "https://git.code.sf.net/p/${pname}/${pname}";
    sha256 = "13mf3s7nvmj26vr2wbcg08l4xxqsc1ha41sx3bfghvq8c5qpk2ph";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libGLU libGL xorg.libX11 ];

  configureScript = ''
    cmake
  '';

  preInstall = ''
    sed -i 's/readme/Readme/' cmake_install.cmake
  '';

  meta = with lib; {
    description = "GL Easy Extension Library";
    homepage = "https://sourceforge.net/p/glee/glee/";
    maintainers = with maintainers; [ crertel ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
