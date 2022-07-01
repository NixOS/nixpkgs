{ lib, buildGoModule, fetchFromGitHub, callPackage }:

buildGoModule rec {
  pname = "croc";
  version = "9.5.6";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VXbrwUf43qvXd+/GXNA+Wkt4E5EM4+1V0wPj3JONzlU=";
  };

  vendorSha256 = "sha256-45rQHG5Std7m7Xu8OEFfjdG6RyriM4yAPzJl7M2lPW8=";

  subPackages = [ "." ];

  passthru = {
    tests = {
      local-relay = callPackage ./test-local-relay.nix { };
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
