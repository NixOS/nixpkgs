{ lib, buildGoModule, fetchFromGitHub, callPackage}:

buildGoModule rec {
  pname = "croc";
  version = "8.6.11";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+ej6Q2XczWVcu7lMRjt+Sj2FZxlfFSepE6crCFgPuoc=";
  };

  vendorSha256 = "sha256-50ESG3GL9BcTaGp1Q5rc1XklF3H7WKcyM1yq7SZa2QE=";

  doCheck = false;

  subPackages = [ "." ];

  passthru = {
    tests = {
      local-relay = callPackage ./test-local-relay.nix {};
    };
  };
  meta = with lib; {
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
