{ stdenv, fetchurl, autoreconfHook, libxcomp }:

let version = "3.5.0.31"; in
stdenv.mkDerivation {
  name = "nxproxy-${version}";

  src = fetchurl {
    url = "http://code.x2go.org/releases/source/nx-libs/nx-libs-${version}-full.tar.gz";
    sha256 = "0a31508wyfyblf6plag2djr4spra5kylcmgg99h83c60ylxxnc11";
  };

  meta = with stdenv.lib; {
    description = "NX compression proxy";
    homepage = "http://wiki.x2go.org/doku.php/wiki:libs:nx-libs";
    license = with licenses; gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ autoreconfHook libxcomp ];

  preAutoreconf = ''
    cd nxproxy/
  '';

  makeFlags = [ "exec_prefix=$(out)" ];
}
