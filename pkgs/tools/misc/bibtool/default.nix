{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "bibtool";
  version = "2.67";

  src = fetchurl {
    url = "http://www.gerd-neugebauer.de/software/TeX/BibTool/BibTool-${version}.tar.gz";
    sha256 = "116pv532mz0q954y5b7c6zipnamc05f0x7g5x1b674jsjxh42v2v";
  };

  # Perl for running test suite.
  buildInputs = [ perl ];

  installTargets = [ "install" "install.man" ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Tool for manipulating BibTeX bibliographies";
    homepage = http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
