{ fetchurl, stdenv, writeText, perl, openssh, rsync, logger }:

stdenv.mkDerivation rec {
  name = "rsnapshot-1.4.2";

  src = fetchurl {
    url = "http://rsnapshot.org/downloads/${name}.tar.gz";
    sha256 = "05jfy99a0xs6lvsjfp3wz21z0myqhmwl2grn3jr9clijbg282ah4";
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
    homepage = http://rsnapshot.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
