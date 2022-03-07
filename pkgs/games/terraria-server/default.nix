{ stdenv, lib, file, fetchurl, autoPatchelfHook, unzip }:

stdenv.mkDerivation rec {
  pname = "terraria-server";
  version = "1.4.3.5";
  urlVersion = lib.replaceChars [ "." ] [ "" ] version;

  src = fetchurl {
    url = "https://terraria.org/api/download/pc-dedicated-server/terraria-server-${urlVersion}.zip";
    sha256 = "sha256-N1GnxEe0A6Wuzy08lL3CFPWjQJECGGf504FE+lnhDcw=";
  };

  buildInputs = [ file ];
  nativeBuildInputs = [ autoPatchelfHook unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r Linux $out/
    chmod +x "$out/Linux/TerrariaServer.bin.x86_64"
    ln -s "$out/Linux/TerrariaServer.bin.x86_64" $out/bin/TerrariaServer

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://terraria.org";
    description = "Dedicated server for Terraria, a 2D action-adventure sandbox";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ ncfavier ];
  };
}
