args:
args.stdenv.mkDerivation {
  name = "";

  src = args.fetchurl {
    url = ;
    sha256 = "";
  };

  buildInputs =(with args; []);

  meta = {
    description = "

";
  };
}
