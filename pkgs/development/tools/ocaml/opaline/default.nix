{ stdenv, fetchFromGitHub, ocamlPackages }:

stdenv.mkDerivation rec {
  version = "0.3.2";
  pname = "opaline";

  src = fetchFromGitHub {
    owner = "jaapb";
    repo = "opaline";
    rev = "v${version}";
    sha256 = "1aj1fdqymq3pnr39h47hn3kxk5v9pnwx0jap1z2jzh78x970z21m";
  };

  buildInputs = with ocamlPackages; [ ocaml findlib ocamlbuild opam-file-format ];

  preInstall = "mkdir -p $out/bin";

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "OPAm Light INstaller Engine";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocamlPackages.ocaml.meta) platforms;
  };
}
