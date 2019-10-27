{ fetchurl, makeWrapper, patchelf, pkgs, stdenv, SDL, libglvnd, libogg, libvorbis, curl, openal }:

stdenv.mkDerivation {
  pname = "openarena";
  version = "0.8.8";

  src = fetchurl {
    name = "openarena.zip";
    url = "http://openarena.ws/request.php?4";
    sha256 = "0jmc1cmdz1rcvqc9ilzib1kilpwap6v0d331l6q53wsibdzsz3ss";
  };

  nativeBuildInputs = [ pkgs.unzip patchelf makeWrapper];

  installPhase = let
    gameDir = "$out/openarena-$version";
    interpreter = "$(< \"$NIX_CC/nix-support/dynamic-linker\")";
    libPath = stdenv.lib.makeLibraryPath [ SDL libglvnd libogg libvorbis curl openal ];
  in ''
    mkdir -pv $out/bin
    cd $out
    unzip $src

    ${if stdenv.hostPlatform.system == "x86_64-linux" then ''
      patchelf --set-interpreter "${interpreter}" "${gameDir}/openarena.x86_64"
      makeWrapper "${gameDir}/openarena.x86_64" "$out/bin/openarena" \
        --prefix LD_LIBRARY_PATH : "${libPath}"
      patchelf --set-interpreter "${interpreter}" "${gameDir}/oa_ded.x86_64"
      makeWrapper "${gameDir}/oa_ded.x86_64" "$out/bin/openarena-server" \
        --prefix LD_LIBRARY_PATH : "${libPath}"
    '' else ''
      patchelf --set-interpreter "${interpreter}" "${gameDir}/openarena.i386"
      makeWrapper "${gameDir}/openarena.i386" "$out/bin/openarena" \
        --prefix LD_LIBRARY_PATH : "${libPath}"
      patchelf --set-interpreter "${interpreter}" "${gameDir}/oa_ded.i386"
      makeWrapper "${gameDir}/oa_ded.i386" "$out/bin/openarena-server" \
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
