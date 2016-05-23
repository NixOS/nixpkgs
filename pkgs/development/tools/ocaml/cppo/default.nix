{ stdenv, fetchFromGitHub, ocaml, findlib }:
let
  pname = "cppo";
  version = "1.3.2";
  webpage = "http://mjambon.com/${pname}.html";
in
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.12";
stdenv.mkDerivation rec {

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "mjambon";
    repo = pname;
    rev = "v${version}";
    sha256 = "06j0zr78f04ahxi2459vjn61z25hkvs4dfj76200ydg3g6ifb3k1";
  };

  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  makeFlags = "PREFIX=$(out)";

  preBuild = ''
    mkdir $out/bin
  '';

  meta = with stdenv.lib; {
    description = "The C preprocessor for OCaml";
    longDescription = ''
      Cppo is an equivalent of the C preprocessor targeted at the OCaml language and its variants.
    '';
    homepage = "${webpage}";
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
