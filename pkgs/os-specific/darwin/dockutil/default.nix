{ lib, stdenv, fetchurl, libarchive, p7zip }:
stdenv.mkDerivation rec {
  pname = "dockutil";
  version = "3.0.2";

  src = fetchurl {
    url =
      "https://github.com/kcrawford/dockutil/releases/download/${version}/dockutil-${version}.pkg";
    sha256 = "175137ea747e83ed221d60b18b712b256ed31531534cde84f679487d337668fd";
  };

  dontBuild = true;

  nativeBuildInputs = [ libarchive p7zip ];

  unpackPhase = ''
    7z x $src
    bsdtar -xf Payload~
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/usr/local/bin
    install -Dm755 usr/local/bin/dockutil -t $out/usr/local/bin
    ln -rs $out/usr/local/bin/dockutil $out/bin/dockutil
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool for managing dock items";
    homepage = "https://github.com/kcrawford/dockutil";
    license = licenses.asl20;
    maintainers = with maintainers; [ tboerger ];
    platforms = platforms.darwin;
  };
}
