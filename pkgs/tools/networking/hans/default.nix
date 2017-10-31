{ stdenv, fetchFromGitHub, nettools }:

stdenv.mkDerivation rec {
  name = "hans-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    sha256 = "1qnfl7wr5x937b6jx3vhhvnwnrclrqvq7d7zxbfhk74pdwnjy8n4";
    rev = "v${version}";
    repo = "hans";
    owner = "friedrich";
  };

  buildInputs = [ nettools ];

  postPatch = ''
    substituteInPlace src/tun.cpp --replace "/sbin/" "${nettools}/bin/"
  '';

  enableParallelBuilding = true;

  installPhase = ''
    install -D -m0755 hans $out/bin/hans
  '';

  meta = with stdenv.lib; {
    description = "Tunnel IPv4 over ICMP";
    longDescription = ''
      Hans makes it possible to tunnel IPv4 through ICMP echo packets, so you
      could call it a ping tunnel. This can be useful when you find yourself in
      the situation that your Internet access is firewalled, but pings are
      allowed.
    '';
    homepage = http://code.gerade.org/hans/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
