{stdenv, patchelf, zlib, libmad, libpng12, libcaca, mesa, alsaLib, pulseaudio,
xlibs, plowshare}:

let

  inherit (xlibs) libXext libX11;

  lpath = "${stdenv.gcc.gcc}/lib64:" + stdenv.lib.makeSearchPath "lib" [
      zlib libmad libpng12 libcaca libXext libX11 mesa alsaLib pulseaudio];

in 
assert stdenv.is64bit;
stdenv.mkDerivation rec {

  name = "adom-1.20-noteye";

  src = stdenv.mkDerivation {
    name = "adom-1.20-noteye.tar.gz";
    buildCommand = ''
      ${plowshare}/bin/plowdown "http://www30.zippyshare.com/v/39200582/file.html"
      ls -lh
      F=`ls *tar.gz`
      echo "Checking $F"
      sha256sum -c <<EOF
      1f825845d5007e676a4d1a3ccd887904b959bdddbcb9f241c42c2dac34037669 $F
      EOF
      echo "Moving $F into $out..."
      mv $F $out
    '';
  };

  buildCommand = ''
    . $stdenv/setup

    unpackPhase

    mkdir -pv $out
    cp -r -t $out adom/*

    chmod u+w $out/lib
    for l in $out/lib/*so* ; do
      chmod u+w $l
      ${patchelf}/bin/patchelf \
        --set-rpath "$out/lib:${lpath}" \
        $l
    done

    ${patchelf}/bin/patchelf \
      --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath "$out/lib:${lpath}" \
      $out/adom

    mkdir $out/bin
    cat >$out/bin/adom <<EOF
    (cd $out; $out/adom ; )
    EOF
    chmod +x $out/bin/adom
  '';

  meta = {
    description = "Adom (Ancient Domains Of Mystery) is a rogue-like game with nice graphical interface";
    homepage = http://adom.de/;
    license = "unfree-redistributable";
    maintainers = [stdenv.lib.maintainers.smironov];

    # Please, notify me (smironov) if you need the x86 version
    platforms = ["x86_64-linux"];
  };
}


