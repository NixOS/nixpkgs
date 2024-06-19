{ lib, stdenv, fetchgit, makeWrapper, coreutils }:

stdenv.mkDerivation rec {
  pname = "datefudge";
  version = "1.26";

  src = fetchgit {
    url = "https://salsa.debian.org/debian/${pname}.git";
    rev = "debian/${version}";
    sha256 = "sha256-CVy5mOX3jNM1cNIn8HhVs8Mhh70pkz9pG08muFuPNfk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ coreutils ];

  postPatch = ''
    substituteInPlace Makefile \
     --replace "/usr" "/" \
     --replace "-o root -g root" ""
    substituteInPlace datefudge.sh \
     --replace "@LIBDIR@" "$out/lib/"
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    chmod +x $out/lib/datefudge/datefudge.so
    wrapProgram $out/bin/datefudge --prefix PATH : ${coreutils}/bin
  '';

  meta = with lib; {
    description = "Fake the system date";
    longDescription = ''
      datefudge is a small utility that pretends that the system time is
      different by pre-loading a small library which modifies the time,
      gettimeofday and clock_gettime system calls.
    '';
    homepage = "https://packages.qa.debian.org/d/datefudge.html";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
    mainProgram = "datefudge";
  };
}
