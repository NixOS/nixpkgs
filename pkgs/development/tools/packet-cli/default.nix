{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "packet-cli";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "packethost";
    repo = pname;
    rev = version;
    sha256 = "17f3ax7pjm5k93cxj7fd8hwr4id1lbzz9pkl2xflpxydi89bwdfz";
  };

  vendorSha256 = "10praxaiscxq4v3zknrabldxl7rpklkr5wdlwa5lxsx0if8mrvp7";

  meta = with stdenv.lib; {
    description = "Official Packet CLI";
    homepage = "https://github.com/packethost/packet-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}