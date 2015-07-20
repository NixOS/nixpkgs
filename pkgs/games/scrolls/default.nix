{ stdenv, fetchurl, gcc
, mesa_glu, libX11, libXext, libXcursor, libpulseaudio
}:
stdenv.mkDerivation {
  name = "scrolls-2014-03-08";

  meta = {
    description = "A strategy collectible card game";
    homepage = "https://scrolls.com/";
    # http://www.reddit.com/r/Scrolls/comments/2j3pxw/linux_client_experimental/

    platforms = [ "x86_64-linux" ];

    license = stdenv.lib.licenses.unfree;
  };

  src = fetchurl {
    url = "http://download.scrolls.com/client/linux.tar.gz";
    sha256 = "164d13ce5b81b215a58bae5a0d024b4cf6e32c986ca57a2c9d4e80326edb5004";
  };

  libPath = stdenv.lib.makeLibraryPath [
    gcc
    mesa_glu
    libX11
    libXext
    libXcursor
    libpulseaudio
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
