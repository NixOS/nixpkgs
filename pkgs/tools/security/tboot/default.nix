{ lib, stdenv, fetchurl, trousers, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "tboot";
  version = "1.9.8";

  src = fetchurl {
    url = "mirror://sourceforge/tboot/${pname}-${version}.tar.gz";
    sha256 = "06f0ggl6vrb5ghklblvh2ixgmmjv31rkp1vfj9qm497iqwq9ac00";
  };

  patches = [ ./tboot-add-well-known-secret-option-to-lcp_writepol.patch ];

  buildInputs = [ trousers openssl zlib ];

  enableParallelBuilding = true;

  hardeningDisable = [ "pic" "stackprotector" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=address-of-packed-member" ];

  configurePhase = ''
    for a in lcptools utils tb_polgen; do
      substituteInPlace $a/Makefile --replace /usr/sbin /sbin
    done
    substituteInPlace docs/Makefile --replace /usr/share /share
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "A pre-kernel/VMM module that uses Intel(R) TXT to perform a measured and verified launch of an OS kernel/VMM";
    homepage    = "https://sourceforge.net/projects/tboot/";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ ak ];
    platforms   = [ "x86_64-linux" "i686-linux" ];
  };
}
