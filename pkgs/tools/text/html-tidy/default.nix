{ stdenv, fetchFromGitHub, cmake, libxslt }:

stdenv.mkDerivation rec {
  name = "html-tidy-${version}";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "htacg";
    repo = "tidy-html5";
    rev = version;
    sha256 = "0w175c5d1babq0w1zzdzw9gl6iqbgyq58v8587s7srp05y3hwy9k";
  };

  nativeBuildInputs = [ cmake libxslt/*manpage*/ ];

  cmakeFlags = stdenv.lib.optional
    (stdenv.hostPlatform.libc or null == "msvcrt") "-DCMAKE_SYSTEM_NAME=Windows";

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
