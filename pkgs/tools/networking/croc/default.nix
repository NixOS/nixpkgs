{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "croc";
  version = "8.3.0";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kl6sbq0lzrvf4wzz5bvz81ncmfw5lm7pjr2r2xx4sws1w006nq2";
  };

  vendorSha256 = "0qfrc3c4fsg3w2zcpdr93ilknxhshcysvin029va154sq3zmggbn";

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
