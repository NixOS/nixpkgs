{ stdenv, fetchFromGitHub, glfw, pkgconfig, libXrandr, libXdamage,
  libXext, libXrender, libXinerama, libXcursor, libXxf86vm, libXi,
  libX11, mesa_glu }:

stdenv.mkDerivation rec {
  name = "glslviewer-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "patriciogonzalezvivo";
    repo = "glslViewer";
    rev = version;
    sha256 = "05ya821l2pd58anyx21mgmlm2bv78rz8cnbvqw4d9pfhq40z9psw";
  };

  # Makefile has /usr/local/bin hard-coded for 'make install'
  preConfigure = ''
    sed s,/usr/local,$out, -i Makefile
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';
  
  buildInputs = [ glfw mesa_glu pkgconfig glfw libXrandr libXdamage
                  libXext libXrender libXinerama libXcursor libXxf86vm
                  libXi libX11 ];
  
  meta = with stdenv.lib; {
    description = "Live GLSL coding renderer";
    homepage = http://patriciogonzalezvivo.com/2015/glslViewer/;
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.hodapp ];
  };
}
