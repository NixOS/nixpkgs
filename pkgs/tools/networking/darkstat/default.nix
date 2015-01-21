{ stdenv, fetchurl, libpcap, zlib }:

stdenv.mkDerivation rec {
  version = "3.0.718";
  name = "darkstat-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "1zxd4bxdfk1pjpcxhrcp54l991g0lljl4sr312nsd7p8yi9kwbv8";
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
    license = with licenses; gpl2;
    maintainers = with maintainers; [ nckx ];
  };
}
