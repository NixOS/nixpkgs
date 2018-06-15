{ stdenv, fetchurl, openssl, coreutils }:

stdenv.mkDerivation rec {
  name    = "spiped-${version}";
  version = "1.5.0";

  src = fetchurl {
    url    = "http://www.tarsnap.com/spiped/${name}.tgz";
    sha256 = "1mxcbxifr3bnj6ga8lz88y4bhff016i6kjdzwbb3gzb2zcs4pxxj";
  };

  buildInputs = [ openssl ];

  patchPhase = ''
    substituteInPlace libcperciva/cpusupport/Build/cpusupport.sh \
      --replace "2>/dev/null" "2>stderr.log"

    substituteInPlace POSIX/posix-l.sh       \
      --replace "rm" "${coreutils}/bin/rm"   \
      --replace ">/dev/stderr" ">stderr.log" \
      --replace "2>/dev/null" "2>stderr.log"

    substituteInPlace POSIX/posix-cflags.sh  \
      --replace "rm" "${coreutils}/bin/rm"   \
      --replace ">/dev/stderr" ">stderr.log" \
      --replace "2>/dev/null" "2>stderr.log"
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    make install BINDIR=$out/bin MAN1DIR=$out/share/man/man1
  '';

  meta = {
    description = "Utility for secure encrypted channels between sockets";
    homepage    = "https://www.tarsnap.com/spiped.html";
    license     = stdenv.lib.licenses.bsd2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
