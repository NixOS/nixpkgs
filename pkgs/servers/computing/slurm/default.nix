{ stdenv, fetchurl, python, munge, perl, pam, openssl, mysql }:

#TODO: add sview support based on gtk2

stdenv.mkDerivation rec {
  name = "slurm-llnl-${version}";
  version = "14-11-5-1";

  src = fetchurl {
    url = "https://github.com/SchedMD/slurm/archive/slurm-${version}.tar.gz";
    sha256 = "0vn2jkj83zgc4j656vm24lihapg3w3sfnzpsmynlk4r0v9cy2vcw";
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
