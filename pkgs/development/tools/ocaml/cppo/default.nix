{stdenv, fetchurl, ocaml, findlib}:
let
  pname = "cppo";
  version = "1.1.2";
  webpage = "http://mjambon.com/${pname}.html";
in
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.12";
stdenv.mkDerivation rec {

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://mjambon.com/releases/${pname}/${name}.tar.gz";
    sha256 = "1pfzch4ys5gjac2lrkqq0gzmm5plkq2jl17b2m3n06kmwashqplp";
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
