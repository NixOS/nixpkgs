{ lib, stdenv, fetchurl, cmake, pkg-config, libxml2, libzip }:

stdenv.mkDerivation rec {
  pname = "ebook-tools";
  version = "0.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/ebook-tools/ebook-tools-${version}.tar.gz";
    sha256 = "1bi7wsz3p5slb43kj7lgb3r6lb91lvb6ldi556k4y50ix6b5khyb";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libxml2 libzip ];

  meta = with lib; {
    homepage = "http://ebook-tools.sourceforge.net";
    description = "Tools and library for dealing with various ebook file formats";
    maintainers = [ ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
