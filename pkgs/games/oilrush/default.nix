{ stdenv, config, fetchurl, libX11, libXext, libXinerama, libXrandr
, libXrender, fontconfig, freetype, openal }:

let inherit (stdenv.lib) makeLibraryPath; in

stdenv.mkDerivation {
  name = "oilrush";
  src = 
  let
    url = config.oilrush.url or null;
    sha256 = config.oilrush.sha256 or null;
  in
    assert url != null && sha256 != null;
    fetchurl { inherit url sha256; };
  shell = stdenv.shell;
  arch = if stdenv.hostPlatform.system == "x86_64-linux" then "x64"
         else if stdenv.hostPlatform.system == "i686-linux" then "x86"
         else "";
  unpackPhase = ''
    mkdir oilrush
    cd oilrush
    "$shell" "$src" --tar xf
  '';
  patchPhase = ''
    cd bin
    for f in launcher_$arch libQtCoreUnigine_$arch.so.4 OilRush_$arch
    do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f
    done
    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${makeLibraryPath [ stdenv.cc.cc libX11 libXext libXrender fontconfig freetype ]}\
             launcher_$arch
    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib\
             libNetwork_$arch.so
    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib\
             libQtCoreUnigine_$arch.so.4
    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${makeLibraryPath [ stdenv.cc.cc libX11 libXext libXrender fontconfig freetype ]}\
             libQtGuiUnigine_$arch.so.4
    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib\
             libQtNetworkUnigine_$arch.so.4
    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${makeLibraryPath [ stdenv.cc.cc libX11 libXext libXrender fontconfig freetype ]}\
             libQtWebKitUnigine_$arch.so.4
    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib\
             libQtXmlUnigine_$arch.so.4
    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib\
             libRakNet_$arch.so
    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${makeLibraryPath [ stdenv.cc.cc libX11 libXext libXinerama libXrandr ]}\
             libUnigine_$arch.so
    patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${makeLibraryPath [ stdenv.cc.cc libX11 libXext libXinerama libXrandr ]}\
             OilRush_$arch
  '';
  installPhase = ''
    cd ..
    mkdir -p "$out/opt/oilrush"
    cp -r * "$out/opt/oilrush"
    mkdir -p "$out/bin"
    cat << EOF > "$out/bin/oilrush"
    #!${stdenv.shell}
    LD_LIBRARY_PATH=.:${makeLibraryPath [ openal ]}:\$LD_LIBRARY_PATH
    cd "$out/opt/oilrush"
    exec ./launcher_$arch.sh "\$@"
    EOF
    chmod +x "$out/bin/oilrush"
  '';
  meta = {
    description = "A naval strategy game";
    longDescription = ''
      Oil Rush is a real-time naval strategy game based on group control. It
      combines the strategic challenge of a classical RTS with the sheer fun
      of Tower Defense. 
    '';
    homepage = http://oilrush-game.com/;
    license = stdenv.lib.licenses.unfree;
    #maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };

}
