{ stdenv, buildGoModule, fetchFromGitHub, callPackage}:

buildGoModule rec {
  pname = "croc";
  version = "8.6.5";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lzprv4qbmv2jjjp02z87819k54wdlsf8i6zvl3vchkqvygdkk6v";
  };

  vendorSha256 = "02mai9bp9pizbq6b8dj05rngxp3lfm9gh37zs8jknx56gas90j9i";

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
