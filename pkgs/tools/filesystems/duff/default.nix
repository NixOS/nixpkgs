{ lib, stdenv, fetchFromGitHub, autoreconfHook, gettext }:

stdenv.mkDerivation {
  pname = "duff";
  version = "2024-02-16";

  src = fetchFromGitHub {
    sha256 = "9lS4th+qeglsoA+1s45uEE2UGmlE3YtSy4/uGqWKU/k=";
    rev = "c1baefa4f4d5cefbbbc7bfefc0c18356752c8a1b";
    repo = "duff";
    owner = "elmindreda";
  };

  nativeBuildInputs = [ autoreconfHook gettext ];

  preAutoreconf = ''
    # gettexttize rightly refuses to run non-interactively:
    cp ${gettext}/bin/gettextize .
    substituteInPlace gettextize \
      --replace "read dummy" "echo '(Automatically acknowledged)' #"
    ./gettextize
    sed 's@po/Makefile.in\( .*\)po/Makefile.in@po/Makefile.in \1@' \
      -i configure.ac
    # src/main.c is utf8, not ascii
    sed '/^XGETTEXT_OPTIONS =/ s,$, --from-code=utf-8,' -i po/Makevars
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Quickly find duplicate files";
    mainProgram = "duff";
    longDescription = ''
      Duff is a Unix command-line utility for quickly finding duplicates in
      a given set of files.
    '';
    homepage = "https://github.com/elmindreda/duff";
    license = licenses.zlib;
    platforms = platforms.all;
  };
}
