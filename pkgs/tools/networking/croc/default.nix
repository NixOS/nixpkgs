{ lib, buildGoModule, fetchFromGitHub, callPackage}:

buildGoModule rec {
  pname = "croc";
  version = "8.6.8";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ierNKZ14F3EKtQRdOd7D4jhaA7M6zwnFVSk6aUh4VPc=";
  };

  vendorSha256 = "sha256-F/Vxl9Z5LgAmnRt/FOdW9eVN7IVb1ZEKiYOSpT9+L0E=";

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
