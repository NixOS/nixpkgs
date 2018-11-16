{ stdenv, lib, fetchgit, cmake, pkgconfig, git                                                                      
, qt5, openal, glew, vulkan-loader, libpng, ffmpeg, libevdev, python27                                              
, pulseaudioSupport ? true, libpulseaudio                                                                           
, waylandSupport ? true, wayland                                                                                    
, alsaSupport ? true, alsaLib                                                                                       
}:                                                                                                                  
                                                                                                                    
let                                                                                                                 
  majorVersion = "0.0.5";                                                                                           
  gitVersion = "6980-81e5f3b7f"; # echo $(git rev-list HEAD --count)-$(git rev-parse --short HEAD)                  
in                                                                                                                  
stdenv.mkDerivation rec {                                                                                           
  name = "rpcs3-${version}";                                                                                        
  version = "${majorVersion}-${gitVersion}";                                                                        
                                                                                                                    
  src = fetchgit {                                                                                                  
    url = "https://github.com/RPCS3/rpcs3";                                                                         
    rev = "81e5f3b7f299942f56bcfdde54edd09c722b32d8";                                                               
    sha256 = "0czj6ga1nccqgcvi58sjnv1cc4k7qvwijp4warml463hpsmbd9r0";                                                
  };                                                                                                                
                                                                                                                    
  preConfigure = ''                                                                                                 
    cat > ./rpcs3/git-version.h <<EOF                                                                               
    #define RPCS3_GIT_VERSION "${gitVersion}"                                                                       
    #define RPCS3_GIT_BRANCH "HEAD"                                                                                 
    #define RPCS3_GIT_VERSION_NO_UPDATE 1                                                                           
    EOF
  '';

  cmakeFlags = [
    "-DUSE_SYSTEM_LIBPNG=ON"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_NATIVE_INSTRUCTIONS=OFF"
  ];

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    qt5.qtbase qt5.qtquickcontrols openal glew vulkan-loader libpng ffmpeg libevdev python27
  ] ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional alsaSupport alsaLib
    ++ lib.optional waylandSupport wayland;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "PS3 emulator/debugger";
    homepage = "https://rpcs3.net/";
    maintainers = with maintainers; [ abbradar nocent ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
