{ stdenv, lib, file, fetchurl, autoPatchelfHook, unzip }:

stdenv.mkDerivation rec {
  pname = "terraria-server";
  version = "1.4.0.3";
  urlVersion = lib.replaceChars [ "." ] [ "" ] version;

  src = fetchurl {
    url = "https://terraria.org/system/dedicated_servers/archives/000/000/037/original/terraria-server-${urlVersion}.zip";
    sha256 = "1g9rd0a40gsljk8xp3bkvwy8ngywjzk8chf2x9l43s2kf40ib0p8";
  };

  buildInputs = [ file unzip ];
  nativeBuildInputs = [ autoPatchelfHook ];

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
