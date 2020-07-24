{ stdenv, fetchurl, fetchpatch, perl, zlib, bzip2 }:

stdenv.mkDerivation rec {
  pname = "routino";
  version = "3.3.2";

  src = fetchurl {
    url = "https://routino.org/download/${pname}-${version}.tgz";
    sha256 = "1ccx3s99j8syxc1gqkzsaqkmyf44l7h3adildnc5iq2md7bp8wab";
  };

  patchFlags = [ "-p0" ];
  patches = stdenv.lib.optionals stdenv.isDarwin [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/18fd229516a46e7272003acbe555735b2a902db7/gis/routino/files/patch-Makefile_conf.diff";
      sha256 = "1b7hpa4sizansnwwxq1c031nxwdwh71pg08jl9z9apiab8pjsn53";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/18fd229516a46e7272003acbe555735b2a902db7/gis/routino/files/patch-src_Makefile_dylib_extension.diff";
      sha256 = "1kigxcfr7977baxdsfvrw6q453cpqlzqakhj7av2agxkcvwyilpv";
    })
  ];

  nativeBuildInputs = [ perl ];

  buildInputs = [ zlib bzip2 ];

  outputs = [ "out" "doc" ];

  CLANG = stdenv.lib.optionalString stdenv.cc.isClang "1";

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "http://www.routino.org/";
    description = "OpenStreetMap Routing Software";
    license = licenses.agpl3;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux ++ darwin;
  };
}
