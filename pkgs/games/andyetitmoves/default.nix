{
  lib,
  stdenv,
  fetchurl,
  libvorbis,
  libogg,
  libtheora,
  SDL,
  libXft,
  SDL_image,
  zlib,
  libX11,
  libpng,
  openal,
  runtimeShell,
  requireFile,
  commercialVersion ? false,
}:

stdenv.mkDerivation rec {
  pname = "andyetitmoves";
  version = "1.2.2";

  src =
    if stdenv.hostPlatform.system == "i686-linux" || stdenv.hostPlatform.system == "x86_64-linux" then
      let
        postfix = if stdenv.hostPlatform.system == "i686-linux" then "i386" else "x86_64";
        commercialName = "${pname}-${version}_${postfix}.tar.gz";
        demoUrl = "http://www.andyetitmoves.net/demo/${pname}Demo-${version}_${postfix}.tar.gz";
      in
      if commercialVersion then
        requireFile {
          message = ''
            We cannot download the commercial version automatically, as you require a license.
            Once you bought a license, you need to add your downloaded version to the nix store.
            You can do this by using "nix-prefetch-url file:///\$PWD/${commercialName}" in the
            directory where yousaved it.
          '';
          name = commercialName;
          sha256 =
            if stdenv.hostPlatform.system == "i686-linux" then
              "15wvzmmidvykwjrbnq70h5jrvnjx1hcrm0357qj85q4aqbzavh01"
            else
              "1v8z16qa9ka8sf7qq45knsxj87s6sipvv3a7xq11pb5xk08fb2ql";
        }
      else
        fetchurl {
          url = demoUrl;
          sha256 =
            if stdenv.hostPlatform.system == "i686-linux" then
              "0f14vrrbq05hsbdajrb5y9za65fpng1lc8f0adb4aaz27x7sh525"
            else
              "0mg41ya0b27blq3b5498kwl4rj46dj21rcd7qd0rw1kyvr7sx4v4";
        }
    else
      throw "And Yet It Moves nix package only supports linux and intel cpu's.";

  installPhase = ''
    mkdir -p $out/{opt/andyetitmoves,bin}
    cp -r * $out/opt/andyetitmoves/

    fullPath=${stdenv.cc.cc.lib}/lib64
    for i in $nativeBuildInputs; do
      fullPath=$fullPath''${fullPath:+:}$i/lib
    done

    binName=${if commercialVersion then "AndYetItMoves" else "AndYetItMovesDemo"}

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath $fullPath $out/opt/andyetitmoves/lib/$binName
    cat > $out/bin/$binName << EOF
    #!${runtimeShell}
    cd $out/opt/andyetitmoves
    exec ./lib/$binName
    EOF
    chmod +x $out/bin/$binName
  '';

  buildInputs = [
    libvorbis
    libogg
    libtheora
    SDL
    libXft
    SDL_image
    zlib
    libX11
    libpng
    openal
  ];

  meta = with lib; {
    description = "Physics/Gravity Platform game";
    longDescription = ''
      And Yet It Moves is an award-winning physics-based platform game in which players rotate the game world at will to solve challenging puzzles. Tilting the world turns walls into floors, slides into platforms, and stacks of rocks into dangerous hazards.
    '';
    homepage = "http://www.andyetitmoves.net/";
    license = licenses.unfree;
    maintainers = with maintainers; [ bluescreen303 ];
  };
}
