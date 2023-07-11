{ stdenv, lib, fetchurl, ncurses, autoreconfHook }:
stdenv.mkDerivation rec {
  pname = "xstow";
  version = "1.1.0";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-wXQ5XSmogAt1torfarrqIU4nBYj69MGM/HBYqeIE+dw=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # Upstream seems to try to support building both static and dynamic version
  # of executable on dynamic systems, but fails with link error when attempting
  # to cross-build "xstow-static" to the system where "xstow" proper is static.
  postPatch = lib.optionalString stdenv.hostPlatform.isStatic ''
    substituteInPlace src/Makefile.am --replace xstow-static ""
    substituteInPlace src/Makefile.am --replace xstow-stow ""
  '';

  buildInputs = [
    ncurses
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A replacement of GNU Stow written in C++";
    homepage = "https://xstow.sourceforge.net";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ nzbr ];
    platforms = platforms.unix;
  };
}
