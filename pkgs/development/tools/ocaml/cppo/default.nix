{stdenv, fetchurl, ocaml, findlib}:
let
  pname = "cppo";
  version = "0.9.4";
  webpage = "http://mjambon.com/${pname}.html";
in
stdenv.mkDerivation rec {

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://mjambon.com/releases/${pname}/${name}.tar.gz";
    sha256 = "1m7cbja7cf74l45plqnmjrjjz55v8x65rvx0ikk9mg1ak8lcmvxa";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  makeFlags = "PREFIX=$(out)";

  preBuild = ''
    mkdir $out/bin
  '';

  meta = {
    description = "The C preprocessor for OCaml";
    longDescription = ''
      Cppo is an equivalent of the C preprocessor targeted at the OCaml language and its variants.
    '';
    homepage = "${webpage}";
    license = "bsd";
  };
}



