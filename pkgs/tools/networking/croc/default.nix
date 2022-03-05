{ lib, buildGoModule, fetchFromGitHub, callPackage }:

buildGoModule rec {
  pname = "croc";
  version = "9.5.2";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ha84frbyRDxCRIDezlKeA+Fv9+rmpCoU+EAgMBkf3fo=";
  };

  vendorSha256 = "sha256-uaSDder/uzy708YE1xqpL9Te4629JD2IiVSCYhYzPwg=";

  doCheck = false;

  subPackages = [ "." ];

  passthru = {
    tests = {
      # test fails
      #local-relay = callPackage ./test-local-relay.nix { };
    };
  };
  meta = with lib; {
    description = "Easily and securely send things from one computer to another";
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
    homepage = "https://github.com/schollz/croc";
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves equirosa SuperSandro2000 ];
  };
}
