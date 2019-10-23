{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "croc";
  version = "6.1.4";

  goPackagePath = "github.com/schollz/croc";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qqmyqkzg8gcib6zzva9zqlv22zpg4lwc3dqi6yyaynmdgy9pk1m";
  };

  modSha256 = "17vpfq3bsciq3vx5s2r3sv76aqsij3vvckqnk2w2sp346by5vavf";
  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "Easily and securely send things from one computer to another";
    homepage = https://github.com/schollz/croc;
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves ];

    longDescription = ''
      Croc is a command line tool written in Go that allows any two computers to
      simply and securely transfer files and folders.

      Croc does all of the following:
      - Allows any two computers to transfer data (using a relay)
      - Provides end-to-end encryption (using PAKE)
      - Enables easy cross-platform transfers (Windows, Linux, Mac)
      - Allows multiple file transfers
      - Allows resuming transfers that are interrupted
      - Does not require a server or port-forwarding
    '';
  };
}
