{ stdenv, fetchFromGitHub, pcre } :

stdenv.mkDerivation {
  pname = "imatix_gsl";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "imatix";
    repo = "gsl";
    rev = "72192d0d9de17de08d9379602d6482b4e5d402d0";
    sha256 = "1apy11avgqc27xlczyjh15y10qjdyqsqab1wrl2067qgpdiy58w7";
  };

  buildInputs = [ pcre ];

  CCNAME = "cc";

  postPatch = "sed -e 's,/usr/bin/install,install,g' -i src/Makefile";
  preBuild = "cd src";
  installFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    license = licenses.gpl3Plus;
    homepage = https://github.com/imatix/gsl/;
    description = "A universal code generator";
    platforms = platforms.unix;
    maintainers = [ maintainers.moosingin3space ];
    broken = stdenv.isLinux; # 2018-04-10
  };
}
