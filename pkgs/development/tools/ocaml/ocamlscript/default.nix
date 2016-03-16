{stdenv, fetchurl, ocaml, findlib, camlp4}:
stdenv.mkDerivation {
  name = "ocamlscript-2.0.3";
  src = fetchurl {
    url = http://mjambon.com/releases/ocamlscript/ocamlscript-2.0.3.tar.gz;
    sha256 = "1v1i24gijxwris8w4hi95r9swld6dm7jbry0zp72767a3g5ivlrd";
  };

  propagatedBuildInputs = [ ocaml findlib camlp4 ];

  patches = [ ./Makefile.patch ];

  buildFlags = "PREFIX=$(out)";
  installFlags = "PREFIX=$(out)";

  preInstall = "mkdir $out/bin";
  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = http://martin.jambon.free.fr/ocamlscript.html;
    license = licenses.boost;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    description = "Natively-compiled OCaml scripts";
    maintainers = [ maintainers.vbgl ];
  };
}
