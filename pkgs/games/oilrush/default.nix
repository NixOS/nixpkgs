{ stdenv, config, fetchurl, libX11, libXext, libXinerama, libXrandr
, libXrender, fontconfig, freetype, openal }:

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
  arch = if stdenv.system == "x86_64-linux" then "x64"
         else if stdenv.system == "i686-linux" then "x86"
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
      patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" $f
    done
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib:${libX11}/lib:${libXext}/lib:${libXrender}/lib:${fontconfig}/lib:${freetype}/lib\
             launcher_$arch
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib\
             libNetwork_$arch.so
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib\
             libQtCoreUnigine_$arch.so.4
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib:${libX11}/lib:${libXext}/lib:${libXrender}/lib:${fontconfig}/lib:${freetype}/lib\
             libQtGuiUnigine_$arch.so.4
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib\
             libQtNetworkUnigine_$arch.so.4
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib:${libX11}/lib:${libXext}/lib:${libXrender}/lib:${fontconfig}/lib:${freetype}/lib\
             libQtWebKitUnigine_$arch.so.4
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib\
             libQtXmlUnigine_$arch.so.4
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib\
             libRakNet_$arch.so
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib:${libX11}/lib:${libXext}/lib:${libXinerama}/lib:${libXrandr}/lib\
             libUnigine_$arch.so
    patchelf --set-rpath ${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib:${libX11}/lib:${libXext}/lib:${libXinerama}/lib:${libXrandr}/lib\
             OilRush_$arch
  '';
  installPhase = ''
    cd ..
    mkdir -p "$out/opt/oilrush"
    cp -r * "$out/opt/oilrush"
    mkdir -p "$out/bin"
    cat << EOF > "$out/bin/oilrush"
    #! /bin/sh
    LD_LIBRARY_PATH=.:${openal}/lib:\$LD_LIBRARY_PATH
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
    license = "unfree";
    #maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };

}
