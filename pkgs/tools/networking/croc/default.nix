{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "croc";
  version = "6.4.7";

  goPackagePath = "github.com/schollz/croc";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "1i8g90sr5rk7flfxvmxca6z5vp9wh8zraf2lfz618s5axds3kb50";
  };

  modSha256 = "1w84xqnn9fnkakak6j069app4ybbxpwq79g8qypwvmqg5bhvzywg";
  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "Easily and securely send things from one computer to another";
    homepage = https://github.com/schollz/croc;
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves equirosa ];

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
