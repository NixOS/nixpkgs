{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "tinyssh";
  version = "20230101";

  src = fetchFromGitHub {
    owner = "janmojzis";
    repo = "tinyssh";
    rev = "refs/tags/${version}";
    hash = "sha256-yEqPrLp14AF0L1QLoIcBhTphmd6qVzOB9EVW0Miy8yM=";
  };

  preConfigure = ''
    echo /bin       > conf-bin
    echo /share/man > conf-man
  '';

  DESTDIR = placeholder "out";

  meta = with lib; {
    description = "Minimalistic SSH server";
    homepage = "https://tinyssh.org";
    changelog = "https://github.com/janmojzis/tinyssh/releases/tag/${version}";
    license = licenses.cc0;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kaction ];
  };
}
