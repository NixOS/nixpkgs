{ lib, stdenv, fetchFromGitHub, cmake, libxslt }:

stdenv.mkDerivation rec {
  pname = "html-tidy";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "htacg";
    repo = "tidy-html5";
    rev = version;
    sha256 = "sha256-ZMz0NySxzX2XHiqB8f5asvwjIG6kdIcq8Gb3EbAxBaU=";
  };

  nativeBuildInputs = [ cmake libxslt/*manpage*/ ];

  cmakeFlags = [];

  # ATM bin/tidy is statically linked, as upstream provides no other option yet.
  # https://github.com/htacg/tidy-html5/issues/326#issuecomment-160322107

  meta = with lib; {
    description = "A HTML validator and `tidier'";
    longDescription = ''
      HTML Tidy is a command-line tool and C library that can be
      used to validate and fix HTML data.
    '';
    license = licenses.libpng; # very close to it - the 3 clauses are identical
    homepage = "http://html-tidy.org";
    platforms = platforms.all;
    maintainers = with maintainers; [ edwtjo ];
    mainProgram = "tidy";
  };
}
