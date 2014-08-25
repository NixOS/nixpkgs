{ stdenv, patchelf, zlib, libmad, libpng12, libcaca, mesa, alsaLib, pulseaudio
, xlibs, plowshare }:

assert stdenv.isLinux;

let

  inherit (xlibs) libXext libX11;

  lpath = "${stdenv.gcc.gcc}/lib64:" + stdenv.lib.makeSearchPath "lib" [
      zlib libmad libpng12 libcaca libXext libX11 mesa alsaLib pulseaudio];

in
assert stdenv.is64bit;
stdenv.mkDerivation rec {

  name = "adom-1.2.0-noteye";

  # couldn't make fetchurl appear non-robot, even with --user-agent
  src = stdenv.mkDerivation {
    name = "adom-1.2.0-noteye.tar.gz";
    buildCommand = ''
      ${plowshare}/bin/plowdown "http://www30.zippyshare.com/v/39200582/file.html"
      F=`ls *tar.gz`
      mv $F $out
    '';
    outputHashAlgo = "sha256";
    outputHash = "1f825845d5007e676a4d1a3ccd887904b959bdddbcb9f241c42c2dac34037669";
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
    #! ${stdenv.shell}
    (cd $out; $out/adom ; )
    EOF
    chmod +x $out/bin/adom
  '';

  meta = with stdenv.lib; {
    description = "A rogue-like game with nice graphical interface";
    homepage = http://adom.de/;
    license = licenses.unfreeRedistributable;
    maintainers = [maintainers.smironov];

    # Please, notify me (smironov) if you need the x86 version
    platforms = ["x86_64-linux"];
  };
}


