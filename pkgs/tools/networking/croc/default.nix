{ lib, stdenv, buildGoModule, fetchFromGitHub, callPackage}:

buildGoModule rec {
  pname = "croc";
  version = "8.6.6";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bd7q3j2i0r3v4liv2xpqlvx4nrixpdhr1yy1c579bls7y4myv61";
  };

  vendorSha256 = "06hqb5r9p67zh0v5whdsb3rvax6461y2n6jkhjwmn6zzswpgkg7y";

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
