{ fetchurl, lib, stdenv, perl, openssh, rsync, logger }:

stdenv.mkDerivation rec {
  pname = "rsnapshot";
  version = "1.4.4";

  src = fetchurl {
    url = "https://rsnapshot.org/downloads/rsnapshot-${version}.tar.gz";
    sha256 = "sha256-wct8t0jFqWVsOGNivfbCZ5WXN3JKu1Bfv56UCp2YhXk=";
  };

  propagatedBuildInputs = [perl openssh rsync logger];

  configureFlags = [ "--sysconfdir=/etc --prefix=/" ];
  makeFlags = [ "DESTDIR=$(out)" ];

  patchPhase = ''
    substituteInPlace "Makefile.in" --replace \
      "/usr/bin/pod2man" "${perl}/bin/pod2man"
  '';

  meta = with lib; {
    description = "A filesystem snapshot utility for making backups of local and remote systems";
    homepage = "https://rsnapshot.org/";
    license = lib.licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
