{ lib, stdenv, fetchurl, swig ? null, python2 ? null, python3 ? null }:

assert python2 != null || python3 != null -> swig != null;

stdenv.mkDerivation rec {
  pname = "libcap-ng";
  # When updating make sure to test that the version with
  # all of the python bindings still works
  version = "0.8.3";

  src = fetchurl {
    url = "${meta.homepage}/${pname}-${version}.tar.gz";
    sha256 = "sha256-vtb2hI4iuy+Dtfdksq7w7TkwVOgDqOOocRyyo55rSS0=";
  };

  nativeBuildInputs = [ swig ];
  buildInputs = [ python2 python3 ];

  postPatch = ''
    function get_header() {
      echo -e "#include <$1>" | gcc -M -xc - | tr ' ' '\n' | grep "$1" | head -n 1
    }

    # Fix some hardcoding of header paths
    sed -i "s,/usr/include/linux/capability.h,$(get_header linux/capability.h),g" bindings/python{,3}/Makefile.in
  '';

  configureFlags = [
    (if python2 != null then "--with-python" else "--without-python")
    (if python3 != null then "--with-python3" else "--without-python3")
  ];

  meta = let inherit (lib) platforms licenses; in {
    description = "Library for working with POSIX capabilities";
    homepage = "https://people.redhat.com/sgrubb/libcap-ng/";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
