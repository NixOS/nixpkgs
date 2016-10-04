{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "bibtool-${version}";
  version = "2.57";

  src = fetchurl {
    url = "http://www.gerd-neugebauer.de/software/TeX/BibTool/BibTool-${version}.tar.gz";
    sha256 = "1g3yqywnbg04imkcqx7ypq0din81vcgq90k2xlqih69blbqpfb5y";
  };

  # Perl for running test suite.
  buildInputs = [ perl ];

  installTargets = "install install.man";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Tool for manipulating BibTeX bibliographies";
    homepage = http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html;
    license = licenses.gpl1;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
