{ stdenv, fetchurl, libpcap, zlib }:

stdenv.mkDerivation rec {
  version = "3.0.719";
  name = "darkstat-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "1mzddlim6dhd7jhr4smh0n2fa511nvyjhlx76b03vx7phnar1bxf";
  };

  buildInputs = [ libpcap zlib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Network statistics web interface";
    longDescription = ''
      Captures network traffic, calculates statistics about usage, and serves
      reports over HTTP. Features:
      - Traffic graphs, reports per host, shows ports for each host.
      - Embedded web-server with deflate compression.
      - Asynchronous reverse DNS resolution using a child process.
      - Small. Portable. Single-threaded. Efficient.
      - Supports IPv6.
    '';
    homepage = http://unix4lyfe.org/darkstat;
    license = licenses.gpl2;
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; unix;
  };
}
