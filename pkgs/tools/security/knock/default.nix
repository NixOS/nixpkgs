{ stdenv, lib, fetchFromGitHub, autoreconfHook, libpcap }:

stdenv.mkDerivation rec {
  pname = "knock";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "jvinet";
    repo = pname;
    rev = "258a27e5a47809f97c2b9f2751a88c2f94aae891";
    sha256 = "0h24b4g08j8x4bkbd17g7qak3asz8as61knm12vq8cf3fgn5d59q";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libpcap ];

  meta = with lib; {
    description = "A port-knocking daemon";
    longDescription = ''
      This is a port-knocking server/client. Port-knocking is a method where a
      server can sniff one of its interfaces for a special "knock" sequence of
      port-hits. When detected, it will run a specified event bound to that
      port knock sequence. These port-hits need not be on open ports, since we
      use libpcap to sniff the raw interface traffic.
    '';
    homepage = "http://www.zeroflux.org/projects/knock";
    license = licenses.gpl2;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.unix;
  };
}
