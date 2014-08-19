{ stdenv, fetchurl, trousers, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "tboot-1.8.2";

  src = fetchurl {
    url = "mirror://sourceforge/tboot/${name}.tar.gz";
    sha256 = "1l9ccm7ik9fs7kzg1bjc5cjh0pcf4v0k1c84dmyr51r084i7p31m";
  };

  buildInputs = [ trousers openssl zlib ];

  patches = [ ./tboot-add-well-known-secret-option-to-lcp_writepol.patch ];

  configurePhase = ''
    for a in lcptools utils tb_polgen; do
      substituteInPlace $a/Makefile --replace /usr/sbin /sbin
    done
    substituteInPlace docs/Makefile --replace /usr/share /share
  '';
  installFlags = "DESTDIR=$(out)";

  meta = with stdenv.lib; {
    description = ''Trusted Boot (tboot) is an open source, pre-kernel/VMM module that uses
                    Intel(R) Trusted Execution Technology (Intel(R) TXT) to perform a measured
                    and verified launch of an OS kernel/VMM.'';
    homepage    = http://sourceforge.net/projects/tboot/;
    license     = licenses.bsd3;
    maintainers = [ maintainers.ak ];
    platforms   = platforms.linux;
  };
}

