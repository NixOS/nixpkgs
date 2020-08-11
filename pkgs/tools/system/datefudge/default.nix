{ stdenv, fetchgit, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "datefudge";
  version = "1.24";

  src = fetchgit {
    url = "https://salsa.debian.org/debian/${pname}.git";
    rev = "debian/${version}";
    sha256 = "1nh433yx4y4djp0bs6aawqbwk7miq7fsbs9wpjlyh2k9dvil2lrm";
  };

  postPatch = ''
    substituteInPlace Makefile \
     --replace "/usr" "/" \
     --replace "-o root -g root" ""
    substituteInPlace datefudge.sh \
     --replace "@LIBDIR@" "$out/lib/"
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = "chmod +x $out/lib/datefudge/datefudge.so";

  meta = with stdenv.lib; {
    description = "Fake the system date";
    longDescription = ''
      datefudge is a small utility that pretends that the system time is
      different by pre-loading a small library which modifies the time,
      gettimeofday and clock_gettime system calls.
    '';
    homepage = "https://packages.qa.debian.org/d/datefudge.html";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
