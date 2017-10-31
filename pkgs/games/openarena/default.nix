{ fetchurl, makeWrapper, patchelf, pkgs, stdenv, SDL, libogg, libvorbis }:

stdenv.mkDerivation rec {
  name = "openarena-${version}";
  version = "0.8.8";

  src = fetchurl {
    name = "openarena.zip";
    url = "http://openarena.ws/request.php?4";
    sha256 = "0jmc1cmdz1rcvqc9ilzib1kilpwap6v0d331l6q53wsibdzsz3ss";
  };

  buildInputs = [ pkgs.unzip patchelf makeWrapper];

  installPhase = let
    gameDir = "$out/openarena-$version";
    interpreter = "$(< \"$NIX_CC/nix-support/dynamic-linker\")";
    libPath = stdenv.lib.makeLibraryPath [ SDL libogg libvorbis ];
  in ''
    mkdir -pv $out/bin
    cd $out
    unzip $src

    ${if stdenv.system == "x86_64-linux" then ''
      patchelf --set-interpreter "${interpreter}" "${gameDir}/openarena.x86_64"
      makeWrapper "${gameDir}/openarena.x86_64" "$out/bin/openarena" \
        --prefix LD_LIBRARY_PATH : "${libPath}"
    '' else ''
      patchelf --set-interpreter "${interpreter}" "${gameDir}/openarena.i386"
      makeWrapper "${gameDir}/openarena.i386" "$out/bin/openarena" \
        --prefix LD_LIBRARY_PATH : "${libPath}"
    ''}
  '';

  meta = {
    description = "Crossplatform openarena client";
    homepage = http://openarena.ws/;
    maintainers = [ stdenv.lib.maintainers.wyvie ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
