{ lib, stdenv, fetchpatch, fetchurl, libpcap, zlib }:

stdenv.mkDerivation rec {
  version = "3.0.719";
  pname = "darkstat";

  src = fetchurl {
    url = "${meta.homepage}/${pname}-${version}.tar.bz2";
    sha256 = "1mzddlim6dhd7jhr4smh0n2fa511nvyjhlx76b03vx7phnar1bxf";
  };

  patches = [
    # Avoid multiple definitions of CLOCK_REALTIME on macOS 11,
    # see https://github.com/emikulic/darkstat/pull/2
    (fetchpatch {
       url = "https://github.com/emikulic/darkstat/commit/d2fd232e1167dee6e7a2d88b9ab7acf2a129f697.diff";
       sha256 = "0z5mpyc0q65qb6cn4xcrxl0vx21d8ibzaam5kjyrcw4icd8yg4jb";
    })
  ];

  buildInputs = [ libpcap zlib ];

  enableParallelBuilding = true;

  meta = with lib; {
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
    homepage = "http://unix4lyfe.org/darkstat";
    license = licenses.gpl2;
    platforms = with platforms; unix;
  };
}
