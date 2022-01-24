{lib, stdenv, fetchurl, ocaml, findlib, camlp4}:
stdenv.mkDerivation rec {
  pname = "ocamlscript";
  version = "2.0.3";
  src = fetchurl {
    url = "https://mjambon.com/releases/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1v1i24gijxwris8w4hi95r9swld6dm7jbry0zp72767a3g5ivlrd";
  };

  propagatedBuildInputs = [ ocaml findlib camlp4 ];

  patches = [ ./Makefile.patch ];

  buildFlags = [ "PREFIX=$(out)" ];
  installFlags = [ "PREFIX=$(out)" ];

  preInstall = "mkdir $out/bin";
  createFindlibDestdir = true;

  meta = with lib; {
    homepage = "http://martin.jambon.free.fr/ocamlscript.html";
    license = licenses.boost;
    platforms = ocaml.meta.platforms or [];
    description = "Natively-compiled OCaml scripts";
    maintainers = [ maintainers.vbgl ];
  };
}
