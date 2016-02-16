{ stdenv, fetchurl, cmake, libxslt }:

let
  version = "5.0.0";
in
stdenv.mkDerivation rec {
  name = "html-tidy-${version}";

  src = fetchurl {
    url = "https://github.com/htacg/tidy-html5/archive/${version}.tar.gz";
    sha256 = "1qz7hgk482496agngp9grz4jqkyxrp29r2ywbccc9i5198yspca4";
  };

  nativeBuildInputs = [ cmake libxslt/*manpage*/ ];

  cmakeFlags = stdenv.lib.optional
    (stdenv.cross.libc or null == "msvcrt") "-DCMAKE_SYSTEM_NAME=Windows";

  # ATM bin/tidy is statically linked, as upstream provides no other option yet.
  # https://github.com/htacg/tidy-html5/issues/326#issuecomment-160322107

  meta = with stdenv.lib; {
    description = "A HTML validator and `tidier'";
    longDescription = ''
      HTML Tidy is a command-line tool and C library that can be
      used to validate and fix HTML data.
    '';
    license = licenses.libpng; # very close to it - the 3 clauses are identical
    homepage = http://html-tidy.org;
    platforms = platforms.all;
    maintainers = with maintainers; [ edwtjo ];
  };
}

