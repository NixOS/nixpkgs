{
  lib,
  stdenv,
  fetchurl,
  which,
}:

stdenv.mkDerivation rec {
  pname = "cntlm";
  version = "0.92.3";

  src = fetchurl {
    url = "mirror://sourceforge/cntlm/${pname}-${version}.tar.gz";
    sha256 = "1632szz849wasvh5sm6rm1zbvbrkq35k7kcyvx474gyl4h4x2flw";
  };

  buildInputs = [ which ];

  preConfigure = lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace "xlc_r gcc" "xlc_r gcc $CC"
    substitute Makefile Makefile.$CC --replace "CC=gcc" "CC=$CC"
  '';

  installPhase = ''
    mkdir -p $out/bin; cp cntlm $out/bin/;
    mkdir -p $out/share/; cp COPYRIGHT README VERSION doc/cntlm.conf $out/share/;
    mkdir -p $out/man/; cp doc/cntlm.1 $out/man/;
  '';

  meta = with lib; {
    description = "NTLM/NTLMv2 authenticating HTTP proxy";
    homepage = "https://cntlm.sourceforge.net/";
    license = licenses.gpl2Only;
    maintainers = [
      maintainers.qknight
      maintainers.carlosdagos
    ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "cntlm";
  };
}
