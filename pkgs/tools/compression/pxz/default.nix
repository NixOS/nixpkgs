{ lib
, stdenv
, fetchFromGitHub
, testers
, pxz
, xz
}:

stdenv.mkDerivation rec {
  pname = "pxz";
  version = "4.999.9beta";

  src = fetchFromGitHub {
    owner = "jnovy";
    repo = "pxz";
    rev = "124382a6d0832b13b7c091f72264f8f3f463070a";
    hash = "sha256-NYhPujm5A0j810IKUZEHru/oLXCW7xZf5FjjKAbatZY=";
  };

  patches = [ ./flush-stdout-help-version.patch ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace '`date +%Y%m%d`' '19700101'

    substituteInPlace pxz.c \
      --replace 'XZ_BINARY "xz"' 'XZ_BINARY "${lib.getBin xz}/bin/xz"'
  '';

  buildInputs = [ xz ];

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man"
  ];

  passthru.tests.version = testers.testVersion {
    package = pxz;
  };

  meta = with lib; {
    homepage = "https://jnovy.fedorapeople.org/pxz/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pashev ];
    description = "compression utility that runs LZMA compression of different parts on multiple cores simultaneously";
    longDescription = ''
      Parallel XZ is a compression utility that takes advantage of
      running LZMA compression of different parts of an input file on multiple
      cores and processors simultaneously. Its primary goal is to utilize all
      resources to speed up compression time with minimal possible influence
      on compression ratio
    '';
    mainProgram = "pxz";
    platforms = with platforms; linux;
  };
}
