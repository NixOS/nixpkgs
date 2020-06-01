{ stdenv, lib, file, fetchurl, autoPatchelfHook, unzip }:

stdenv.mkDerivation rec {
  pname = "terraria-server";
  version = "1.4.0.4";
  urlVersion = lib.replaceChars [ "." ] [ "" ] version;

  src = fetchurl {
    url = "https://terraria.org/system/dedicated_servers/archives/000/000/038/original/terraria-server-${urlVersion}.zip";
    sha256 = "09zkadjd04gbx1yvwpqmm89viydwxqgixbqhbqncb94qb2z5gfxk";
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
