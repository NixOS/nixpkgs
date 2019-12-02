{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "croc";
  version = "6.4.1";

  goPackagePath = "github.com/schollz/croc";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sil1gxml4p4yysm8x6bpv5m0hvw4ss27b4c9wdag06lav0g4am0";
  };

  modSha256 = "1w84xqnn9fnkakak6j069app4ybbxpwq79g8qypwvmqg5bhvzywg";
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
