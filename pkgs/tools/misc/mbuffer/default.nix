{ lib
, stdenv
, fetchurl
, openssl
, makeWrapper
, which
, gcc-unwrapped
}:

stdenv.mkDerivation rec {
  pname = "mbuffer";
  version = "20220418";

  src = fetchurl {
    url = "http://www.maier-komor.de/software/mbuffer/mbuffer-${version}.tgz";
    sha256 = "sha256-blgB+fX/EURdHQMCi1oDzQivVAhpe3+UxCeDMiijAMc=";
  };

  buildInputs = [
    openssl
  ];
  nativeBuildInputs = [
    makeWrapper
    which
  ];

  postFixup = ''
    # Fix missing libgcc_s.so.1 (needed for cross-compiled binaries).
    wrapProgram "$out/bin/mbuffer" \
      --prefix LD_LIBRARY_PATH ":" "${lib.makeLibraryPath [ gcc-unwrapped ]}"
  '';

  doCheck = true;

  meta = with lib; {
    description  = "A tool for buffering data streams with a large set of unique features";
    homepage = "https://www.maier-komor.de/mbuffer.html";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ tokudan ];
    platforms = platforms.linux; # Maybe other non-darwin Unix
  };
}
