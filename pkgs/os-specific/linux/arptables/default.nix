{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "arptables";
  version = "0.0.5";

  src = fetchzip {
    url = "http://ftp.netfilter.org/pub/${pname}/${pname}-${version}.tar.gz";
    sha256 = "MWyU8I+rRpUHKsk7qEF0c6otJcx4jKY0AGz3ZmFFPPY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  meta = with lib; {
    description = "Administration tool for arp packet filtering";
    homepage = "https://git.netfilter.org/arptables/";
    downloadPage = "http://ftp.netfilter.org/pub/arptables";
    mainProgram = "arptables-legacy";
    license = licenses.gpl2;
    platforms = platforms.linux;
    longDescription = ''
      arptables is a user space tool, it is used to set up and maintain the tables of ARP rules in the Linux kernel.
      These rules inspect the ARP frames which they see.
      arptables is analogous to the iptables user space tool,
      but arptables is less complicated.
    '';
  };
}
