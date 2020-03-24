{ stdenv, buildGoModule, fetchFromGitHub, Security }:

buildGoModule rec {
  pname = "croc";
  version = "8.0.4";

  src = fetchFromGitHub {
    owner = "schollz";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dc6h102jr5dkg6r3xxma51g702dnyd3d6s5rilwv1fivxn3bj43";
  };

  modSha256 = "0ng4x9zmwax2vskbcadra4pdkgy1p1prmgkg1bjmh3b8rwsrhr0q";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

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
