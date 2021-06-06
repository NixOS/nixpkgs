{ stdenv, lib, file, fetchurl, autoPatchelfHook, unzip }:

stdenv.mkDerivation rec {
  pname = "terraria-server";
  version = "1.4.2.3";
  urlVersion = lib.replaceChars [ "." ] [ "" ] version;

  src = fetchurl {
    url = "https://terraria.org/system/dedicated_servers/archives/000/000/046/original/terraria-server-${urlVersion}.zip";
    sha256 = "0qm4pbm1d9gax47fk4zhw9rcxvajxs36w7dghirli89i994r7g8j";
  };

  buildInputs = [ file ];
  nativeBuildInputs = [ autoPatchelfHook unzip ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r Linux $out/
    chmod +x "$out/Linux/TerrariaServer.bin.x86_64"
    ln -s "$out/Linux/TerrariaServer.bin.x86_64" $out/bin/TerrariaServer
  '';

  meta = with lib; {
    homepage = "https://terraria.org";
    description =
      "Dedicated server for Terraria, a 2D action-adventure sandbox";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
  };
}
