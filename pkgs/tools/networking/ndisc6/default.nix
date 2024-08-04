{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "ndisc6";
  version = "1.0.4";

  src = fetchurl {
    url = "https://www.remlab.net/files/ndisc6/archive/ndisc6-${version}.tar.bz2";
    sha256 = "07swyar1hl83zxmd7fqwb2q0c0slvrswkcfp3nz5lknrk15dmcdb";
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

  meta = with lib; {
    homepage = "https://www.remlab.net/ndisc6/";
    description = "Small collection of useful tools for IPv6 networking";
    maintainers = with maintainers; [ eelco ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}
