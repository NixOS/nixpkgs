{ lib, stdenv, fetchurl, openssl, coreutils }:

stdenv.mkDerivation rec {
  pname = "spiped";
  version = "1.6.1";

  src = fetchurl {
    url    = "https://www.tarsnap.com/spiped/${pname}-${version}.tgz";
    sha256 = "8d7089979db79a531a0ecc507b113ac6f2cf5f19305571eff1d3413e0ab33713";
  };

  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace libcperciva/cpusupport/Build/cpusupport.sh \
      --replace "dirname" "${coreutils}/bin/dirname" \
      --replace "2>/dev/null" "2>stderr.log"

    substituteInPlace libcperciva/POSIX/posix-l.sh       \
      --replace "rm" "${coreutils}/bin/rm"   \
      --replace "2>/dev/null" "2>stderr.log"
   '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/man/man1
    make install BINDIR=$out/bin MAN1DIR=$out/share/man/man1
    runHook postInstall
  '';

  meta = {
    description = "Utility for secure encrypted channels between sockets";
    homepage    = "https://www.tarsnap.com/spiped.html";
    license     = lib.licenses.bsd2;
    platforms   = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
