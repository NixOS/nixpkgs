{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "mcrcon";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Tiiffi";
    repo = "mcrcon";
    rev = "v${version}";
    sha256 = "0as60cgl8sflykmwihc6axy1hzx6gjgjav6c7mvlbsc43dv8fs51";
  };

  buildPhase = ''
    $CC mcrcon.c -o mcrcon
  '';

  installPhase = ''
    install -Dm 755 mcrcon $out/bin/mcrcon
  '';

  meta = {
    homepage = https://bukkit.org/threads/admin-rcon-mcrcon-remote-connection-client-for-minecraft-servers.70910/;
    description = "Minecraft console client with Bukkit coloring support.";
    longDescription = ''
      Mcrcon is a powerful Minecraft RCON terminal client with Bukkit coloring support.
      It is well suited for remote administration and to be used as part of automated server maintenance scripts.
      It does not trigger "IO: Broken pipe" or "IO: Connection reset" spam bugs on the server side.
    '';
    maintainers = with stdenv.lib.maintainers; [ dermetfan ];
    license = with stdenv.lib.licenses; [ zlib libpng ];
  };
}
