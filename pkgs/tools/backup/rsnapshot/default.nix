{ fetchurl, stdenv, perl, openssh, rsync, logger }:

stdenv.mkDerivation rec {
  name = "rsnapshot-1.4.3";

  src = fetchurl {
    url = "https://rsnapshot.org/downloads/${name}.tar.gz";
    sha256 = "1lavqmmsf53pim0nvming7fkng6p0nk2a51k2c2jdq0l7snpl31b";
  };

  propagatedBuildInputs = [perl openssh rsync logger];

  configureFlags = [ "--sysconfdir=/etc --prefix=/" ];
  makeFlags = [ "DESTDIR=$(out)" ];

  patchPhase = ''
    substituteInPlace "Makefile.in" --replace \
      "/usr/bin/pod2man" "${perl}/bin/pod2man"
  '';

  meta = with stdenv.lib; {
    description = "A filesystem snapshot utility for making backups of local and remote systems";
    homepage = https://rsnapshot.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
