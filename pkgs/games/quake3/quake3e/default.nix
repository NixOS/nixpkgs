{ stdenv, curl, libGL, libX11, libXxf86dga, alsaLib, libXrandr, libXxf86vm, libXext, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "Quake3e";
  version = "2020-01-23";

  src = fetchFromGitHub {
    owner = "ec-";
    repo = pname;
    rev = version;
    sha256 = "0crqn32nkqhlagamkp5nr0vl474ad4wx5ms7yr85s6zybpsk5jnz";
  };

  buildInputs = [ curl libGL libX11 libXxf86dga alsaLib libXrandr libXxf86vm libXext ];
  enableParallelBuilding = true;

  postPatch = ''
    sed -i -e 's#OpenGLLib = dlopen( dllname#OpenGLLib = dlopen( "${libGL}/lib/libGL.so"#' code/unix/linux_qgl.c
    sed -i -e 's#Sys_LoadLibrary( "libasound.so.2" )#Sys_LoadLibrary( "${alsaLib}/lib/libasound.so.2" )#' code/unix/linux_snd.c
    sed -i -e 's#Sys_LoadLibrary( "libXrandr.so.2" )#Sys_LoadLibrary( "${libXrandr}/lib/libXrandr.so.2" )#' code/unix/x11_randr.c
    sed -i -e 's#Sys_LoadLibrary( "libXxf86vm.so.1" )#Sys_LoadLibrary( "${libXxf86vm}/lib/libXxf86vm.so.1" )#' code/unix/x11_randr.c
    sed -i -e 's#Sys_LoadLibrary( "libXxf86dga.so.1" )#Sys_LoadLibrary( "${libXxf86dga}/lib/libXxf86dga.so.1" )#' code/unix/x11_dga.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/*/*x64 $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ec-/Quake3e;
    description = "Improved Quake III Arena engine";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pmiddend ];
    badPlatforms = [ platforms.aarch64 ];
  };  
}
