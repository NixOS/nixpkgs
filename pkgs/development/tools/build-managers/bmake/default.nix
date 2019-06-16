{ stdenv, fetchurl
, gnugrep, coreutils, getopt
}:

stdenv.mkDerivation rec {
  name    = "bmake-${version}";
  version = "20121212";

  src = fetchurl {
    # really wish this URL was versioned. if this changes for some
    # update in the future, we'll have to backport those updates to
    # any stable branches so builds can continue to work. :(
    url    = "http://www.crufty.net/ftp/pub/sjg/bmake.tar.gz";
    sha256 = "0zp6yy27z52qb12bgm3hy1dwal2i570615pqqk71zwhcxfs4h2gw";
  };

  nativeBuildInputs =
    [ gnugrep coreutils getopt
    ];

  # unexport-env sets PATH to a bogus value that won't be
  # possible to use inside the build sandbox. nuke that test;
  # we could also re-construct the PATH variable a bit based on
  # nativeBuildInputs, but not for now
  patchPhase = ''
    substituteInPlace ./unit-tests/Makefile.in \
      --replace "unexport-env" ""
  '';

  meta = with stdenv.lib; {
    description = "Portable version of NetBSD 'make'";
    homepage    = "http://www.crufty.net/help/sjg/bmake.html";
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
