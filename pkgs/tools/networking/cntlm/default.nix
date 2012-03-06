{ stdenv, fetchurl, which}:

stdenv.mkDerivation {
  name = "cntlm-0.35.1";

  src = fetchurl {
    url = mirror://sourceforge/cntlm/cntlm-0.35.1.tar.gz;
    sha256 = "7b3fb7184e72cc3f1743bb8e503a5305e96458bc630a7e1ebfc9f3c07ffa6c5e";
  };

  buildInputs = [ which ];

  installPhase = ''
    mkdir -p $out/bin; cp cntlm $out/bin/;
    mkdir -p $out/share/; cp COPYRIGHT README VERSION doc/cntlm.conf $out/share/;
    mkdir -p $out/man/; cp doc/cntlm.1 $out/man/;
  '';

  meta = {
    description = "Cntlm is an NTLM/NTLMv2 authenticating HTTP proxy";
    homepage = http://cntlm.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.qknight ];
  };
}
