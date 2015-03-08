{ stdenv, fetchurl, gcc
, mesa_glu, libX11, libXext, libXcursor, pulseaudio
}:
stdenv.mkDerivation {
  name = "scrolls-2014-03-08";

  meta = {
    description = "Scrolls is a strategy collectible card game.";
    homepage = "https://scrolls.com/";
    # http://www.reddit.com/r/Scrolls/comments/2j3pxw/linux_client_experimental/

    platforms = [ "x86_64-linux" ];

    licence = stdenv.lib.licenses.unfree;
  };

  src = fetchurl {
    url = "http://download.scrolls.com/client/linux.tar.gz";
    sha256 = "0gpwb8f1wrj6dfd9ffxga07whnxdgk66bj7j9gkbxlvrx3sj8zbp";
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

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath "$libPath" "$out/opt/Scrolls/Scrolls"

    mkdir "$out/bin"
    ln -s "$out/opt/Scrolls/Scrolls" "$out/bin/Scrolls" 
  '';

}
