{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "bibclean";
  version = "3.04";

  src = fetchurl {
    url = "http://ftp.math.utah.edu/pub/bibclean/bibclean-${version}.tar.xz";
    sha256 = "0n5jb6w86y91q5lkcc9sb1kh4c2bk3q2va24gfr0n6v1jzyqp9jg";
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
