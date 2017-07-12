{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "ndisc6-1.0.3";

  src = fetchurl {
    url = "http://www.remlab.net/files/ndisc6/archive/${name}.tar.bz2";
    sha256 = "08f8xrsck2ykszp12yxx4ssf6wnkn7l6m59456hw3vgjyp5dch8g";
  };

  buildInputs = [ perl ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--disable-suid-install"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=$(TMPDIR)"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.remlab.net/ndisc6/;
    description = "A small collection of useful tools for IPv6 networking";
    maintainers = with maintainers; [ eelco wkennington ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
