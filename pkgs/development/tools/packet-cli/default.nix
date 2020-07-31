{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "packet-cli";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "packethost";
    repo = pname;
    rev = version;
    sha256 = "1ixdqq0xwy2l2m1w93rzqw5gfrzw7w03r42qab3n733m4jkf4ni1";
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
