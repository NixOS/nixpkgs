{ stdenv, requireFile, SDL, libpulseaudio, alsaLib }:

stdenv.mkDerivation rec {
  name = "vessel-12082012";

  goBuyItNow = '' 
    We cannot download the full version automatically, as you require a license.
    Once you bought a license, you need to add your downloaded version to the nix store.
    You can do this by using "nix-prefetch-url file://${name}-bin" in the
    directory where you saved it.
  ''; 

  src = if (stdenv.isi686) then
    requireFile {
      message = goBuyItNow;
      name = "${name}-bin";
      sha256 = "1vpwcrjiln2mx43h7ib3jnccyr3chk7a5x2bw9kb4lw8ycygvg96";
    } else throw "unsupported platform ${stdenv.system} only i686-linux supported for now.";

  phases = "installPhase";
  ld_preload = ./isatty.c;

  libPath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc stdenv.cc.libc ] 
    + ":" + stdenv.lib.makeLibraryPath [ SDL libpulseaudio alsaLib ] ;

  installPhase = ''
    mkdir -p $out/libexec/strangeloop/vessel/
    mkdir -p $out/bin

    # allow scripting of the mojoinstaller
    gcc -fPIC -shared -o isatty.so $ld_preload

    echo @@@ 
    echo @@@ this next step appears to hang for a while
    echo @@@ 

    # if we call ld.so $(bin) we don't need to set the ELF interpreter, and save a patchelf step. 
    LD_PRELOAD=./isatty.so $(cat $NIX_CC/nix-support/dynamic-linker) $src << IM_A_BOT
    n
    $out/libexec/strangeloop/vessel/
    IM_A_BOT

    # use nix SDL libraries
    rm $out/libexec/strangeloop/vessel/x86/libSDL*
    rm $out/libexec/strangeloop/vessel/x86/libstdc++*

    # props to Ethan Lee (the Vessel porter) for understanding
    # how $ORIGIN works in rpath. There is hope for humanity. 
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $libPath:$out/libexec/strangeloop/vessel/x86/ \
      $out/libexec/strangeloop/vessel/x86/vessel.x86

    # we need to libs to find their deps
    for lib in $out/libexec/strangeloop/vessel/x86/lib* ; do
    patchelf \
      --set-rpath $libPath:$out/libexec/strangeloop/vessel/x86/ \
      $lib
    done

    cat > $out/bin/Vessel << EOW
    #!/bin/sh
    cd $out/libexec/strangeloop/vessel/
    exec ./x86/vessel.x86
    EOW

    chmod +x $out/bin/Vessel
  '';

  meta = with stdenv.lib; {
    description = "A fluid physics based puzzle game";
    longDescription = ''
      Living liquid machines have overrun this world of unstoppable progress,
      and it is the role of their inventor, Arkwright, to stop the chaos they are
      causing. Vessel is a game about a man with the power to bring ordinary matter
      to life, and all the consequences that ensue.
    '';
    homepage = http://www.strangeloopgames.com;
    license = licenses.unfree;
    maintainers = with maintainers; [ jcumming ];
  };

}
