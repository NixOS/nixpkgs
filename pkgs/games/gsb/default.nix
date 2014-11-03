{ stdenv, config, requireFile
, curl3, SDL, SDL_image, libpng12, libjpeg62, libvorbis, libogg, openal, mesa
, libX11, libXext, libXft, fontconfig, zlib }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "gsb-1.56.0";

  goBuyItNow = '' 
    We cannot download the full version automatically, as you require a license.
    Once you bought a license, you need to add your downloaded version to the nix store.
    You can do this by using "nix-prefetch-url file://gsb1324679796.tar.gz" in the
    directory where you saved it.
  ''; 

  src = requireFile {
     message = goBuyItNow;
     name = "gsb1324679796.tar.gz";
     sha256 = "12jsz9v55w9zxwiz4kbm6phkv60q3c2kyv5imsls13385pzwcs8i";
  };

  arch = if stdenv.system == "i686-linux" then "x86" else "x86_64";

  phases = "unpackPhase installPhase";

  # XXX: stdenv.lib.makeLibraryPath doesn't pick up /lib64
  libPath = stdenv.lib.makeLibraryPath [ stdenv.gcc.gcc stdenv.gcc.libc ] 
    + ":" + stdenv.lib.makeLibraryPath [ SDL SDL_image libjpeg62 libpng12 mesa ]
    + ":" + stdenv.lib.makeLibraryPath [ curl3 openal libvorbis libogg ]
    + ":" + stdenv.lib.makeLibraryPath [ libX11 libXext libXft fontconfig zlib ]
    + ":" + stdenv.gcc.gcc + "/lib64";

  installPhase = ''
    mkdir -p $out/libexec/positech/GSB/
    mkdir -p $out/bin

    patchelf \
      --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath $libPath \
      ./GSB.bin.$arch

    cp -r * $out/libexec/positech/GSB/
    rm -rf $out/libexec/positech/GSB/lib64/
    rm -rf $out/libexec/positech/GSB/lib/

    #makeWrapper doesn't do cd. :(

    cat > $out/bin/GSB << EOF
    #!/bin/sh
    cd $out/libexec/positech/GSB
    exec ./GSB.bin.$arch
    EOF
    chmod +x $out/bin/GSB
  '';

  meta = {
    description = "Gratuitous Space Battles";
    longDescription = ''
      a strategy / management / simulation game that does away with all the
      base building and delays and gets straight to the meat and potatoes of
      science-fiction games : The big space battles fought by huge spaceships with
      tons of laser beams and things going 'zap!', 'ka-boom!' and 'ka-pow!'. In GSB
      you put your ships together from modular components, arrange them into fleets,
      give your ships orders of engagement and then hope they emerge victorious from
      battle (or at least blow to bits in aesthetically pleasing ways).
    '';
    homepage = http://www.positech.co.uk/gratuitousspacebattles/index.html;
    license = [ "unfree" ];
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
    platforms = [ "x86_64-linux" "i686-linux" ] ;
  };

}
