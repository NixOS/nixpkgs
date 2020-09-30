{stdenv, fetchFromGitHub, gcc}:

stdenv.mkDerivation rec {
  pname = "nixadd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "JoeLancaster";
    repo = pname;
    rev = "v${version}";
    sha256 = "120jxmvalcb68qhywa1izlimchgvzgjpbdsv907iyd9fpmwli7kf";
  };
  installPhase = ''
                 mkdir -p $out
                 make DESTDIR=$out install
                 '';
  meta = with stdenv.lib; {
    homepage = "https://github.com/${owner}/${pname}";
    description = "Adds packages declaratively on the command line";
    licence = licence.gpl3;
    maintainers = with maintainers; [ joelancaster ];
  };
}

