{stdenv, fetchurl, ocaml, transitional ? false}:

let
  pname = "camlp5";
  webpage = http://pauillac.inria.fr/~ddr/camlp5/;
  metafile = ./META;
in

assert !stdenv.lib.versionOlder "4.00" ocaml.version;

stdenv.mkDerivation rec {

  name = "${pname}${if transitional then "_transitional" else ""}-${version}";
  version = "5.15";

  src = fetchurl {
    url = "${webpage}/distrib/src/${pname}-${version}.tgz";
    sha256 = "1sx5wlfpydqskm97gp7887p3avbl3vanlmrwj35wx5mbzj6kn9nq";
  };

  buildInputs = [ ocaml ];

  prefixKey = "-prefix ";

  preConfigure = "configureFlagsArray=(" +  (if transitional then "--transitional" else "--strict") +
                  " --libdir $out/lib/ocaml/${ocaml.version}/site-lib)";

  buildFlags = "world.opt";

  postInstall = "cp ${metafile} $out/lib/ocaml/${ocaml.version}/site-lib/camlp5/META";

  meta = {
    description = "Preprocessor-pretty-printer for OCaml";
    longDescription = ''
      Camlp5 is a preprocessor and pretty-printer for OCaml programs.
      It also provides parsing and printing tools.
    '';
    homepage = "${webpage}";
    license = stdenv.lib.licenses.bsd3;
    branch = "5";
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
