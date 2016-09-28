{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "datefudge";
  version = "1.2.1";
  name = "${pname}-${version}";

  src = fetchgit {
    sha256 = "0l83kn6c3jr3wzs880zfa64rw81cqjjk55gjxz71rjf2balp64ps";
    url = "git://anonscm.debian.org/users/robert/datefudge.git";
    rev = "cd141c63bebe9b579109b2232b5e83db18f222c2";
  };

  patchPhase = ''
    substituteInPlace Makefile \
     --replace "/usr" "/" \
     --replace "-o root -g root" ""
    substituteInPlace datefudge.sh \
     --replace "@LIBDIR@" "$out/lib/"
    '';

  preInstallPhase = "mkdir -P $out/lib/datefudge";

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = "chmod +x $out/lib/datefudge/datefudge.so";

  meta = with stdenv.lib; {
    description = "Fake the system date";
    longDescription = ''
      datefudge is a small utility that pretends that the system time is
      different by pre-loading a small library which modifies the time,
      gettimeofday and clock_gettime system calls.
    '';
    homepage = http://packages.qa.debian.org/d/datefudge.html;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
