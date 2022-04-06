{ lib, stdenv, fetchurl, xar, cpio, pbzx }:

stdenv.mkDerivation rec {
  pname = "dockutil";
  version = "3.0.2";

  src = fetchurl {
      url    = "https://github.com/kcrawford/dockutil/releases/download/${version}/dockutil-${version}.pkg";
      sha256 = "175137ea747e83ed221d60b18b712b256ed31531534cde84f679487d337668fd";
    };

  dontBuild = true;

  nativeBuildInputs = [ xar cpio ];

  unpackPhase = ''
    xar -x -f $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/usr/local/bin
    mv ./Payload ./Payload.gz
    gzip -cd ./Payload.gz | cpio -idm
    cp ./usr/local/bin/dockutil $out/usr/local/bin
    ln -rs $out/usr/local/bin/dockutil $out/bin/dockutil
  '';

  meta = with lib; {
    description = "Tool for managing dock items";
    homepage = "https://github.com/kcrawford/dockutil";
    license = licenses.asl20;
    maintainers = with maintainers; [ tboerger ];
    platforms = platforms.darwin;
  };
}
