{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "croc";
  version = "8.0.11";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "09yx7xjhvpyvzwsf859b9yfrxzg01ak3dfavfhmx3h97lrdxprgi";
  };

  vendorSha256 = "1lqlrsd90475b1wp1krfppi635q5gw1ka8x4d8haanmnlnxkniqf";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description =
      "Easily and securely send things from one computer to another";
    homepage = "https://github.com/schollz/croc";
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
