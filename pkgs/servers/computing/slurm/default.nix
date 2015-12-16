{ stdenv, fetchurl, python, munge, perl, pam, openssl, mysql }:

#TODO: add sview support based on gtk2

stdenv.mkDerivation rec {
  name = "slurm-llnl-${version}";
  version = "14.11.5";

  src = fetchurl {
    url = "http://www.schedmd.com/download/archive/slurm-${version}.tar.bz2";
    sha256 = "0xx1q9ximsyyipl0xbj8r7ajsz4xrxik8xmhcb1z9nv0aza1rff2";
  };

  buildInputs = [ python munge perl pam openssl mysql.lib ];

  configureFlags = ''
    --with-munge=${munge}
    --with-ssl=${openssl}
  '';

  preConfigure = ''
    substituteInPlace ./doc/html/shtml2html.py --replace "/usr/bin/env python" "${python.interpreter}"
    substituteInPlace ./doc/man/man2html.py --replace "/usr/bin/env python" "${python.interpreter}"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.schedmd.com/;
    description = "Simple Linux Utility for Resource Management";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.jagajaga ];
  };
}
