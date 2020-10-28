{ stdenv, buildGoModule, fetchFromGitHub, callPackage}:

buildGoModule rec {
  pname = "croc";
  version = "8.5.2";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i71p3cwm8w3zlw10if3cbpfb65rq407nw4yva1l58ck7sbp61ha";
  };

  vendorSha256 = "0afg645hs7lf3036c2g6sn956zz9s08r747c0czb1aj0jrbf7fs8";

  doCheck = false;

  subPackages = [ "." ];

  passthru = {
    tests = {
      local-relay = callPackage ./test-local-relay.nix {};
    };
  };
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
