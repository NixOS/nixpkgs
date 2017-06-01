{ stdenv, fetchurl, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {
  name = "ocamlmod-${version}";
  version = "0.0.8";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/1544/${name}.tar.gz";
    sha256 = "1w0w8lfyymvk300dv13gvhrddpcyknvyp4g2yvq2vaw7khkhjs9g";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase     = "ocaml setup.ml -build";
  installPhase   = "ocaml setup.ml -install";

  dontStrip = true;

  meta = {
    homepage = http://forge.ocamlcore.org/projects/ocamlmod/ocamlmod;
    description = "Generate OCaml modules from source files";
    platforms = ocaml.meta.platforms or [];
    maintainers = with stdenv.lib.maintainers; [
      z77z
    ];
  };
}
