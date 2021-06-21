{ lib, stdenv, fetchurl, patchelf, zlib, libmad, libpng12, libcaca, libGLU, libGL, alsa-lib, libpulseaudio
, xorg }:

let

  inherit (xorg) libXext libX11;

  lpath = "${stdenv.cc.cc.lib}/lib64:" + lib.makeLibraryPath [
      zlib libmad libpng12 libcaca libXext libX11 libGLU libGL alsa-lib libpulseaudio];

in
stdenv.mkDerivation rec {
  name = "adom-${version}-noteye";
  version = "1.2.0_pre23";

  src = fetchurl {
    url = "https://www.indiedb.com/downloads/mirror/173928/123/1ba83da5ddf924f71a65d30062611f0b";
    sha256 = "11nlvx1cl2c5fbjxgs25lk921gsh3qwdrfzqq97mg6rpmmb180yg";
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
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$out/lib:${lpath}" \
      $out/adom

    mkdir $out/bin
    cat >$out/bin/adom <<EOF
    #! ${stdenv.shell}
    (cd $out; exec $out/adom ; )
    EOF
    chmod +x $out/bin/adom
  '';

  meta = with lib; {
    description = "A rogue-like game with nice graphical interface";
    homepage = "http://adom.de/";
    license = licenses.unfreeRedistributable;
    maintainers = [maintainers.smironov];

    # Please, notify me (smironov) if you need the x86 version
    platforms = ["x86_64-linux"];
  };
}
