{ stdenv, fetchurl, patchelf, zlib, libmad, libpng12, libcaca, libGLU_combined, alsaLib, libpulseaudio
, xorg }:

assert stdenv.system == "x86_64-linux";
let

  inherit (xorg) libXext libX11;

  lpath = "${stdenv.cc.cc.lib}/lib64:" + stdenv.lib.makeLibraryPath [
      zlib libmad libpng12 libcaca libXext libX11 libGLU_combined alsaLib libpulseaudio];

in
stdenv.mkDerivation rec {
  name = "adom-${version}-noteye";
  version = "1.2.0_pre23";

  src = fetchurl {
    url = "http://ancardia.uk.to/download/adom_noteye_linux_ubuntu_64_${version}.tar.gz";
    sha256 = "0sbn0csaqb9cqi0z5fdwvnymkf84g64csg0s9mm6fzh0sm2mi0hz";
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

  meta = with stdenv.lib; {
    description = "A rogue-like game with nice graphical interface";
    homepage = http://adom.de/;
    license = licenses.unfreeRedistributable;
    maintainers = [maintainers.smironov];

    # Please, notify me (smironov) if you need the x86 version
    platforms = ["x86_64-linux"];
  };
}


