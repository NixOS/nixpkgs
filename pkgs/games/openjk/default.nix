{ stdenv, fetchFromGitHub, makeWrapper, cmake, libjpeg, zlib, libpng, mesa_noglu, SDL2 }:

stdenv.mkDerivation rec {
  name = "OpenJK-2017-08-11";

  src = fetchFromGitHub {
    owner = "JACoders";
    repo = "OpenJK";
    rev = "a0828f06e0181c62e110f2f78d30acb5036b4113";
    sha256 = "1wbb643z2nyhyirzzy3rz03wjqglwmsgnj7w5cl8167f9f9j9w0m";
  };

  dontAddPrefix = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [ makeWrapper cmake ];
  buildInputs = [ libjpeg zlib libpng mesa_noglu SDL2 ];

  # move from $out/JediAcademy to $out/opt/JediAcademy
  preConfigure = ''
    cmakeFlagsArray=("-DCMAKE_INSTALL_PREFIX=$out/opt")
  '';

  postInstall = ''
    mkdir -p $out/bin
    prefix=$out/opt/JediAcademy
    makeWrapper $prefix/openjk.* $out/bin/jamp --run "cd $prefix"
    makeWrapper $prefix/openjk_sp.* $out/bin/jasp --run "cd $prefix"
    makeWrapper $prefix/openjkded.* $out/bin/openjkded --run "cd $prefix"
  '';

  meta = with stdenv.lib; {
    description = "An open-source engine for Star Wars Jedi Academy game";
    homepage = https://github.com/JACoders/OpenJK;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnidorah ];
  };
}
