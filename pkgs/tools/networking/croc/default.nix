{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "croc";
  version = "8.0.5";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qc7na1c0c5i2r19vg54ggvcmnkyz024hqlbzgix2v5n6wlpk0fc";
  };

  modSha256 = "1y6qfb71vaard2l9fv83alprwpvii0pbzl8b3damd4j9x158hk7b";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "Easily and securely send things from one computer to another";
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
