{ stdenv, fetchurl, autoreconfHook, libxcomp }:

let version = "3.5.0.31"; in
stdenv.mkDerivation {
  name = "nxproxy-${version}";

  src = fetchurl {
    sha256 = "1hi3xrjzr37zs72djw3k7gj6mn2bsihfw1iysl8l0i85jl6sdfkd";
    url = "http://code.x2go.org/releases/source/nx-libs/nx-libs-${version}-lite.tar.gz";
  };

  meta = with stdenv.lib; {
    description = "NX compression proxy";
    homepage = "http://wiki.x2go.org/doku.php/wiki:libs:nx-libs";
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ autoreconfHook libxcomp ];

  preAutoreconf = ''
    cd nxproxy/
  '';

  makeFlags = [ "exec_prefix=$(out)" ];

  enableParallelBuilding = true;
}
