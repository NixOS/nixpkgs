{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "croc";
  version = "6.2.3";

  goPackagePath = "github.com/schollz/croc";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "13z3k0s7piwxxh87f04ldvxsd664jncwgmin397v5152bxadbgxp";
  };

  modSha256 = "0d9xhlszgy839naj4v2l613sn3nckx87cwwz1sh1rjwxarp8gqa9";
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
