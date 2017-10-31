{ stdenv, fetchurl, trousers, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "tboot-${version}";
  version = "1.9.6";

  src = fetchurl {
    url = "mirror://sourceforge/tboot/${name}.tar.gz";
    sha256 = "0f9afz260xhycpd0x5zz6jn8ha14i8j98rck0fhb55l1rbbfwm8v";
  };

  patches = [ ./tboot-add-well-known-secret-option-to-lcp_writepol.patch ];

  buildInputs = [ trousers openssl zlib ];

  enableParallelBuilding = true;

  hardeningDisable = [ "pic" "stackprotector" ];

  configurePhase = ''
    for a in lcptools utils tb_polgen; do
      substituteInPlace $a/Makefile --replace /usr/sbin /sbin
    done
    substituteInPlace docs/Makefile --replace /usr/share /share
  '';

  installFlags = "DESTDIR=$(out)";

  meta = with stdenv.lib; {
    description = "A pre-kernel/VMM module that uses Intel(R) TXT to perform a measured and verified launch of an OS kernel/VMM";
    homepage    = http://sourceforge.net/projects/tboot/;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ ak ];
    platforms   = platforms.linux;
  };
}
