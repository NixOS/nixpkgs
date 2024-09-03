{ lib, buildGoModule, fetchFromGitHub, callPackage, nixosTests }:

buildGoModule rec {
  pname = "croc";
  version = "10.0.11";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vW67Q/11BPRHkDA1m99+PdxQUoylMt2sx6gZFEzgSNY=";
  };

  vendorHash = "sha256-eejDwlovkGLENvNywtFPmqKcwqr+HB+oURL/sDfhOuA=";

  subPackages = [ "." ];

  passthru = {
    tests = {
      local-relay = callPackage ./test-local-relay.nix { };
      inherit (nixosTests) croc;
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
    mainProgram = "croc";
  };
}
