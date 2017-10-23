{ stdenv, fetchurl, which}:

stdenv.mkDerivation rec {
  name = "cntlm-${version}";
  version = "0.92.3";

  src = fetchurl {
    url = "mirror://sourceforge/cntlm/${name}.tar.gz";
    sha256 = "1632szz849wasvh5sm6rm1zbvbrkq35k7kcyvx474gyl4h4x2flw";
  };

  buildInputs = [ which ];

  installPhase = ''
    mkdir -p $out/bin; cp cntlm $out/bin/;
    mkdir -p $out/share/; cp COPYRIGHT README VERSION doc/cntlm.conf $out/share/;
    mkdir -p $out/man/; cp doc/cntlm.1 $out/man/;
  '';

  meta = with stdenv.lib; {
    description = "NTLM/NTLMv2 authenticating HTTP proxy";
    homepage = http://cntlm.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = 
      [
        maintainers.qknight
        maintainers.markWot
      ];
    platforms = platforms.linux;
  };
}
