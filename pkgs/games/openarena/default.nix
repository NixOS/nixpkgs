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
    arch = {
      "x86_64-linux" = "x86_64";
      "i386-linux" = "i386";
    }.${stdenv.hostPlatform.system};
  in ''
    mkdir -pv $out/bin
    cd $out
    unzip $src

    patchelf --set-interpreter "${interpreter}" "${gameDir}/openarena.${arch}"
    patchelf --set-interpreter "${interpreter}" "${gameDir}/oa_ded.${arch}"

    makeWrapper "${gameDir}/openarena.${arch}" "$out/bin/openarena" \
      --prefix LD_LIBRARY_PATH : "${libPath}"
    makeWrapper "${gameDir}/oa_ded.${arch}" "$out/bin/oa_ded"
  '';

  meta = {
    description = "Crossplatform openarena client";
    homepage = http://openarena.ws/;
    maintainers = [ stdenv.lib.maintainers.wyvie ];
    platforms = [ "i386-linux" "x86_64-linux" ];
    license = stdenv.lib.licenses.gpl2;
  };
}
