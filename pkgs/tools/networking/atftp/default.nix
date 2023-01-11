{ lib
, stdenv
, autoreconfHook
, fetchurl
, gcc
, makeWrapper
, pcre2
, perl
, ps
, readline
, tcp_wrappers
}:

stdenv.mkDerivation rec {
  pname = "atftp";
  version = "0.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/atftp/${pname}-${version}.tar.gz";
    hash = "sha256-3yqgicdnD56rQOVZjl0stqWC3FGCkm6lC01pDk438xY=";
  };

  # fix test script
  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];

  buildInputs = [
    gcc
    pcre2
    readline
    tcp_wrappers
  ];

  checkInputs = [
    perl
    ps
  ];

  # Expects pre-GCC5 inline semantics
  NIX_CFLAGS_COMPILE = "-std=gnu89";

  doCheck = true;

  meta = with lib; {
    description = "Advanced tftp tools";
    changelog = "https://sourceforge.net/p/atftp/code/ci/v${version}/tree/Changelog";
    homepage = "https://sourceforge.net/projects/atftp/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
