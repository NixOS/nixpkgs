{ stdenv, fetchFromGitHub, cmake, libxslt
, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "html-tidy-${version}";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "htacg";
    repo = "tidy-html5";
    rev = version;
    sha256 = "1yxp3kjsxd5zwwn4r5rpyq5ndyylbcnb9pisdyf7dxjqd47z64bc";
  };

  nativeBuildInputs = [ cmake libxslt/*manpage*/ ];

  cmakeFlags = stdenv.lib.optional
    (hostPlatform.libc or null == "msvcrt") "-DCMAKE_SYSTEM_NAME=Windows";

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

