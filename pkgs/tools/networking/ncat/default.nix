{stdenv, fetchurl, openssl}:
stdenv.mkDerivation {
  name = "ncat-0.10rc3";

  src = fetchurl {
    url = http://ovh.dl.sourceforge.net/sourceforge/nmap-ncat/ncat-0.10rc3.tar.gz;
    sha256 = "1yb26ipxwhqkfannji90jxi38k35fal4ffx0jm5clr1a1rndjjzb";
  };

  patches = [./ncat-0.10rc3.patch ];

  buildInputs = [openssl ];

  CFLAGS = "-g";

  postInstall = "install -D ncat \${out}/bin/ncat ; 
	install -D docs/man/ncat.1 \${out}/man/ncat.1 ;";

  meta = {
    description = "
	Ncat - some effort to join features from different `netcat's. Supports IPv6.
";
  };
}
