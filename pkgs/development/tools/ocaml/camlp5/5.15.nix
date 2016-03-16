{stdenv, fetchurl, ocaml, transitional ? false}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "camlp5";
  version = "5.15";
  webpage = http://pauillac.inria.fr/~ddr/camlp5/;
  metafile = ./META;
in

assert !stdenv.lib.versionOlder "4.00" ocaml_version;

stdenv.mkDerivation {

  name = "${pname}${if transitional then "_transitional" else ""}-${version}";

  src = fetchurl {
    url = "${webpage}/distrib/src/${pname}-${version}.tgz";
    sha256 = "1sx5wlfpydqskm97gp7887p3avbl3vanlmrwj35wx5mbzj6kn9nq";
  };

  buildInputs = [ ocaml ];

  prefixKey = "-prefix ";

  preConfigure = "configureFlagsArray=(" +  (if transitional then "--transitional" else "--strict") +
                  " --libdir $out/lib/ocaml/${ocaml_version}/site-lib)";

  buildFlags = "world.opt";

  postInstall = "cp ${metafile} $out/lib/ocaml/${ocaml_version}/site-lib/camlp5/META";

  meta = {
    description = "Preprocessor-pretty-printer for OCaml";
    longDescription = ''
      Camlp5 is a preprocessor and pretty-printer for OCaml programs.
      It also provides parsing and printing tools.
    '';
    homepage = "${webpage}";
    license = stdenv.lib.licenses.bsd3;
    branch = "5";
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
