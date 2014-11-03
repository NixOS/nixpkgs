{ stdenv, config, requireFile, fetchurl
, libX11, libXext, libXau, libxcb, libXdmcp , SDL, SDL_mixer, libvorbis, mesa
, demo ? false }:

# TODO: add i686 support

stdenv.mkDerivation rec {
  name = if demo 
    then "WorldOfGooDemo-1.41"
    else "WorldofGoo-1.41";

  arch = if stdenv.system == "x86_64-linux" then "supported"
    else throw "Sorry. World of Goo only is only supported on x86_64 now.";

  goBuyItNow = '' 
    We cannot download the full version automatically, as you require a license.
    Once you bought a license, you need to add your downloaded version to the nix store.
    You can do this by using "nix-prefetch-url file://WorldOfGooSetup.1.41.tar.gz" in the
    directory where you saved it.

    Or you can install the demo version: 'nix-env -i -A pkgs.worldofgoo_demo'. 
  ''; 

  getTheDemo = ''
    We cannot download the demo version automatically, please go to
    http://worldofgoo.com/dl2.php?lk=demo, then add it to your nix store.
    You can do this by using "nix-prefetch-url file://WorldOfGooDemo.1.41.tar.gz" in the
    directory where you saved it.
  '';

  src = if demo 
    then 
      requireFile {
         message = getTheDemo;
         name = "WorldOfGooDemo.1.41.tar.gz";
         sha256 = "0ndcix1ckvcj47sgndncr3hxjcg402cbd8r16rhq4cc43ibbaxri";
       }
    else
      requireFile {
        message = goBuyItNow;
        name = "WorldOfGooSetup.1.41.tar.gz";
        sha256 = "0rj5asx4a2x41ncwdby26762my1lk1gaqar2rl8dijfnpq8qlnk7";
      };

  phases = "unpackPhase installPhase";

  # XXX: stdenv.lib.makeLibraryPath doesn't pick up /lib64
  libPath = stdenv.lib.makeLibraryPath [ stdenv.gcc.gcc stdenv.gcc.libc ] 
    + ":" + stdenv.lib.makeLibraryPath [libX11 libXext libXau libxcb libXdmcp SDL SDL_mixer libvorbis mesa ]
    + ":" + stdenv.gcc.gcc + "/lib64";

  installPhase = ''
    mkdir -p $out/libexec/2dboy/WorldOfGoo/
    mkdir -p $out/bin

    patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" --set-rpath $libPath ./WorldOfGoo.bin64

    cp -r * $out/libexec/2dboy/WorldOfGoo/

    #makeWrapper doesn't do cd. :(

    cat > $out/bin/WorldofGoo << EOF
    #!/bin/sh
    cd $out/libexec/2dboy/WorldOfGoo
    exec ./WorldOfGoo.bin64
    EOF
    chmod +x $out/bin/WorldofGoo
  '';

  meta = {
    description = "A physics based puzzle game";
    longDescription = ''
      World of Goo is a physics based puzzle / construction game. The millions of Goo
      Balls who live in the beautiful World of Goo don't know that they are in a
      game, or that they are extremely delicious.
    '';
    homepage = http://worldofgoo.com;
    license = [ "unfree" ];
    maintainers = with stdenv.lib.maintainers; [ jcumming ];
  };

}
