{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "croc";
  version = "8.5.0";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c8gj4fv5q8zl48lfvw06rxng2scgivb6zls136kxq5f2fb2dyk5";
  };

  vendorSha256 = "0cgvbwxscmqjzva0bp5sqb4hnvk2ww50yqw34iya5lk2db9vn3ha";

  doCheck = false;

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
