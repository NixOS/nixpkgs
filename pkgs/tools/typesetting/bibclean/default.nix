{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "bibclean";
  version = "3.03";

  src = fetchurl {
    url = "http://ftp.math.utah.edu/pub/bibclean/bibclean-${version}.tar.xz";
    sha256 = "06ic9zix8gh1wz7hd1cnlxxyrp7sqs67a7xnv08r71b5ikri35a3";
  };

  postPatch = ''
    substituteInPlace Makefile.in --replace man/man1 share/man/man1
  '';

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "Prettyprint and syntax check BibTeX and Scribe bibliography data base files";
    homepage = "http://ftp.math.utah.edu/pub/bibclean";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
