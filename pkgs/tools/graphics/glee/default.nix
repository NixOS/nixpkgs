{stdenv, fetchgit, cmake, libGLU_combined, xorg }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "glee";
  rev = "f727ec7463d514b6279981d12833f2e11d62b33d";
  version = "20170205-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    inherit rev;
    url = "https://git.code.sf.net/p/${pname}/${pname}";
    sha256 = "13mf3s7nvmj26vr2wbcg08l4xxqsc1ha41sx3bfghvq8c5qpk2ph";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libGLU_combined xorg.libX11 ];

  configureScript = ''
    cmake
  '';

  preInstall = ''
    sed -i 's/readme/Readme/' cmake_install.cmake
  '';

  meta = with stdenv.lib; {
    description = "GL Easy Extension Library";
    homepage = https://sourceforge.net/p/glee/glee/;
    maintainers = with maintainers; [ nand0p ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
