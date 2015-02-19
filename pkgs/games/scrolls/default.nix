{ stdenv, fetchurl, gcc
, mesa_glu, libX11, libXext, libXcursor, pulseaudio
}:
stdenv.mkDerivation {
  name = "scrolls";

  meta = {
    description = "Scrolls is a strategy collectible card game.";
    homepage = "https://scrolls.com/";
    # http://www.reddit.com/r/Scrolls/comments/2j3pxw/linux_client_experimental/

    platforms = [ "x86_64-linux" ];

    licence = stdenv.lib.licenses.unfree;
  };

  src = fetchurl {
    url = "http://download.scrolls.com/client/linux.tar.gz";
    sha256 = "c94fd2181dfac708755f9d70fa91f6106acd124b6b01717641a4dc4240e7e2c0";
  };

  libPath = stdenv.lib.makeLibraryPath [
    gcc
    mesa_glu
    libX11
    libXext
    libXcursor
    pulseaudio
  ];

  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/opt/Scrolls"
    cp -r ../Scrolls "$out/opt/Scrolls/"
    cp -r ../Scrolls_Data "$out/opt/Scrolls/"
    chmod +x "$out/opt/Scrolls/Scrolls"

    patchelf --set-interpreter $(cat $NIX_GCC/nix-support/dynamic-linker) \
      --set-rpath "$libPath" "$out/opt/Scrolls/Scrolls"

    mkdir "$out/bin"
    ln -s "$out/opt/Scrolls/Scrolls" "$out/bin/Scrolls" 
  '';

}
