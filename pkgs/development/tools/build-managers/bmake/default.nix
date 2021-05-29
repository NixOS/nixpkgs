{ lib, stdenv, fetchurl
, getopt
}:

stdenv.mkDerivation rec {
  pname = "bmake";
  version = "20200902";

  src = fetchurl {
    url    = "http://www.crufty.net/ftp/pub/sjg/${pname}-${version}.tar.gz";
    sha256 = "1v1v81llsiy8qbpy38nml1x08dhrihwh040pqgwbwb9zy1108b08";
  };

  nativeBuildInputs = [ getopt ];

  patches = [
    ./bootstrap-fix.patch
    ./fix-unexport-env-test.patch
  ];

  # The generated makefile is a small wrapper for calling ./boot-strap
  # with a given op. On a case-insensitive filesystem this generated
  # makefile clobbers a distinct, shipped, Makefile and causes
  # infinite recursion during tests which eventually fail with
  # "fork: Resource temporarily unavailable"
  configureFlags = [
    "--without-makefile"
  ];

  buildPhase = ''
    runHook preBuild

    ./boot-strap --prefix=$out -o . op=build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./boot-strap --prefix=$out -o . op=install

    runHook postInstall
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Portable version of NetBSD 'make'";
    homepage    = "http://www.crufty.net/help/sjg/bmake.html";
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
