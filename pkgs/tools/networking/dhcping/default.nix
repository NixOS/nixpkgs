{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dhcping";
  version = "1.2";

  src = fetchurl {
    sha256 = "0sk4sg3hn88n44dxikipf3ggfj3ixrp22asb7nry9p0bkfaqdvrj";
    url = "https://www.mavetju.org/download/dhcping-${version}.tar.gz";
  };

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "Send DHCP request to find out if a DHCP server is running";
    longDescription = ''
      dhcping sends either a DHCPREQUEST or DHCPINFORM packet to the server
      and waits for an answer. Then, if a DHCPREQUEST was send, it will send
      a DHCPRELEASE back to the server.

      This program should be installed setuid root or ran by root only, as it
      requires the privileges to bind itself to port 68 (bootpc). Root
      privileges are dropped as soon as the program has bound itself to that
      port.
    '';
    homepage = "http://www.mavetju.org/unix/general.php";
    license = licenses.bsd2;
    platforms = platforms.unix;
    mainProgram = "dhcping";
  };
}
